// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

@Observable
class FilamentMaterial: Codable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        // swiftlint:disable identifier_name
        case _id = "id"
        case _name = "name"
        // swiftlint:enable identifier_name
    }
    
    var id: UUID = .init()
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: ._id) ?? UUID()
        self._name = try container.decode(String.self, forKey: ._name)
    }
    
    static func == (lhs: FilamentMaterial, rhs: FilamentMaterial) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
