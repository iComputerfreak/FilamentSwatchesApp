// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation

extension HomeView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        var presentedSwatch: Swatch?
        
        var swatchHistory: [Swatch] {
            userData.swatchHistory
        }
        
        init() {}
        
        func deleteHistoryItems(at indexSet: IndexSet) {
            userData.swatchHistory.remove(atOffsets: indexSet)
            userData.save()
        }
    }
}
