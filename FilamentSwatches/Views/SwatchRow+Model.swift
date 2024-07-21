// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Logging
import SwiftUI

extension SwatchRow {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        @ObservationIgnored
        @Injected private var logger: Logger
        
        let swatch: Swatch
        
        @ObservationIgnored
        @Binding var editingSwatch: Swatch?
        
        @ObservationIgnored
        @Binding var selectedSwatch: Swatch?
        
        init(
            swatch: Swatch,
            editingSwatch: Binding<Swatch?>,
            selectedSwatch: Binding<Swatch?>
        ) {
            self.swatch = swatch
            self._editingSwatch = editingSwatch
            self._selectedSwatch = selectedSwatch
        }
        
        func selectSwatch() {
            selectedSwatch = swatch
        }
        
        func editSwatch() {
            logger.debug("Editing swatch \(swatch.descriptiveName)", category: .file())
            editingSwatch = swatch
        }
        
        func deleteSwatch() {
            logger.debug("Removing swatch \(swatch.descriptiveName)", category: .file())
            userData.swatches.removeAll { $0.id == swatch.id }
            userData.save()
        }
    }
}
