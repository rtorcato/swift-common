//
//  RoundedButtonStyle.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-07.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(width: CGFloat? = nil, height: CGFloat? = 60) {
        self.width = width
        self.height = height
    }
    func makeBody(configuration: Configuration) -> some View {
        RoundedButton(configuration: configuration)
            .frame(width: width, height: height)
    }
    
    struct RoundedButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.colorScheme) private var colorScheme
        
        var backgroundColor: Color {
            if !isEnabled { return .white }
            if colorScheme == .dark {
                return configuration.isPressed ? .white : .blue
            }
            return configuration.isPressed ? .blue : .white
        }
        
        var borderColor: Color {
            if !isEnabled { return .gray }
            if colorScheme == .dark {
                return backgroundColor
            }
            return configuration.isPressed ? .white : .blue
        }
        
        var labelColor: Color {
            if !isEnabled { return .gray }
            if colorScheme == .dark {
                return configuration.isPressed ? .blue : .white
            }
            return configuration.isPressed ? .white : .blue
        }
        
        var body: some View {
//            configuration.label
            RoundedRectangle(cornerRadius: 6).overlay(
                RoundedRectangle(cornerRadius: 5).fill(backgroundColor)
                    .padding(1)
            )
            .foregroundColor(borderColor)
            .overlay(
                configuration.label
                    .foregroundColor(labelColor)
                    .font(.body)
            )
        }
    }
}
