//
//  TemperatureTextField.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct TemperatureTextField: View {
    let label: LocalizedStringKey
    @Binding var value: Int
    
    // swiftlint:disable:next type_contents_order
    init(_ label: LocalizedStringKey, value: Binding<Int>) {
        self.label = label
        self._value = value
    }
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("Temp", value: $value, format: .number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
            Text("°C")
        }
    }
}

struct TemperatureTextField_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureTextField("Extruder Temp", value: .constant(0))
    }
}
