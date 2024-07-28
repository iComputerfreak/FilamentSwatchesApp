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

@Observable
final class UserData {
    private enum Constants {
        static let swatchesKey: String = "swatches"
        static let materialsKey: String = "materials"
        static let swatchHistoryKey: String = "swatchHistory"
        static let baseURLKey: String = "baseURL"
        
        static let defaultBaseURL: String = "https://filamentswatch.info"
    }
    
    private static let userDefaults: UserDefaults = .standard
    private static let encoder = PropertyListEncoder()
    private static let decoder = PropertyListDecoder()
    
    var swatches: [Swatch]
    var materials: [FilamentMaterial]
    var swatchHistory: [Swatch]
    // TODO: Move to separate Config service
    var baseURL: String
    
    @ObservationIgnored
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
            self.baseURL = Self.userDefaults.string(forKey: Constants.baseURLKey) ?? Constants.defaultBaseURL
        } catch {
            fatalError("\(error)")
        }
        
        // Clean up after migrating to version 1.4.0
        for swatch in swatches {
            if !materials.contains(swatch.material) {
                if let material = materials.first(where: \.name, equals: swatch.material.name) {
                    // Try to find a material matching by name first
                    swatch.material = material
                } else {
                    // Otherwise add the material to the list of materials
                    materials.append(swatch.material)
                }
            }
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
    
    func importSwatch(_ swatch: Swatch) {
        guard !swatches.contains(where: { $0.arePropertiesEqual(to: swatch) }) else {
            logger.warning(
                "Trying to add a swatch that is already in the library: \(swatch.descriptiveName)",
                category: .userData
            )
            return
        }
        
        // Create a modifyable copy of the swatch
        let swatchCopy = swatch.copy()
        
        // Map the material to an existing one or add the material to the list of available materials
        if let material = materials.first(where: { $0.name == swatch.material.name }) {
            swatchCopy.material = material
        } else {
            materials.append(swatch.material)
        }
        
        swatches.append(swatchCopy)
    }
}
