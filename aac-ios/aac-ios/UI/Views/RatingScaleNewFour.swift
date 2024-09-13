//
//  RatingScaleNewThree.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleActivityThree: View {
    @State private var selectedButton: String = "5 levels"
    @State private var numberButtons: Int = 5
    @State private var numSelected: String = "😐"
    @State private var screenSelect: String? = nil
    
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: RatingScaleGrid(), tag: "Rating Scale Grid", selection: $screenSelect) {
                  
                            Image(systemName: "chevron.backward.circle").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)

                    }.buttonStyle(.plain)
                    
                    Spacer()
                    RatingScaleLevelButtonTwo(labelText: "3 levels", selected: selectedButton == "3 levels").onTapGesture {
                        selectedButton = "3 levels"
                        numberButtons = 3
                        numSelected = "😐"
                    }
                    Spacer()
                    RatingScaleLevelButtonTwo(labelText: "5 levels", selected: selectedButton == "5 levels").onTapGesture {
                        selectedButton = "5 levels"
                        numberButtons = 5
                        numSelected = "😐"
                        
                    }
                    Spacer()
                    Spacer()


                }
                Spacer()
                Spacer()
                Spacer()

                HStack{
                    
                    Text(numSelected)
                        .font(.system(size:300))
                    
                }
                Spacer()                    
                Spacer()
                Spacer()

                HStack{
                    Spacer()
                    Spacer()
                    ForEach(1...numberButtons, id: \.self) { level in
                        let emotion = getEmotion(for: level)
                        let imageRef = emotion
                        RatingScaleSelectionButtonThree(image: imageRef, totalButtons: numberButtons).onTapGesture {
                            numSelected = imageRef
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }

        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
            .navigationBarHidden(true)
        Spacer()

    }
    // Helper function to handle emotion logic
    func getEmotion(for level: Int) -> String {
        if numberButtons == 5 {
            switch level {
            case 1:
                return "😃"
            case 2:
                return "🙂"
            case 3:
                return "😐"
            case 4:
                return "🙁"
            default:
                return "😫"
            }
        } else {
            switch level {
            case 1:
                return "😃"
            case 2:
                return "😐"
            default:
                return "😫"
            }
        }
        
    }
}

struct RatingScaleLevelButtonThree: View {
    let labelText: String
    var selected: Bool = false
    var body: some View {
        VStack{}
       .frame(width: 400,height: 50)
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(selected ? Color("AACBlueDark") : Color("AACBlue"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selected ? CGFloat(15) : CGFloat(25), x: 0, y: 20))
       .overlay {
           HStack{
               Text(labelText)
                   .font(.system(size: 28))
                   .multilineTextAlignment(.leading)
           }
       }
    }
}

struct RatingScaleSelectionButtonThree: View {
    let image: String
    var imageColor: String = "AACBlack"
    var totalButtons: Int = 5
    var body: some View {
        VStack{}
            .frame(width: totalButtons <= 5 ? 125 : CGFloat(450/totalButtons) , height: totalButtons <= 5 ? 125 : CGFloat(450/totalButtons) )
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(Color("AACGrey"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
       .overlay {
           VStack{
               Text(image)
                   .font(.system(size:90))
                   .frame(width: totalButtons <= 5 ? 100 : CGFloat(450/totalButtons)  , height: totalButtons <= 5 ? 100 : CGFloat(450/totalButtons) )
                   .foregroundColor(Color(imageColor))
           }
           
       }
       
    }
}

struct RatingScaleActivityThree_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivityThree()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

