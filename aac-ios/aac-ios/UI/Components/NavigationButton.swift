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
    var selected: Bool = false
    var body: some View {
        VStack{}
       .frame(width: 150.0,height: 90.0)
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(selected ? Color("AACBlueDark") : Color("AACBlue"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selected ? CGFloat(15) : CGFloat(25), x: 0, y: 20))
       .overlay {
           HStack{
               Image(systemName: image)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 50, height: 50)
               
               Spacer()
                   .frame(width: 18)
               
               Text(labelText)
                   .font(.system(size: 26))
                   .multilineTextAlignment(.leading)
           }
           
       }
       
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            NavigationButton(labelText: "Scene Display",image: "photo.circle", selected: true)
            
            NavigationButton(labelText: "White Board", image: "square.and.pencil")
            
            NavigationButton(labelText: "Build", image: "hammer")
            
            NavigationButton(labelText: "Scripts", image: "scroll")
            
            NavigationButton(labelText: "Rating Scale", image: "face.smiling")
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
