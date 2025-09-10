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
                Paragraph(header: (String(localized: "CommingSoon-generalInfo-header")), text: (String(localized: "CommingSoon-generalInfo-text")))
                Paragraph(header: (String(localized: "CommingSoon-features-header")), text: (String(localized: "CommingSoon-features-text")))
                Paragraph(header: (String(localized: "CommingSoon-available-now-header")), text: (String(localized: "CommingSoon-available-now-text")))
                Paragraph(header: String(localized: "Gratitude-header"), text: (String(localized: "Gratitude-text")))
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 5)
        .dotsBackground()
        .navigationBarBackButtonHidden()
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
