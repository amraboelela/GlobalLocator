//
//  MapView.swift
//  GlobalLocator
//
//  Created by Amr Aboelela on 6/24/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

    let annotations = [
        City(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)),
        City(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)),
        City(name: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)),
        City(name: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667))
    ]

    var body: some View {
        if #available(iOS 14.0, *) {
            Map(coordinateRegion: $region, annotationItems: annotations) {
                //MapPin(coordinate: $0.coordinate)
                MapAnnotation(coordinate: $0.coordinate) {
                    Rectangle()
                        .strokeBorder(Color.red, lineWidth: 4)
                        .frame(width: 40, height: 40)
                }
            }
            .frame(width: 400, height: 300)
        } else {
            // Fallback on earlier versions
        }
    }
}

#if DEBUG
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
#endif

