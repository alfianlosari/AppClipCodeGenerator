//
//  AppClipCodeGeneratorApp.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/15/20.
//

import SwiftUI

@main
struct AppClipCodeGeneratorApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, maxWidth: 1024, minHeight: 450, maxHeight: 450)
        }.commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {}
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.windows.forEach { (window) in
            window.collectionBehavior = .fullScreenNone
            let button = window.standardWindowButton(.zoomButton)
            button?.isEnabled = false
        }
    }
    
}

