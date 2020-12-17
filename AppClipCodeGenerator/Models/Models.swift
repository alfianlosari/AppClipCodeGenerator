//
//  Model.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/16/20.
//

import Foundation
import SwiftUI

enum ImageType: String {
    case svg
    case png
}

enum ColorType: String, CaseIterable {
    
    case template
    case custom
    
    var description: String {
        switch self {
        case .template: return "Template"
        case .custom: return "Custom"
        }
    }
    
}

enum AppClipType: String, CaseIterable {
    case cam
    case nfc
    
    var description: String {
        switch self {
        case .cam: return "Camera Scan-Only codes"
        case .nfc: return "NFC Enabled codes"
        }
    }
}

enum AppClipLogoType: String, CaseIterable {
    case none
    case badge
    
    var description: String {
        switch self {
        case .none: return "Generate without badge"
        case .badge: return "Generate App Clip inside a badge"
        }
    }
    
}

struct AppClipColor: CustomStringConvertible, Hashable {
    let foregroundHex: String
    let backgroundHex: String
    
    var background: Color {
        Color(hex: backgroundHex)
    }
    
    var foreground: Color {
        Color(hex: foregroundHex)
    }
    
    var description: String {
        return "Foreground: \(foregroundHex), Background: \(backgroundHex)"
    }
    
    static let defaultColor: AppClipColor = .init(foregroundHex: "FFFFFF", backgroundHex: "000000")
}
