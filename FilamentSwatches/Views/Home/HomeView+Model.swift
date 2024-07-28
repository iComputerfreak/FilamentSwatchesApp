// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation
import Logging

extension HomeView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        @ObservationIgnored
        @Injected private var logger: Logger
        
        var presentedSwatch: Swatch? {
            didSet {
                logger.debug("Presenting swatch: \(presentedSwatch?.descriptiveName ?? "nil")", category: .viewLifecycle)
            }
        }
        
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
