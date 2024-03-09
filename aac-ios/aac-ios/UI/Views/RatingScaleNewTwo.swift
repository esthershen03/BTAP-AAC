//
//  RatingScaleNewTwo.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleActivity: View {
    @State private var selectedButton: String = "5 levels"
    @State private var numberButtons: Int = 5
    @State private var numSelected: String = "3.square"
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {}, label: {
                        Image(systemName: "chevron.backward.circle").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                })
                .buttonStyle(.plain)
                
                Spacer()
                RatingScaleLevelButton(labelText: "3 levels", selected: selectedButton == "3 levels").onTapGesture {
                    selectedButton = "3 levels"
                    numberButtons = 3
                    numSelected = "2.square"
                }
                Spacer()
                RatingScaleLevelButton(labelText: "5 levels", selected: selectedButton == "5 levels").onTapGesture {
                    selectedButton = "5 levels"
                    numberButtons = 5
                    numSelected = "3.square"

                }
                Spacer()
                RatingScaleLevelButton(labelText: "7 levels", selected: selectedButton == "7 levels").onTapGesture {
                    selectedButton = "7 levels"
                    numberButtons = 7
                    numSelected = "4.square"
                }
                Spacer()
                RatingScaleLevelButton(labelText: "10 levels", selected: selectedButton == "10 levels").onTapGesture {
                    selectedButton = "10 levels"
                    numberButtons = 10
                    numSelected = "5.square"
                }
                Spacer()
            }
            Spacer()
            HStack{

                Image(systemName: numSelected).resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            }
            Spacer()
            HStack{
                Spacer()
                Spacer()
                ForEach(1...numberButtons, id: \.self) { level in
                    let imageRef = "\(level).square"
                    RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons).onTapGesture {
                        numSelected = imageRef
                    }
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
        
    }
    
}

struct RatingScaleLevelButton: View {
    let labelText: String
    var selected: Bool = false
    var body: some View {
        VStack{}
       .frame(width: 200,height: 50)
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(selected ? Color("AACBlueDark") : Color("AACBlue"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selected ? CGFloat(15) : CGFloat(25), x: 0, y: 20))
       .overlay {
           HStack{
               Text(labelText)
                   .font(.system(size: 24))
                   .multilineTextAlignment(.leading)
           }
       }
    }
}

struct RatingScaleSelectionButton: View {
    let image: String
    var imageColor: String = "AACBlack"
    var totalButtons: Int = 5
    var body: some View {
        VStack{}
            .frame(width: totalButtons <= 5 ? 125 : CGFloat(625/totalButtons) , height: totalButtons <= 5 ? 125 : CGFloat(625/totalButtons) )
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(Color("AACGrey"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
       .overlay {
           VStack{
               Image(systemName: image)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: totalButtons <= 5 ? 100 : CGFloat(500/totalButtons)  , height: totalButtons <= 5 ? 100 : CGFloat(500/totalButtons) )
                   .foregroundColor(Color(imageColor))
           }
           
       }
       
    }
}

struct RatingScaleActivity_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivity()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

