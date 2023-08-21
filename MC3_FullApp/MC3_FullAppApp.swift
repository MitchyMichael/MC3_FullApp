//
//  MC3_FullAppApp.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import SwiftUI

@main
struct MC3_FullAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var arDelegate = ARDelegate()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            
            ARViewRepresentable(arDelegate: arDelegate, theItem: 1)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
