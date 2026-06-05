//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-01-31.
//
#if os(iOS)
import SwiftUI
import StoreKit

public struct RequestReviewButton: View {
    @Environment(\.requestReview) var requestReview
    public let label: String

    public var body: some View {
        Button(label) {
            DispatchQueue.main.async {
                requestReview()
            }
        }
    }
}

struct RequestReviewButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RequestReviewButton(label: "Request Review")
                .padding()
                .preferredColorScheme(.light)
            RequestReviewButton(label: "Request Review")
                .padding()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}

#endif
