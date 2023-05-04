//
//  UserData.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    
    private static let swatchesKey = "swatches"
    private static let materialsKey = "materials"
    private static let swatchHistoryKey = "swatchHistory"
    private static let baseURLKey = "baseURL"
    
    static let maxHistoryItems = 10
    
    private static let userDefaults = UserDefaults.standard
    private static let encoder = PropertyListEncoder()
    private static let decoder = PropertyListDecoder()
    
    static let shared: UserData = .init()
    
    @Published var swatches: [Swatch]
    @Published var materials: [String]
    @Published var swatchHistory: [Swatch]
    @Published var baseURL: String
    
    init() {
        do {
            if let swatchesData = Self.userDefaults.object(forKey: Self.swatchesKey) as? Data, !swatchesData.isEmpty {
                self.swatches = try Self.decoder.decode([Swatch].self, from: swatchesData)
            } else {
                self.swatches = []
            }
            
            if let materialsData = Self.userDefaults.object(forKey: Self.materialsKey) as? Data, !materialsData.isEmpty {
                self.materials = try Self.decoder.decode([String].self, from: materialsData)
            } else {
                self.materials = []
            }
            
            if let swatchHistoryData = Self.userDefaults.object(forKey: Self.swatchHistoryKey) as? Data, !swatchHistoryData.isEmpty {
                self.swatchHistory = try Self.decoder.decode([Swatch].self, from: swatchHistoryData)
            } else {
                self.swatchHistory = []
            }
            
            self.baseURL = Self.userDefaults.string(forKey: Self.baseURLKey) ?? "https://filamentswatch.info/index.php"
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
            print(error)
        }
    }
    
}
