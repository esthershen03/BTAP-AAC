//
//  GridTile.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/18/23.
//

import SwiftUI

func saveTileStateToUserDefaults(tileType: String, isRemoved: Bool) {
    UserDefaults.standard.set(isRemoved, forKey: tileType)
}

func fetchTileStateFromUserDefaults(tileType: String) -> Bool {
    return UserDefaults.standard.bool(forKey: tileType)
}

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
                .frame(width: 170, height: 170)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("AACGrey"))
                .offset(y: configuration.isPressed ? 3 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(width: 170, height: 170)
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

    @State private var isTileRemoved: Bool = false
    
    init(labelText: String, image: Image, tileType: String, onRemove: @escaping () -> Void, onClick: @escaping () -> Void) {
        self.labelText = labelText
        self.image = image
        self.tileType = tileType
        self.onRemove = onRemove
        self.onClick = onClick
        
        // Fetch tile state from UserDefaults when initializing
        self._isTileRemoved = State(initialValue: fetchTileStateFromUserDefaults(tileType: tileType))
    }
    
    var body: some View {
        Button(action: onClick) {
            VStack {
                Spacer()
                    .frame(height: 40)
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
        .frame(width:170,height:170)
        .buttonStyle(GridTileStyle(tileType: tileType, onRemove: onRemove))
        .padding(20)
        .onAppear {
            // Fetch the state from UserDefaults when the view appears
            self.isTileRemoved = fetchTileStateFromUserDefaults(tileType: tileType)
        }
        .onChange(of: isTileRemoved) { newValue in
            // Save the new state to UserDefaults when the removal state changes
            saveTileStateToUserDefaults(tileType: tileType, isRemoved: newValue)
        }
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
