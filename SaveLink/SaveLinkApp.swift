//
//  SaveLinkApp.swift
//  SaveLink
//
//  Created by Paulina on 13/11/24.
//

import SwiftUI
import FirebaseCore

@main
struct SaveLink: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
