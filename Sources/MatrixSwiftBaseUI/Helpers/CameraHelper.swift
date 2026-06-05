//
//  CameraHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-25.
//
#if os(iOS)
import Foundation

import SwiftUI
import AVFoundation

final class CameraHelper {
    
    static let instance = CameraHelper() // Singleton
    
    var captureSession = AVCaptureSession()
    
    // Get the back-facing camera for capturing videos
//    guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
//        print("Failed to get the camera device")
//        return
//    }
//    
//    do {
//        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
//        let input = try AVCaptureDeviceInput(device: captureDevice)
//        
//        // Set the input device on the capture session.
//        captureSession.addInput(input)
//        
//        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
//        let captureMetadataOutput = AVCaptureMetadataOutput()
//        captureSession.addOutput(captureMetadataOutput)
//        
//        // Set delegate and use the default dispatch queue to execute the call back
//        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
////            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//        
//    } catch {
//        // If any error occurs, simply print it out and don't continue any more.
//        print(error)
//        return
//    }
//    
//    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
//    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//    videoPreviewLayer?.frame = view.layer.bounds
//    view.layer.addSublayer(videoPreviewLayer!)
//    
//    // Start video capture.
//    captureSession.startRunning()
    
}
#endif
