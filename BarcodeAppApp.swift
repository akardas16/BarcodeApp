//
//  BarcodeAppApp.swift
//  BarcodeApp
//
//  Created by Abdullah Kardas on 17.06.2022.
//

import SwiftUI
import CarBode

@main
struct BarcodeAppApp: App {
    var body: some Scene {
       
        WindowGroup {
            NavigationView {
                BarcodeScanner().navigationBarHidden(true)
            }
        }
        
    }
}
