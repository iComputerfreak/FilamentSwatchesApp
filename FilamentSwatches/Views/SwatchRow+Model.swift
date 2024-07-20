// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension SwatchRow {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
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
            editingSwatch = swatch
        }
        
        func deleteSwatch() {
            userData.swatches.removeAll { $0.id == swatch.id }
            userData.save()
        }
    }
}
