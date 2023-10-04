//
//  NavigationButton.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 9/20/23.
//

import Foundation
import SwiftUI

struct NavigationButton: View {
    let labelText: String
    let image: String
    var body: some View {
       VStack {
           
           Image(systemName: image)
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 50, height: 50)
           
           Text(labelText)
               .fixedSize(horizontal: false, vertical: true)
       }
       .frame(width: 100.0,height: 100.0)
       .padding()
       .accentColor(Color.black)
       .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
       .cornerRadius(10.0)
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            NavigationButton(labelText: "Images",image: "eye")
            
            NavigationButton(labelText: "White Board", image: "hand.draw")
            
            NavigationButton(labelText: "Build", image: "pencil.line")
            
            NavigationButton(labelText: "Scripts", image: "scroll")


        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
