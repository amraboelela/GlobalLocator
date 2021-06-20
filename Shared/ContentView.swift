//
//  ContentView.swift
//  Shared
//
//  Created by Amr Aboelela on 6/14/21.
//

import SwiftUI
import AmrSwiftUI
import MapKit
import GlobalLocatorLib
import MobileCoreServices

struct ContentView: View {
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @State var gl: String = ""
    @State var currentGL: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
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
                            globalLocatorLib.regionFor(query: gl, fromRegion: region) { matchingItem, resultRegion in
                                region = resultRegion
                            }
                        }
                    }, updateDataCallback: {
                        print("updateDataCallback")
                    }
                )
                .padding(.leading)
                //Spacer()
                Button(
                    action: {
                        globalLocatorLib.regionFor(query: gl, fromRegion: region) { matchingItem, resultRegion in
                            //region = result
                            matchingItem?.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDefault])
                        }
                    }
                ) {
                    Image(systemName: "arrow.uturn.forward.square")
                        .accessibility(label: Text("Direction to location"))
                }
                Spacer()
            }
            HStack(spacing: 10) {
                Text("Current GL:  " + currentGL)
                    .padding(.leading)
                Spacer()
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
                Spacer()
            }
            Map(coordinateRegion: $region)
                .onChange(of: region.center.longitude) {_ in
                    print("center: \(region.center)")
                    print("span: \(region.span)")
                    currentGL = globalLocatorLib.codeFor(region: region)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gl: "GZNF3 RKJ2G")
    }
}
