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
    @State var userRegion:MKCoordinateRegion = MKCoordinateRegion(
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
                        span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                    )
                    userRegion = region
                    print("userRegion: \(userRegion)")
                }
                //print("region: \(region)")
                return region
            }
        }
    }
    
    func annotations(region: MKCoordinateRegion, mapSize: CGSize) -> [GLRegion] {
        //print("annotations region: \(region)")
        var result = [globalLocatorLib.annotationFor(
            region: region,
            mapSize: mapSize
        )]
        if gotCurrentLocation {
            result.append(GLRegion(id: "userRegion", location: userRegion.center, span: CGSize(width: 40, height: 40)))
        }
        print("annotations result: \(result)")
        return result
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
                #if !os(watchOS)
                Text("Current GL:  ")
                    .padding(.leading)
                #endif
                if #available(iOS 14.0, *) {
                    #if os(watchOS)
                    Text(currentGL)
                    #else
                    Text(currentGL)
                        .bold()
                        .font(.title3)
                    #endif
                } else {
                    Text(currentGL)
                        .bold()
                        .font(.headline)
                }
                #if !os(watchOS)
                Spacer()
                #endif
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
#elseif os(macOS)
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
                //#if !os(watchOS)
                Spacer()
                //#endif
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
                #if !os(watchOS)
                Spacer()
                #endif
            }
            GeometryReader { geometry in
                if #available(iOS 14.0, *) {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: annotations(region: region, mapSize: geometry.size)
                    ) { annotation in
                        return MapAnnotation(coordinate: annotation.location) {
                            if annotation.id == "userRegion" {
                                Circle()
                                    .strokeBorder(Color.blue, lineWidth: 4)
                                    .frame(width: annotation.span.width, height: annotation.span.height)
                            } else {
                                Rectangle()
                                    .strokeBorder(Color.red, lineWidth: 4)
                                    .frame(width: annotation.span.width, height: annotation.span.height)
                            }
                        }
                    }
                    .onChange(of: region.center) {_ in
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
        ContentView(gl: "GZNF3RKJ")
            .environmentObject(LocationManager())
    }
}
#endif
