//
//  BeaconExample.swift
//  DropWallet
//
//  Created by Richard Torcato on 2023-01-31.
//
#if !os(watchOS) && !os(tvOS)
import SwiftUI
import CoreLocation
import Combine

// https://www.youtube.com/watch?v=lCNpEaZiKqU

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    var didChange = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager?
    var lastDistance: CLProximity = CLProximity.unknown
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        <#code#>
//    }
    
    func startScanning() {
        _ = UUID(uuidString: "")
    }
}
#endif
