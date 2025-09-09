//
//  BackgroundView.swift
//  tap&send
//
//  Created by Савва Пономарев on 03.09.2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .fill(.mainBackground)
        }
        .ignoresSafeArea()
        .containerRelativeFrame([.horizontal, .vertical])
    }
}

struct BackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                BackgroundView()
            }
    }
}

extension View {
    func dotsBackground() -> some View {
        modifier(BackgroundViewModifier())
    }
}
