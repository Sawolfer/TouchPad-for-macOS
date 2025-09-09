//
//  CommingSoonView.swift
//  tap&send
//
//  Created by Савва Пономарев on 09.09.2025.
//

import SwiftUI

struct CommingSoonView: View {

    @Environment(\.dismiss) var dissmiss

    var body: some View {
        ScrollView{
            VStack {
                Text(LocalizedStringKey(
                    stringLiteral: (String(localized: "CommingSoon")))
                )
                .foregroundStyle(.yellow)
            }
        }
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .dotsBackground()
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button {
                    dissmiss.callAsFunction()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.yellow)
                }
            })
            ToolbarItem(placement: .principal) {
                Text("Comming Soon")
                    .foregroundStyle(.yellow)
                    .fontWeight(.black)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
