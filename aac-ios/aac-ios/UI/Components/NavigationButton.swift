//
//  NavigationButton.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 9/22/23.
//

import Foundation
import SwiftUI

struct NavigationButton: View {
    let labelText: String
    let image: String
    var body: some View {
        Button(action: {
           print("Button pressed")
       }) {
           VStack {
               Image(systemName: image)
                   .font(.largeTitle)
               Text(labelText)
           }
           .padding()
           .border(Color.gray, width: 2)
           .cornerRadius(5.0)
       }
       .buttonBorderShape(.roundedRectangle)
       .frame(width: 200.0, height: 200.0)
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(labelText: "Hello", image: "cloud.heavyrain.fill")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
