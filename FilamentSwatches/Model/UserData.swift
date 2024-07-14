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
    private static let swatchesKey: String = "swatches"
    private static let materialsKey: String = "materials"
    private static let swatchHistoryKey: String = "swatchHistory"
    private static let baseURLKey: String = "baseURL"
    
    static let maxHistoryItems: Int = 10
    
    private static let userDefaults: UserDefaults = .standard
    private static let encoder = PropertyListEncoder()
    private static let decoder = PropertyListDecoder()
    
    static let shared: UserData = .init()
    
    @Published var swatches: [Swatch]
    @Published var materials: [FilamentMaterial]
    @Published var swatchHistory: [Swatch]
    @Published var baseURL: String
    
    @Injected private var logger: Logger
    
    init() {
        do {
            if let swatchesData = Self.userDefaults.object(forKey: Self.swatchesKey) as? Data, !swatchesData.isEmpty {
                self.swatches = try Self.decoder.decode([Swatch].self, from: swatchesData)
            } else {
                self.swatches = []
            }
            
            if let materialsData = Self.userDefaults.object(forKey: Self.materialsKey) as? Data, !materialsData.isEmpty {
                // TODO: Remove migration after deployed
                if let legacyMaterials = try? Self.decoder.decode([String].self, from: materialsData) {
                    self.materials = legacyMaterials.map { FilamentMaterial(name: $0) }
                } else {
                    self.materials = try Self.decoder.decode([FilamentMaterial].self, from: materialsData)
                }
            } else {
                self.materials = []
            }
            
            if let swatchHistoryData = Self.userDefaults.object(forKey: Self.swatchHistoryKey) as? Data, !swatchHistoryData.isEmpty {
                self.swatchHistory = try Self.decoder.decode([Swatch].self, from: swatchHistoryData)
            } else {
                self.swatchHistory = []
            }
            
            self.baseURL = Self.userDefaults.string(forKey: Self.baseURLKey) ?? GlobalConstants.DefaultValues.baseURL
        } catch {
            fatalError("\(error)")
        }
    }
    
    func save() {
        do {
            let swatchesData = try Self.encoder.encode(self.swatches)
            let materialsData = try Self.encoder.encode(self.materials)
            let swatchHistoryData = try Self.encoder.encode(self.swatchHistory)
            
            Self.userDefaults.set(swatchesData, forKey: Self.swatchesKey)
            Self.userDefaults.set(materialsData, forKey: Self.materialsKey)
            Self.userDefaults.set(swatchHistoryData, forKey: Self.swatchHistoryKey)
            Self.userDefaults.set(baseURL, forKey: Self.baseURLKey)
        } catch {
            logger.error("Error saving user data: \(error)", category: .persistence)
        }
    }
}
