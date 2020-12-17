//
//  ContentView.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/15/20.
//

import SwiftUI

struct ContentView: View {
    
    var generator = AppClipCodeGenerator.shared
    @StateObject var formState = FormStateObservableObject()
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 32) {
                
                HStack(alignment: .center, spacing: 8) {
                    Text("URL")
                        .font(.headline)
                    TextField(
                        "https://appclip.example.com",
                        text: $formState.urlText
                    )
                }
                .padding(.top, 32)
                
                Divider()
                FormColorSection(
                    templates: generator.templates,
                    selectedColorType: $formState.selectedColorType,
                    selectedTemplateColor: $formState.selectedTemplateColor,
                    selectedCustomColor: $formState.selectedCustomColor,
                    suggestedCustomColors: $formState.suggestedCustomColors,
                    selectedForegroundColor: $formState.selectedForegroundColor,
                    selectedBackgroundColor: $formState.selectedBackgroundColor
                )
            
                Divider()
                FormTypeSection(
                    selectedType: $formState.selectedType,
                    selectedLogoType: $formState.selectedLogoType
                )
                
                Divider()
                HStack {
                    Spacer()
                    Button("Export as SVG") {
                        generator.export(imageType: .svg)
                    }.disabled(formState.image == nil)
                    
                    Button("Export as PNG") {
                        generator.export(imageType: .png)
                    }.disabled(formState.image == nil)
                    Spacer()
                }
            }
            Divider()
            
            ImageContainer(image: formState.image)
        }
        .padding()
        .onAppear {
            formState.observe()
        }
        .onDisappear {
            formState.removeObserver()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

