//
//  GridTile.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/18/23.
//

import SwiftUI

struct GridTileStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.gray)
                .offset(y: 3)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(Color("CustomGray"))
                .offset(y: configuration.isPressed ? 3 : 0)
            
            configuration.label
                .offset(y: configuration.isPressed ? 3 : 0)
        }
        .compositingGroup()
        .shadow(radius: 6, y: 2)
    }
}

struct GridTile: View {
    let labelText: String
    let image: String
    var body: some View {
        Button(action: {print("Hello World")}) {
            VStack {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text(labelText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        .frame(width:90,height:90)
        .buttonStyle(GridTileStyle())
    }
}

struct GridTile_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GridTile(labelText: "Images",image: "eye")
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
