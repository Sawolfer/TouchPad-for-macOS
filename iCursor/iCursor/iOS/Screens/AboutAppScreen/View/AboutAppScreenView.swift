//
//  AboutAppScreenVeiw.swift
//  tap&send
//
//  Created by Савва Пономарев on 09.09.2025.
//

#if os(iOS)
import SwiftUI

struct AboutAppScreenView: View {

    @Environment(\.dismiss) var dissmiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView{
            VStack {
//                Text(LocalizedStringKey(
//                    stringLiteral: (String(localized: "README")))
//                )
                Paragraph(header: (String(localized: "About-header")), text: (String(localized: "About-text")))
                Paragraph(header: (String(localized: "On-Mac-header")), text: (String(localized: "On Mac-text")))
                Paragraph(header: (String(localized: "On-iPhone-header")), text: (String(localized: "On iPhone-text")))
                Paragraph(header: (String(localized: "Usage-header")), text: (String(localized: "Usage-text")))
                Paragraph(header: (String(localized: "App-benefits-header")), text: (String(localized: "App Benefits-text")))
                Paragraph(header: (String(localized: "Need-help?-header")), text: (String(localized: "Need Help?-text")))
            }
        }
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .padding(.horizontal, 5)
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
#endif
