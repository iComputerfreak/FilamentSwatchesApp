// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

struct FilamentMaterial: Codable, Hashable, Identifiable {
    var id: UUID = .init()
    var name: String
}
