//
//  AppClipImageContainer.swift
//  AppClipCodeGenerator
//
//  Created by Alfian Losari on 12/15/20.
//

import SwiftUI

struct ImageContainer: View {
    
    let image: NSImage?
    var body: some View {
        ZStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Provide a valid URL")
                    .font(.headline)
            }
        }
        .frame(width: 400, height: 400)
    }
}

struct AppClipImageContainer_Previews: PreviewProvider {
    static var previews: some View {
        ImageContainer(image: #imageLiteral(resourceName: "image"))
    }
}
