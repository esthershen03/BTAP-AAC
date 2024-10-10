//
//  GridTile.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/18/23.
//

import SwiftUI

struct GridTileStyle: ButtonStyle {
    let tileType: String
    let onRemove: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("AACGrey"))
                .offset(y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(width: 190, height: 190)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("AACGrey"))
                .offset(y: configuration.isPressed ? 3 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(width: 190, height: 190)
            if (tileType == "Folder") {
                VStack{
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .padding([.top, .trailing], 15)
                    }
                    Spacer()
                }
            }
            if (tileType == "DroppedTile") {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            onRemove()
                        }) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .padding([.top, .trailing], 6)
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
            }
            configuration.label
                .offset(y: configuration.isPressed ? 3 : 0)
        }
        .compositingGroup()
    }
}

struct GridTile: View {
    let labelText: String
    let image: Image
    let tileType: String
    let onRemove: () -> Void
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack {
                Spacer()
                    .frame(height: 15)
               image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                          .stroke(.white, lineWidth: 3)
                    }
                Spacer()
                    .frame(height: 10)
                
                Text(labelText)
                    .font(.system(size: 32))
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(height: 10)
            }
            
        }
        .frame(width:190,height:190)
        .buttonStyle(GridTileStyle(tileType: tileType, onRemove: onRemove))
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
