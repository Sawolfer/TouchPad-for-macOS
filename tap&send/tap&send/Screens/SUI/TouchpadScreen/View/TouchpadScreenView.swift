//
//  TouchpadScreenView.swift
//  tap&send
//
//  Created by Савва Пономарев on 06.09.2025.
//

import SwiftUI

enum ViewConstraint {
    case leftBottom
    case leftTop
    case rightTop
    case rightBottom
}

struct TouchpadScreenView: View {

    @Environment(\.dismiss) var dismiss
    @State var openedMenu = false
    @State var menuConstraint: ViewConstraint = .leftTop

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            menuCircle
                .padding()
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            isDragging = true
                            dragOffset = value.translation
                        })
                        .onEnded({ value in
                            isDragging = false
                            snapToNearestCorner(value: value)
                            dragOffset = .zero
                        })
                )
        }
        .dotsBackground()
        .contentShape(Rectangle())
    }

    var menuCircle: some View {
        VStack(spacing: 20) {
            closeMenuButton

            if openedMenu {
                menuCircleOpened
            }
        }
        .foregroundStyle(.yellow)
        .fontWeight(.medium)
        .padding()
        .glass(cornerRadius: 50)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: alignmentForConstraint(menuConstraint)
        )
        .offset(dragOffset)
        .scaleEffect(isDragging ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    isDragging = true
                    dragOffset = value.translation
                })
                .onEnded({ value in
                    isDragging = false
                    snapToNearestCorner(value: value)
                    dragOffset = .zero
                })
        )
    }

    private func alignmentForConstraint(_ constraint: ViewConstraint) -> Alignment {
        switch constraint {
            case .leftBottom:
                return .bottomLeading
            case .leftTop:
                return .topLeading
            case .rightTop:
                return .topTrailing
            case .rightBottom:
                return .bottomTrailing
        }
    }

    private func snapToNearestCorner(value: DragGesture.Value) {
        let location = value.location
        let velocity = value.velocity

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let isLeftHalf = location.x < screenWidth / 2
        let isTopHalf = location.y < screenHeight / 2

        var newConstraint: ViewConstraint

        if abs(velocity.width) > abs(velocity.height) {
            if velocity.width > 0 {
                newConstraint = isTopHalf ? .rightTop : .rightBottom
            } else {
                newConstraint = isTopHalf ? .leftTop : .leftBottom
            }
        } else {
            if velocity.height > 0 {
                newConstraint = isLeftHalf ? .leftBottom : .rightBottom
            } else {
                newConstraint = isLeftHalf ? .leftTop : .rightTop
            }
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            menuConstraint = newConstraint
        }
    }

    var menuCircleOpened: some View {
        VStack(spacing: 20){
            dismissButton
        }
    }

    var closeMenuButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                openedMenu.toggle()
            }
        } label: {
            Image(systemName: "sidebar.squares.trailing")
                .font(.largeTitle)
        }
        .buttonStyle(.plain)
    }

    var dismissButton: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "chevron.left.circle")
                .font(.largeTitle)
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview Provider
struct TouchpadScreenPreview: PreviewProvider {

    static var previews: some View {
        TouchpadScreenView()
    }
}
