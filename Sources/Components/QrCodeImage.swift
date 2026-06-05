//
//  QrCodeImage.swift
//  QrCodeExample
//
//  Created by Richard Torcato on 2022-11-28.
//
#if os(iOS)
import SwiftUI
import CoreImage.CIFilterBuiltins

public struct QrCodeImage {
    let context = CIContext()

    func generateQRCode(from text: String) -> UIImage {
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data = Data(text.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 20, y: 20)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let image = context.createCGImage(
                outputImage,
                from: outputImage.extent) {
                qrImage = UIImage(cgImage: image)
            }
        }
        return qrImage
    }
}

public struct QrCodeImageSampleView: View {
    @State private var text = "matrixdigital.com"
    var qrCodeImage = QrCodeImage()

    public var body: some View {
        VStack {
            Form {
                Section(header: Text("Text to encode in QRCode")) {
                    TextField("Text", text: $text)
                }
                Image(uiImage: qrCodeImage.generateQRCode(from: text))
                    .resizable()
                    .scaledToFit()
                    .tint(.red)
            }
        }.padding()
    }
}
struct QrCodeImageSampleView_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeImageSampleView()
    }
}
#endif
