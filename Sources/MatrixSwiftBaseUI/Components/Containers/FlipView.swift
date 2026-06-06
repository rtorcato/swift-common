//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-02-22.
//

import SwiftUI

public struct FlipView<FrontViewType: View, BackViewType: View>: View {
    @Binding var isFlipped: Bool
    @ViewBuilder var frontView: () -> FrontViewType
    @ViewBuilder var backView: () -> BackViewType
    
    public init(
        isFlipped: Binding<Bool>,
        frontView: @escaping () -> FrontViewType,
        backView: @escaping () -> BackViewType
    ) {
        _isFlipped = isFlipped
        self.frontView = frontView
        self.backView = backView
    }
    
//    public func toggleCard() {
//        withAnimation(.easeInOut(duration: 0.8)) {
//            self.isFlipped.toggle()
//        }
//    }
//    public func flipCard(_ showBack:Bool = false){
//        withAnimation(.easeInOut(duration: 0.8)) {
//            self.isFlipped = showBack
//        }
//    }
    
    public var body: some View {
        ZStack {
            frontView().opacity(isFlipped ? 0.0 : 1.0)
            backView().opacity(isFlipped ? 1.0 : 0.0)
        }
        .rotation3DEffect(
            Angle(degrees: isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        // .shadow(color: Color.black.opacity(0.2), radius: 4, x: 10, y: 10)
    }
}

#if !os(watchOS)
struct FlipViewSample: View {
    @State private var isFlipped: Bool = false
    @State private var selectedFlipViewSide: FlipViewSide = .front
    
    enum FlipViewSide: String, CaseIterable, Identifiable {
        case front, back
        var id: Self { self }
    }
    
    func toggleCard() {
        withAnimation(.easeInOut(duration: 0.8)) {
            self.isFlipped.toggle()
        }
    }
    func flipCard(_ showBack: Bool = false) {
        withAnimation(.easeInOut(duration: 0.8)) {
            self.isFlipped = showBack
        }
    }
    
    var body: some View {
        
        let FrontBtn: some View = Button(
            action: {self.flipCard(false)},
            label: { Text("Front")}
        ).disabled(self.isFlipped == false)
        
        let BackBtn: some View = Button(
            action: {self.flipCard(true)},
            label: { Text("Back")}
        ).disabled(self.isFlipped == true)
        
        let toggleBtn: some View = Button(
            action: self.toggleCard,
            label: { Text("Toggle")}
        )
        
        return HStack {
            VStack {
                HStack {
                    FrontBtn
                    Spacer()
                    toggleBtn
                    Spacer()
                    BackBtn
                }.padding()
                Spacer()
                    Picker("Card View", selection: $selectedFlipViewSide) {
                        Text("Front").tag(FlipViewSide.front)
                        Text("Back").tag(FlipViewSide.back)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                FlipView(
                    isFlipped: $isFlipped,
                    frontView: {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 300, height: 400)
                            .cornerRadius(16)
                    },
                    backView: {
                        Rectangle()
                            .foregroundColor(.pink)
                            .frame(width: 300, height: 400)
                            .cornerRadius(16)
                    }
                )
                .onTapGesture { self.toggleCard()}
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 10, y: 10)
                Spacer()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FlipViewSample()
    }
}
#endif
