//
//  TextFieldCustomRoundedStyle.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 10.01.2022.
//

import SwiftUI

struct TextFieldCustomRoundedStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.primary)
            .padding()
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(Color.primary)
            )
            .padding(.horizontal, 15)
    }
}
