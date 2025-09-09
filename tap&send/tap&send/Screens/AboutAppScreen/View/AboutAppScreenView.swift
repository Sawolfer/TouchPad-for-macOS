//
//  AboutAppScreenVeiw.swift
//  tap&send
//
//  Created by Савва Пономарев on 09.09.2025.
//

import SwiftUI

struct AboutAppScreenView: View {

    @Environment(\.dismiss) var dissmiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView{
            VStack {
                Text(LocalizedStringKey(
                    stringLiteral: (String(localized: "README")))
                )
                .foregroundStyle(.yellow)
                .environment(\.openURL, OpenURLAction { url in
                    openURL(url)
                    return .handled
                })
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
                Text("About App")
                    .foregroundStyle(.yellow)
                    .fontWeight(.black)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Preview Provider
struct AboutAboutScreenPreview: PreviewProvider {

    static var previews: some View {
        AboutAppScreenView()
    }

}
