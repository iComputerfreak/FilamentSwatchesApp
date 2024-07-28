//
//  UserData.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import Foundation
import Logging
import SwiftUI

class UserData: ObservableObject {
    private enum Constants {
        static let swatchesKey: String = "swatches"
        static let materialsKey: String = "materials"
        static let swatchHistoryKey: String = "swatchHistory"
        static let baseURLKey: String = "baseURL"
    }
    
    private static let userDefaults: UserDefaults = .standard
    private static let encoder = PropertyListEncoder()
    private static let decoder = PropertyListDecoder()
    
    @Published var swatches: [Swatch]
    @Published var materials: [FilamentMaterial]
    @Published var swatchHistory: [Swatch]
    // TODO: Move to separate Config service
    @Published var baseURL: String
    
    @Injected private var logger: Logger
    
    init() {
        do {
            // We cannot use the injected logger here, since it's not available yet
            let logger = ConsoleLogger()
            logger.debug("Decoding swatches...", category: .userData)
            if let swatchesData = Self.userDefaults.object(forKey: Constants.swatchesKey) as? Data, !swatchesData.isEmpty {
                self.swatches = try Self.decoder.decode([Swatch].self, from: swatchesData)
            } else {
                self.swatches = []
            }
            
            logger.debug("Decoding materials...", category: .userData)
            if let materialsData = Self.userDefaults.object(forKey: Constants.materialsKey) as? Data, !materialsData.isEmpty {
                // TODO: Remove migration after deployed
                if let legacyMaterials = try? Self.decoder.decode([String].self, from: materialsData) {
                    self.materials = legacyMaterials.map { FilamentMaterial(name: $0) }
                } else {
                    self.materials = try Self.decoder.decode([FilamentMaterial].self, from: materialsData)
                }
            } else {
                self.materials = []
            }
            
            logger.debug("Decoding swatch history...", category: .userData)
            if let swatchHistoryData = Self.userDefaults.object(forKey: Constants.swatchHistoryKey) as? Data, !swatchHistoryData.isEmpty {
                self.swatchHistory = try Self.decoder.decode([Swatch].self, from: swatchHistoryData)
            } else {
                self.swatchHistory = []
            }
            
            // TODO: Move defaultBaseURL somewhere else or make baseURL optional
            self.baseURL = Self.userDefaults.string(forKey: Constants.baseURLKey) ?? "https://filamentswatch.info"
        } catch {
            fatalError("\(error)")
        }
    }
    
    func save() {
        do {
            let swatchesData = try Self.encoder.encode(self.swatches)
            let materialsData = try Self.encoder.encode(self.materials)
            let swatchHistoryData = try Self.encoder.encode(self.swatchHistory)
            
            Self.userDefaults.set(swatchesData, forKey: Constants.swatchesKey)
            Self.userDefaults.set(materialsData, forKey: Constants.materialsKey)
            Self.userDefaults.set(swatchHistoryData, forKey: Constants.swatchHistoryKey)
            Self.userDefaults.set(baseURL, forKey: Constants.baseURLKey)
        } catch {
            logger.error("Error saving user data: \(error)", category: .userData)
        }
    }
}
