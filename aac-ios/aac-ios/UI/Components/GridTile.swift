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
    let image: Image
    var body: some View {
        Button(action: {print("Hello World")}) {
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                          .stroke(.white, lineWidth: 3)
                    }
                    .shadow(radius: 6, y: 2)
                    
                
                Text(labelText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        .frame(width:100,height:100)
        .buttonStyle(GridTileStyle())
    }
}

//struct GridTile_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            GridTile(labelText: "Images",image: "eye")
//        }
//        .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
