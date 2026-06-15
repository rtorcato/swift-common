import SwiftUI

public struct RatingView: View {
    private let rating: Int

    public init(rating: Int) {
        self.rating = rating
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.5))
            }
            Text("(\(rating))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, 5)
        }
    }
}

#Preview {
    VStack {
        RatingView(rating: 4)
        RatingView(rating: 3)
        RatingView(rating: 2)
    }
}
