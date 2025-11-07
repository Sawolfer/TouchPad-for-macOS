//
//  TouchpadScreenBuilder.swift
//  tap&send
//
//  Created by Савва Пономарев on 08.09.2025.
//
#if os(iOS)
import SwiftUI

enum TouchpadScreenBuilder {
    static func build(
        viewModel: MainScreenViewModelIOS
    ) -> TouchpadScreenView {
        let touchpadVM = TouchpadScreenViewModel(mvViewModel: viewModel)

        return TouchpadScreenView(viewModel: touchpadVM)
    }
}
#endif
