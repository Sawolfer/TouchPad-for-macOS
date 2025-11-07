//
//  Paragraph.swift
//  tap&send
//
//  Created by Савва Пономарев on 10.09.2025.
//

import SwiftUI

struct Paragraph: View {
    var header: String
    var text: String

    var body: some View {
        VStack {
            Text(LocalizedStringKey(header))
                .fontWeight(.black)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            Text(LocalizedStringKey(text))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.yellow)
        .padding()
        .glass(cornerRadius: 20)
        .padding(.horizontal)
    }
}
