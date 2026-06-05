//
//  VisionkitHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-21.
//
#if os(iOS)
import SwiftUI
import VisionKit
import AVKit

enum ScanType: String {
    case barcode, text
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

class VisionKitHelper {
    var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    var scanType: ScanType = .barcode
//    var recognizedDataType: DataScannerViewController.RecognizedDataType {
//        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
//    }
    
    static let shared = VisionKitHelper() // Singleton
   
    static func isScannerAvailable(isAvailable: Bool, isSupported: Bool) -> Bool {
        return isAvailable && isSupported
    }
    
    static func requestDataScannerAccessStatus(isScannerAvailable: Bool) async {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            dataScannerAccessStatus = .cameraNotAvailable
//            return
//        }
        
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized: dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
//        case .restricted, .denied: dataScannerAccessStatus = .cameraAccessNotGranted
//        case .notDetermined:
//            let granted = await AVCaptureDevice.requestAccess(for: .video)
//            if granted {
//                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
//            } else {
//                dataScannerAccessStatus = .cameraAccessNotGranted
//            }
//
//        default: break
//
//        }
    }
    
//    var headerText: String {
//        if recognizedItems.isEmpty {
//            return "Scanning \(scanType.rawValue)"
//        } else {
//            return "Recognized \(recognizedItems.count) item(s)"
//        }
//    }
//
//      var dataScannerViewId: Int {
//        var hasher = Hasher()
//        hasher.combine(scanType)
//        hasher.combine(recognizesMultipleItems)
//        if let textContentType {
//            hasher.combine(textContentType)
//        }
//        return hasher.finalize()
//    }
    
}
#endif
