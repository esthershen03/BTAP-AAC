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
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.025))
                .offset(y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.025))
                .offset(y: configuration.isPressed ? 3 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            configuration.label
                .offset(y: configuration.isPressed ? 3 : 0)
        }
        .compositingGroup()
    }
}

struct GridTile: View {
    let labelText: String
    let image: Image
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack {
               image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                          .stroke(.white, lineWidth: 3)
                    }
                    
                
                Text(labelText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        .frame(width:150,height:150)
        .buttonStyle(GridTileStyle())
        .padding(20)
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
