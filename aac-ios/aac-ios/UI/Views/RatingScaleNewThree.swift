//
//  RatingScaleNewThree.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI
import Firebase

struct RatingScaleActivityTwo: View {
    @State private var selectedButton: String = "5 levels"
    @State private var numberButtons: Int = 5
    @State private var numSelected: String = "battery.50percent"
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
                        numSelected = "battery.50percent"
                    }
                    Spacer()
                    RatingScaleLevelButtonTwo(labelText: "5 levels", selected: selectedButton == "5 levels").onTapGesture {
                        selectedButton = "5 levels"
                        numberButtons = 5
                        numSelected = "battery.50percent"
                        
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
                        let batteryPercent = getBatteryPercent(for: level)
                        let imageRef = "battery.\(batteryPercent)percent"
                        RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons).onTapGesture {
                            numSelected = imageRef
                            saveRating(level: level)
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
    func getBatteryPercent(for level: Int) -> Int {
        if numberButtons == 5 {
            switch level {
            case 1:
                return 0
            case 2:
                return 25
            case 3:
                return 50
            case 4:
                return 75
            default:
                return 100
            }
        } else {
            switch level {
            case 1:
                return 0
            case 2:
                return 50
            default:
                return 100
            }
        }
    }

    
}

struct RatingScaleLevelButtonTwo: View {
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
    private func saveRating(level: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let ratingData: [String: Any] = [
            "userID": userId,
            "ratingValue": level,
            "timestamp": ServerValue.timestamp()
        ]
        
        let ref = Database.database().reference()
        ref.child("ratings").childByAutoId().setValue(ratingData) { error, _ in
            if let error = error {
                print("Error saving rating: \(error.localizedDescription)")
            } else {
                print("Rating saved successfully!")
            }
        }
    }
}

struct RatingScaleSelectionButtonTwo: View {
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

struct RatingScaleActivityTwo_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivityTwo()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

