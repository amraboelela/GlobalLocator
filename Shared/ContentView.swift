//
//  ContentView.swift
//  GlobalLocator
//
//  Created by Amr Aboelela on 6/14/21.
//

import SwiftUI
import AmrSwiftUI
import MapKit
import GlobalLocatorLib
#if os(iOS)
import MobileCoreServices
#endif

struct ContentView: View {
    @State var gotCurrentLocation = false
    @State var region:MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @State var gl: String = ""
    @State var currentGL: String = ""
    @State var prevRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @EnvironmentObject var locationManager: LocationManager
    
    var currentRegion: MKCoordinateRegion {
        get {
            if gotCurrentLocation {
                return region
            } else {
                if let latitude = locationManager.lastLocation?.coordinate.latitude,
                   let longitude = locationManager.lastLocation?.coordinate.longitude {
                    gotCurrentLocation = true
                    locationManager.locationManager.stopUpdatingLocation()
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
                return region
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SearchBar(
                searchText: $gl,
                startSearchCallback: {
                print("startSearchCallback")
                if globalLocatorLib.isGLCode(text: gl) {
                    gl = gl.uppercased()
                    self.region = MKCoordinateRegion(
                        center: globalLocatorLib.locationFor(code: gl),
                        span: globalLocatorLib.spanFor(code: gl)
                    )
                } else {
                    self.prevRegion = currentRegion
                    globalLocatorLib.regionFor(query: gl, fromRegion: prevRegion) { matchingItem, resultRegion in
                        region = resultRegion
                    }
                }
            }, updateDataCallback: {
                print("updateDataCallback")
            }
            )
                .padding(.horizontal)
            HStack(spacing: 10) {
                Text("Current GL:  " + currentGL)
                    .padding(.leading)
                Spacer()
#if os(iOS)
                Button(
                    action: {
                    UIPasteboard.general.setValue(
                        currentGL,
                        forPasteboardType: kUTTypePlainText as String
                    )
                }
                ) {
                    Image(systemName: "doc.on.doc")
                        .accessibility(label: Text("Copy Global Locator"))
                }
#else
                Button(
                    action: {
                    let pasteBoard = NSPasteboard.general
                    pasteBoard.clearContents()
                    pasteBoard.writeObjects([currentGL as NSString])
                }
                ) {
                    Image(systemName: "doc.on.doc")
                        .accessibility(label: Text("Copy Global Locator"))
                }
#endif
                Spacer()
                Button(
                    action: {
                    let mapItem = globalLocatorLib.mapItemFrom(code: currentGL)
                    mapItem.openInMaps(
                        launchOptions: [
                            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
                        ]
                    )
                }
                ) {
                    Image(systemName: "arrow.uturn.forward.square")
                        .accessibility(label: Text("Direction to location"))
                }
                Spacer()
            }
            GeometryReader { geometry in
                if #available(iOS 14.0, *) {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: [
                            globalLocatorLib.annotationFor(
                                region: region,
                                mapWidth: geometry.size.width
                            )
                        ]
                    ) { annotation in
                        MapAnnotation(coordinate: annotation.location) {
                            Rectangle()
                                .strokeBorder(Color.red, lineWidth: 4)
                                .frame(width: annotation.span, height: annotation.span)
                        }
                    }
                    .onChange(of: region.center.longitude) {_ in
                        currentGL = globalLocatorLib.codeFor(region: currentRegion)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gl: "GZNF3 RKJ2G")
            .environmentObject(LocationManager())
    }
}
#endif
