//
//  FormStateObservableObject.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/16/20.
//

import SwiftUI
import Combine

class FormStateObservableObject: ObservableObject {
    
    var generator = AppClipCodeGenerator.shared
    let queue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInitiated
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    @Published var image: NSImage? = nil
    
    @Published var urlText: String = ""
    
    @Published var selectedColorType: ColorType = .template
    @Published var selectedTemplateColor: AppClipColor = .defaultColor
    @Published var selectedCustomColor: AppClipColor = .defaultColor
    @Published var suggestedCustomColors: [AppClipColor] = [.defaultColor]
    @Published var selectedForegroundColor = AppClipColor.defaultColor.foreground
    @Published var selectedBackgroundColor = AppClipColor.defaultColor.background
    
    @Published var selectedType: AppClipType = .cam
    @Published var selectedLogoType: AppClipLogoType = .badge
    
    var cancellables: Set<AnyCancellable> = Set()
    
    func observe() {
        removeObserver()
        
        Publishers.CombineLatest($selectedForegroundColor, $selectedBackgroundColor)
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { (value) in
                self.suggestedCustomColors = self.generator.suggestedColors(foreground: value.0, background: value.1)
                self.selectedCustomColor = self.suggestedCustomColors[0]
            }.store(in: &cancellables)
        
        
        Publishers.CombineLatest3($selectedColorType, $selectedTemplateColor, $selectedCustomColor)
            .combineLatest($selectedType, $selectedLogoType)
            .sink { (value) in
                self.generateAppClipCode(
                    selectedColorType: value.0.0,
                    selectedTemplateColor: value.0.1,
                    selectedCustomColor: value.0.2,
                    selectedType: value.1,
                    selectedLogoType: value.2
                )
            }.store(in: &cancellables)
        
        $urlText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { (value) in
                self.generateAppClipCode(urlText: value)
            }.store(in: &cancellables)
        
    }
    
    func removeObserver() {
        if !cancellables.isEmpty {
            cancellables.forEach { $0.cancel() }
            cancellables = Set()
        }
    }
    
    private func generateAppClipCode(
        urlText: String? = nil,
        selectedColorType: ColorType? = nil,
        selectedTemplateColor: AppClipColor? = nil,
        selectedCustomColor: AppClipColor? = nil,
        selectedType: AppClipType? = nil,
        selectedLogoType: AppClipLogoType? = nil
    ) {
        let urlString = urlText ?? self.urlText
        let colorType = selectedColorType ?? self.selectedColorType
        let template = selectedTemplateColor ?? self.selectedTemplateColor
        let customColor = selectedCustomColor ?? self.selectedCustomColor
        let type = selectedType ?? self.selectedType
        let logoType = selectedLogoType ?? self.selectedLogoType
        
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        queue.cancelAllOperations()
        queue.addOperation {
            var image: NSImage?
            defer {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            let foreground: Color
            let background: Color
            
            switch colorType {
            case .template:
                foreground = template.foreground
                background = template.background
                
            case .custom:
                foreground = customColor.foreground
                background = customColor.background
            }
            
            guard
                let data = self.generator.generateAppClipCodePNGData(url: url, foreground: foreground, background: background, type: type, logoType: logoType) else {
                image = nil
                return
            }
            image = NSImage(data: data)
        }
    }
    
    deinit {
        removeObserver()
    }
    
}
