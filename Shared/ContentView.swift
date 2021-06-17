//
//  ContentView.swift
//  Shared
//
//  Created by Amr Aboelela on 6/14/21.
//

import SwiftUI
import MapKit
import GlobalLocator

struct ContentView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var gl: String = ""
    @State var currentGL: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            HStack(spacing: 10) {
                Text("Enter GL:")
                    .padding(.leading)
                TextField("", text: $gl)
                    .frame(width: 150, height: 20)
                    .textCase(.uppercase)
                    .onChange(of: gl) {_ in
                        gl = gl.uppercased()
                    }
                Button("Go") {
                    let theCodes = gl.split(separator: " ")
                    if theCodes.count == 2 {
                        self.region = MKCoordinateRegion(center: globalLocator.locationFor(code: gl), span: globalLocator.spanFor(code: gl))
                    }
                }
            }
            //Spacer()
            HStack(spacing: 10) {
                Text("Current GL:  " + currentGL)
                    .padding(.leading)
                Spacer()
                Button(action: {  }) {
                    Image(systemName: "doc.on.doc")
                        //.imageScale(.large)
                        .accessibility(label: Text("Copy GL"))
                        //.padding()
                }
                Spacer()
            }
            Map(coordinateRegion: $region)
                .onChange(of: region.center.longitude) {_ in
                    print("center: \(region.center)")
                    print("span: \(region.span)")
                    currentGL = globalLocator.codeFor(region: region)
                }
                /*.onChange(of: region.center.longitude) {_ in
                    print("longitude: \(region.center.longitude)")
                    currentGL = globalLocator.codeFor(region: region)
                }*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gl: "GZNF3 RKJ2G")
    }
}
