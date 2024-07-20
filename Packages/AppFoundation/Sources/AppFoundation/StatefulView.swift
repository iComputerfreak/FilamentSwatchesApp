// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

public protocol StatefulView: View {
    associatedtype ViewModel: ViewModelProtocol
    
    var viewModel: ViewModel { get }
}
