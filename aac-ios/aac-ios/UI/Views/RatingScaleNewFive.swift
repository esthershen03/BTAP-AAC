//
//  RatingScaleNewThree.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleActivityFour: View {
    @State private var selectedButton: String = "3 levels"
    @State private var numberButtons: Int = 3
    @State private var numSelected: String = "questionmark.square"
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
                    RatingScaleLevelButtonFour(labelText: "3 levels", selected: selectedButton == "3 levels").onTapGesture {
                        selectedButton = "3 levels"
                        numberButtons = 3
                        numSelected = "questionmark.square"
                    }
                    Spacer()
                    Spacer()


                }
                Spacer()
                Spacer()
                Spacer()

                HStack{
                    
                    Image(systemName: numSelected).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                Spacer()                    
                Spacer()
                Spacer()

                HStack{
                    Spacer()
                    Spacer()
                    ForEach(1...numberButtons, id: \.self) { level in
                        let personChoice = getPerson(for: level)
                        let imageRef = "\(personChoice).square"
                        RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons).onTapGesture {
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
    // Helper function to handle battery percentage logic
    func getPerson(for level: Int) -> String {
            switch level {
            case 1:
                return "checkmark"
            case 2:
                return "questionmark"
            default:
                return "xmark"
            }
    }
}

struct RatingScaleLevelButtonFour: View {
    let labelText: String
    var selected: Bool = false
    var body: some View {
        VStack{}
       .frame(width: 850,height: 50)
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

struct RatingScaleSelectionButtonFour: View {
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
               Image(systemName: image)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: totalButtons <= 5 ? 100 : CGFloat(450/totalButtons)  , height: totalButtons <= 5 ? 100 : CGFloat(450/totalButtons) )
                   .foregroundColor(Color(imageColor))
           }
           
       }
       
    }
}

struct RatingScaleActivityFour_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivityFour()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

