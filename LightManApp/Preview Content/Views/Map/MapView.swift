//
//  MapView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI
import MapKit

struct MapView: View {
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        Map(position: $position){
            UserAnnotation()
        }
    }
}
#Preview {
    MapView()
}

