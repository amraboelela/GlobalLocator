//
//  GlobalLocatorApp.swift
//  Shared
//
//  Created by Amr Aboelela on 6/14/21.
//

import SwiftUI
import AmrSwiftUI

@available(iOS 14.0, *)
@main
struct GlobalLocatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(gl: "")
                .environmentObject(LocationManager())
        }
    }
}
