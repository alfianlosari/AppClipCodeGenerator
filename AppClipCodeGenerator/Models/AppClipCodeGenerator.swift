//
//  AppClipGenerator.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/16/20.
//

import Foundation
import SwiftUI

class AppClipCodeGenerator {
    
    static var shared = AppClipCodeGenerator()
    private init() {}
    
    private var tempSVGPath: String {
        NSTemporaryDirectory().appending("temp.svg")
    }
    
    private var tempPNGPath: String {
        NSTemporaryDirectory().appending("temp.png")
    }
    
    private(set) lazy var templates: [AppClipColor] = {
        
        guard let result = executeCommand(parameters: ["templates"]) else {
            return [.defaultColor]
        }
        return Array(result.split(separator: "\n").dropFirst()).map { (index) -> AppClipColor in
            let content = Array(index.split(separator: " "))
            return AppClipColor(foregroundHex:  String(content[3]), backgroundHex:  String(content[5]))
        }
    }()
    
    func suggestedColors(foreground: Color, background: Color) -> [AppClipColor] {
        guard let result =  executeCommand(
                parameters: [
                    "suggest",
                    "--foreground", foreground.hexString,
                    "--background", background.hexString
                ]
        ) else {
            return [.defaultColor]
        }
        
        return Array(result.split(separator: "\n")).map { (index) -> AppClipColor in
            let content = Array(index.split(separator: " "))
            return AppClipColor(foregroundHex:  String(content[1]), backgroundHex:  String(content[3]))
        }
    }
    
    func generateAppClipCodeSVGData(url: URL, foreground: Color, background: Color, type: AppClipType = .cam, logoType: AppClipLogoType = .badge) -> Data? {
        
        guard let _ = executeCommand(
            parameters: [
                "generate", "--url", url.absoluteString,
                "--foreground", foreground.hexString,
                "--background", background.hexString,
                "--type", type.rawValue,
                "--logo", logoType.rawValue,
                "--output", tempSVGPath
            ]
        ) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: tempSVGPath)) else {
            return nil
        }
        
        return data
    }
    
    func generateAppClipCodePNGData(url: URL, foreground: Color, background: Color, type: AppClipType = .cam, logoType: AppClipLogoType = .badge) -> Data? {
        
        guard let _ = executeCommand(
            parameters: [
                "generate", "--url", url.absoluteString,
                "--foreground", foreground.hexString,
                "--background", background.hexString,
                "--type", type.rawValue,
                "--logo", logoType.rawValue,
                "--output", tempSVGPath]
        ) else {
            return nil
        }
        
        guard let _ = self.convertToPNG(sourcePath: tempSVGPath, targetPath: tempPNGPath) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: tempPNGPath)) else {
            return nil
        }
        
        return data
    }
    
    
    func export(imageType: ImageType) {
        let url = URL(fileURLWithPath: imageType == .svg ? tempSVGPath : tempPNGPath)
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "app-clip.\(imageType.rawValue)"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            if result == .OK {
                guard let url = savePanel.url else { return }
                DispatchQueue.global(qos: .userInitiated).async {
                    try? data.write(to: url)
                }
            }
        }
    }
    
    private func executeCommand(parameters: [String]) -> String? {
        let path = "/usr/local/bin/AppClipCodeGenerator"
        if let data = Process.execute(path, arguments: parameters) {
            let string = String(data: data, encoding: .utf8)
            #if DEBUG
            print(string ?? "")
            #endif
            return string
        } else {
            return nil
        }
    }
    
    private func convertToPNG(sourcePath: String, targetPath: String) -> String? {
        #if arch(x86_64)
        let path = "/usr/local/bin/rsvg-convert"
        #elseif arch(arm64)
        let path = "/opt/homebrew/bin/rsvg-convert"
        #endif
        
        if let data = Process.execute(path, arguments: ["-h", "1024", sourcePath, "-o", targetPath]) {
            let string = String(data: data, encoding: .utf8)
            #if DEBUG
            print(string ?? "")
            #endif
            return string
        } else {
            return nil
        }
    }
    
}
