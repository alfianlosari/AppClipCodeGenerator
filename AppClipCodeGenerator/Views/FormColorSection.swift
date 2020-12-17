//
//  FormColorSection.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/16/20.
//

import SwiftUI

struct FormColorSection: View {
    
    let templates: [AppClipColor]
    @Binding var selectedColorType: ColorType
    @Binding var selectedTemplateColor: AppClipColor
    @Binding var selectedCustomColor: AppClipColor
    @Binding var suggestedCustomColors: [AppClipColor]
    @Binding var selectedForegroundColor: Color
    @Binding var selectedBackgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 16) {
                Picker(selection: self.$selectedColorType, label: Text("Colors").font(.headline)) {
                    ForEach(ColorType.allCases, id: \.self) { type in
                        Text(type.description).tag(type)
                    }
                }.pickerStyle(RadioGroupPickerStyle())
                
                Divider().frame(height: 80)
                
                switch self.selectedColorType {
                
                case .template:
                    VStack(spacing: 16) {
                        Picker(selection: $selectedTemplateColor, label: Text("Preset").font(.headline)) {
                            ForEach(templates, id: \.self) { template in
                                Text(template.description).tag(template)
                            }
                        }
                        
                        HStack {
                            selectedTemplateColor.foreground
                                .frame(height: 20)
                                .cornerRadius(4)
                            Spacer()
                            selectedTemplateColor.background
                                .frame(height: 20)
                                .cornerRadius(4)
                        }
                    }
                case .custom:
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            ColorPicker(selection: $selectedForegroundColor, label: {
                                Text("Foreground").font(.headline)
                            })
                            
                            ColorPicker(selection: $selectedBackgroundColor, label: {
                                Text("Background").font(.headline)
                            })
                        }
                        
                        VStack(spacing: 16) {
                            Picker(selection: self.$selectedCustomColor, label: Text("Suggested").font(.headline)) {
                                ForEach(self.suggestedCustomColors, id: \.self) { template in
                                    Text(template.description).tag(template)
                                }
                            }
                            
                            HStack {
                                selectedCustomColor.foreground
                                    .frame(height: 20)
                                    .cornerRadius(4)
                                Spacer()
                                
                                selectedCustomColor.background
                                    .frame(height: 20)
                                    .cornerRadius(4)
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}

struct FormColorSection_Previews: PreviewProvider {
    static var previews: some View {
        FormColorSection(templates: AppClipCodeGenerator.shared.templates, selectedColorType: .constant(.template), selectedTemplateColor: .constant(AppClipColor.init(foregroundHex: "000000", backgroundHex: "FFFFFF")), selectedCustomColor: .constant(AppClipColor.init(foregroundHex: "000000", backgroundHex: "FFFFFF")), suggestedCustomColors: .constant([]), selectedForegroundColor: .constant(.white), selectedBackgroundColor: .constant(.black))
    }
}
