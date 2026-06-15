---
title: UI API overview
description: MatrixSwiftBaseUI — SwiftUI components, modifiers, shapes, styles, views, and SwiftUI-coupled helpers / managers.
---

`MatrixSwiftBaseUI` ships SwiftUI components and SwiftUI-coupled helpers. Depends on Core.

```swift
import MatrixSwiftBaseUI
```

> Full type signatures will live in the DocC reference once that lands ([#10](https://github.com/rtorcato/swift-common/issues/10)). This page is the narrative overview with code samples.

## Components

Reusable SwiftUI views.

| File | What it provides |
|---|---|
| **Buttons** | `AddToWalletButton`, `DismissButton`, `HamburgerBtn`, `PaymentButton`, `RequestReviewButton` |
| **Containers** | `CardContainer`, `ColumnStack`, `FlipView`, `HVStack`, `RectangleView`, `RowStack`, `SlideHorizontalPanel`, `SlideOutPanel` |
| **Forms** | `FormWrapper` |
| **WebView** | `WebViewContainer`, `WebViewModel`, `WebViewSampleView` |
| Standalone | `CardFlip`, `CopyTextView`, `EmojiList`, `LazyView`, `LoadingView`, `LottiePlusView`, `MapView`, `OverlayShield`, `QrCodeImage`, `RatingView`, `RotatingBall`, `StickyHeader` |

### Example

```swift
struct ContentView: View {
    var body: some View {
        CardContainer {
            VStack {
                Text("Tap to copy")
                CopyTextView("Hello, swift-common")
                RatingView(rating: 4)
            }
        }
    }
}
```

## Modifiers

| Modifier | Purpose |
|---|---|
| `AnimatableFontModifier` | Animate font size changes |
| `BorderRadiusModifier` | Per-corner rounding |
| `NumbersOnlyViewModifier` | Restrict `TextField` input to digits |
| `OffsetModifier` | Reusable offset wrapper |

## Shapes

| Shape | Purpose |
|---|---|
| `DashedLine` | Dashed-stroke line |
| `Line` | Plain line shape |
| `RoundedCorner` | Per-corner rounded rectangle |

## Styles

`ButtonStyle` implementations.

| Style | Purpose |
|---|---|
| `BuyButtonStyle` | Storefront "buy" style |
| `PressableButtonStyle` | Visible press feedback |
| `RoundedButtonStyle` | Standard rounded button |

## Views

| View | Purpose |
|---|---|
| `ActivityView` | UIKit share sheet wrapper |
| `BlurView`, `BlurWindow` | Visual-effect blur backdrops |
| `LottieView`, `LottieSampleView`, `ResizableLottieView` | Lottie animation hosts |
| `ResponsiveView` | Adapt to size-class changes |
| `SignUpAppleButton` | Apple sign-in button wrapper |
| `WebView` | WKWebView wrapper |

## UI Helpers

SwiftUI-coupled helpers (those that need `View`, environment, or UIKit/AppKit).

`AlertHelper`, `AppHelper`, `CameraHelper`, `ColorHelper`, `ColorSchemeHelper`, `FileManagerHelper`, `HapticsHelper`, `ImageHelper`, `KeyboardHelper`, `LocalAuthenticationHelper`, `LocalFileHelper`, `NfcHelper`, `PhotoHelper`, `PhotoPickerHelper`, `QrCodeHelper`, `SafeAreaHelper`, `ScreenHelper`, `SettingsHelper`, `SizeClassHelper`, `StoreKitHelper`, `ViewHelper`, `VisionkitHelper`, `WebImageHelper`, `WebLinkHelper`.

## UI Managers

`ObservableObject` or stateful managers tied to UIKit/AppKit.

| Manager | Purpose |
|---|---|
| `BeaconDetector` | iBeacon ranging |
| `ImageCache` | In-memory image cache |
| `ImagePicker` | UIImagePickerController wrapper |
| `MessageUIManager` | Mail / SMS compose |
| `SoundManager` | Sound playback |
| `SystemThemeManager` | Track system light/dark mode |

## Other

| File | Purpose |
|---|---|
| `AnyLayoutTypes` | SwiftUI layout-protocol helpers |

## State

| Type | Purpose |
|---|---|
| `NetworkState` | Reachability / connection-type observable |
