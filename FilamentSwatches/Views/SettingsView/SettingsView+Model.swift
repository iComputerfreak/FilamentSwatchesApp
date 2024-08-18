// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension SettingsView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        private enum Constants {
            static let defaultBaseURL: String = "https://filamentswatch.info"
        }
        
        @ObservationIgnored
        @Injected private var userData: UserData
        
        let defaultBaseURL: String = Constants.defaultBaseURL
        var isShowingBaseURLInfoSheet: Bool = false
        
        @ObservationIgnored
        var baseURL: String {
            didSet {
                userData.baseURL = baseURL
                userData.save()
            }
        }
        
        init() {
            baseURL = ""
            baseURL = userData.baseURL
        }
    }
}
