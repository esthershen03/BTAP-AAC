//
//  RatingScale.swift
//  aac-ios
//
//  Created by harshitha kotlure on 11/17/23.
//

import SwiftUI
import Foundation

struct RatingScale: View {
    @State private var is3levelPopoverVisible = false
    @State private var is5levelPopoverVisible = false
    @State private var selectedLevel: Int?
    
    var body: some View {
        HStack() {
            Button(action: {
                is3levelPopoverVisible.toggle()
                selectedLevel = 3
                saveSelectedLevel(selectedLevel: level)
            }) {
                Text("3 levels")
                
            }
            .popover(isPresented: $is3levelPopoverVisible) {
                RatingPopoverView(selectedLevel: $selectedLevel)
            }
            .frame(width: 135, height: 90)
            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            
            Button(action: {
                is5levelPopoverVisible.toggle()
                           selectedLevel = 5
                           saveSelectedLevel(level: selectedLevel!)
                       }) {
                           Text("5 levels")
                       }
                       .popover(isPresented: $is5levelPopoverVisible) {
                           RatingPopoverView(selectedLevel: $selectedLevel)
                       }
                       .frame(width: 135, height: 90)
                       .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                       .foregroundColor(.black)
                       .cornerRadius(10)
                       .padding()

            Button(action: {
                
            }) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(.system(size: 70, weight: .thin))
                }
            }
            .frame(width: 135, height: 90)
            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
        }
        Spacer()
        .onAppear {
            selectedLevel = retrieveSelectedLevel()
        }
        
    }
}

/* Allows for user's selected rating level to be saved 
* @param selectedLevel: Int - the integer representing the rating scale 
* UserDefaults is the instance that stores data
* set saves the value and key is what it is saved as 
* does it need to save multiple ratings???
*/
func saveSelectedLevel(selectedLevel: Int) {
    UserDefaults.standard.set(selectedLevel, forKey: "savedLevel")
}

/* Allows for user's saved selected rating level to be retrieved 
* @param selectedLevel: Int - the saved rating scale we want to get
* let selectedLevel means the constant value
* UserDefaults.standard.object retrieves value 
* prints the value we foumnd
*/
func retrieveSelectedLevel() -> Int? {
    if let retrievedLevel = UserDefaults.standard.object(forKey: "savedLevel") as? Int {
        print("The saved rating level is \(selectedLevel).")
        return retrievedLevel
    } else {
        print("No saved rating level found.")
        return nil 
    }
}


struct RatingPopoverView: View {
    @Binding var selectedLevel: Int?
    var body: some View {
        HStack{
            Image("Angry")
            Spacer()
            Image("sad")
            Spacer()
            Image("happy").resizable()
                .frame(width: 200, height: 200)
            
        }
            HStack {
                ForEach(1...selectedLevel!, id: \.self) { level in
                    Button(action: {
                        selectedLevel = level
                    }) {
                        Text("\(level)")
                            .font(.title)
                            .padding()
                    }
                    .frame(width:57, height: 51)
                    .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
                    Spacer()
                    
                }
            }
            .padding()
        }
    
}

struct RatingScale_Previews: PreviewProvider {
    static var previews: some View {
        RatingScale()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
