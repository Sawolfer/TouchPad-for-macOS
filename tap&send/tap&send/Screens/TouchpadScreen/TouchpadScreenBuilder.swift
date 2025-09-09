//
//  TouchpadScreenBuilder.swift
//  tap&send
//
//  Created by Савва Пономарев on 08.09.2025.
//

import SwiftUI

enum TouchpadScreenBuilder {
    static func build(
        viewModel: MainScreenViewModel
    ) -> TouchpadScreenView {
        let touchpadVM = TouchpadScreenViewModel(mvViewModel: viewModel)

        return TouchpadScreenView(viewModel: touchpadVM)
    }
}
