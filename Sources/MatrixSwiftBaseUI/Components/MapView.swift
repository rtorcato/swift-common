//
//  MapView.swift
//  
//
//  Created by Richard Torcato on 2023-01-12.
//

import SwiftUI
import MapKit

public struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    //    @State private var region = MKCoordinateRegion(
    //        center:CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
    //        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @AppStorage("MapView.zoom")
    private var zoom: Zoom = .medium
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    enum Zoom: String, CaseIterable, Identifiable {
        case near = "Near"
        case medium = "Medium"
        case far = "Far"
        
        var id: Zoom {
            return self
        }
    }
    
    var delta: CLLocationDegrees {
        switch zoom {
        case .near: return 0.02
        case .medium: return 0.2
        case .far: return 2
        }
    }
    
    public var body: some View {
        Map(coordinateRegion: .constant(region))
        //        Map(coordinateRegion: $region)
        //            .onAppear {
        //                setRegion(coordinate)
        //            }
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
