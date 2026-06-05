////
////  ContentView.swift
////  PopupExample
////
////  Created by Richard Torcato on 2022-11-04.
////
// #if os(iOS)
// import SwiftUI
// import PopupView
//
// public struct ToastsState {
//    var showingTopFirst = false
//    var showingTopSecond = false
//    var showingBottomFirst = false
//    var showingBottomSecond = false
// }
//
// public struct PopupsState {
//    var showingMiddle = false
//    var showingBottomFirst = false
//    var showingBottomSecond = false
// }
//
// public struct ActionSheetsState {
//    var showingFirst = false
//    var showingSecond = false
// }
//
// public struct PopupExamplesView : View {
//    @State var floats = ToastsState()
//    @State var toasts = ToastsState()
//    @State var popups = PopupsState()
//    @State var actionSheets = ActionSheetsState()
//    
//    public var body: some View {
//        VStack{
//            PopupsList(
//                showingTopFirstFloat: $floats.showingTopFirst,
//                showingTopSecondFloat: $floats.showingTopSecond,
//                showingBottomFirstFloat: $floats.showingBottomFirst,
//                showingBottomSecondFloat: $floats.showingBottomSecond,
//                showingTopFirstToast: $toasts.showingTopFirst,
//                showingTopSecondToast: $toasts.showingTopSecond,
//                showingBottomFirstToast: $toasts.showingBottomFirst,
//                showingBottomSecondToast: $toasts.showingBottomSecond,
//                showingMiddlePopup: $popups.showingMiddle,
//                showingBottomFirstPopup: $popups.showingBottomFirst,
//                showingBottomSecondPopup: $popups.showingBottomSecond,
//                showingFirstActionSheet: $actionSheets.showingFirst,
//                showingSecondActionSheet: $actionSheets.showingSecond
//            )
//        }
//        .padding()
//        .popup(isPresented: $floats.showingTopFirst) {
//            FloatTopFirst()
//        } customize: {
//            $0
//                .type(.floater())
//                .position(.top)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        // MARK: - Designed floats
//        .popup(isPresented: $floats.showingTopSecond) {
//            FloatTopSecond()
//        } customize: {
//            $0
//                .type(.floater())
//                .position(.top)
//                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $floats.showingBottomFirst) {
//            FloatBottomFirst()
//        } customize: {
//            $0
//                .type(.floater())
//                .position(.bottom)
//                .autohideIn(3)
//                .animation(.spring())
//                .autohideIn(2)
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $floats.showingBottomSecond) {
//            FloatBottomSecond()
//        } customize: {
//            $0
//                .type(.floater())
//                .position(.bottom)
//                .autohideIn(3)
//                .animation(.spring())
//                .autohideIn(5)
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//
//        
//        // MARK: - Designed toasts
//        
//        .popup(isPresented: $toasts.showingTopFirst) {
//            ToastTopFirst()
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.top)
//                .autohideIn(3)
//                .animation(.spring())
//                .autohideIn(5)
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $toasts.showingTopSecond) {
//            ToastTopSecond()
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.top)
//                .autohideIn(3)
//                .animation(.spring())
//                .autohideIn(5)
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $toasts.showingBottomFirst) {
//            ToastBottomFirst(isShowing: $toasts.showingBottomFirst)
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.bottom)
//                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $toasts.showingBottomSecond) {
//            ToastBottomSecond()
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.bottom)
//                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        // MARK: - Designed popups
//        .popup(isPresented: $popups.showingMiddle) {
//            PopupMiddle(isPresented: $popups.showingMiddle)
//        } customize: {
//            $0
//                .type(.default)
//                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $popups.showingBottomFirst) {
//            PopupBottomFirst(isPresented: $popups.showingBottomFirst)
//        } customize: {
//            $0
//                .type(.floater())
////                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(false)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $popups.showingBottomSecond) {
//            PopupBottomSecond()
//        } customize: {
//            $0
//                .type(.floater(verticalPadding: 0, useSafeAreaInset: false))
//                .position(.bottom)
////                .autohideIn(3)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//
//
//        
//
//        // MARK: - Designed action sheets
//        .popup(isPresented: $actionSheets.showingFirst) {
//            ActionSheetFirst()
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.bottom)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//        .popup(isPresented: $actionSheets.showingSecond) {
//            ActionSheetSecond()
//        } customize: {
//            $0
//                .type(.toast)
//                .position(.bottom)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.black.opacity(0.5))
//        }
//
//    }
// }
//
// struct PopupExamplesView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopupExamplesView()
//    }
// }
// #endif
