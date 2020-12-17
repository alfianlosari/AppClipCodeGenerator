//
//  FormTypeSection.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/16/20.
//

import SwiftUI

struct FormTypeSection: View {
    
    @Binding var selectedType: AppClipType
    @Binding var selectedLogoType: AppClipLogoType
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Picker(selection: self.$selectedType, label: Text("Type")                        .font(.headline)
            ) {
                ForEach(AppClipType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }.pickerStyle(RadioGroupPickerStyle())
            
            
            Picker(selection: self.$selectedLogoType, label: Text("Badge")                        .font(.headline)
            ) {
                ForEach(AppClipLogoType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }.pickerStyle(RadioGroupPickerStyle())
            
        }
        
    }
}

struct FormTypeSection_Previews: PreviewProvider {
    static var previews: some View {
        FormTypeSection(selectedType: .constant(.cam), selectedLogoType: .constant(.badge))
    }
}
