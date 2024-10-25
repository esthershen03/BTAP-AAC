                //
//  RatingScaleNew.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI
import Firebase

struct RatingScaleGrid: View {
    @State private var selectedScale: String? = UserDefaults.standard.string(forKey: "selectedScale") ?? nil
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: RatingScaleActivity(), tag: "Numeric", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Numeric", image: "list.number", imageColor: "AACBlack")
                            .onTapGesture {
                                saveSelectedScale("Numeric)
                            }
                    }.buttonStyle(.plain)
                    Spacer()
                        
                    NavigationLink(destination: RatingScaleActivityTwo(), tag: "Energy", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Energy", image: "bolt.batteryblock", imageColor: "BatteryGreen")
                            .onTapGesture {
                                saveSelectedScale("Energy")
                            }
                    }.buttonStyle(.plain)
                    Spacer()
                        
                    NavigationLink(destination: RatingScaleActivityThree(), tag: "Pain", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Pain", image: "bandage", imageColor: "BandageBrown")
                            .onTapGesture {
                                saveSelectedScale("Pain") // Save when tapped
                            }
                    }.buttonStyle(.plain)
                    Spacer()
                        
                    NavigationLink(destination: RatingScaleActivityFour(), tag: "Response", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Response", image: "questionmark.bubble", imageColor: "BlueQuestion")
                            .onTapGesture {
                                saveSelectedScale("Response") // Save when tapped
                            }
                    }.buttonStyle(.plain)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                    RatingScaleCategoryButton(labelText: "", image: "", available: false)
                    Spacer()
                }
                Spacer()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
            .navigationBarHidden(true)
        Spacer()
    }
    private func saveSelectedScale(_ scale: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let scaleData: [String: Any] = [
            "userID": userId,
            "selectedScale": scale,
            "timestamp": ServerValue.timestamp()
        ]
        
        let ref = Database.database().reference()
        ref.child("selectedScales").childByAutoId().setValue(scaleData) { error, _ in
            if let error = error {
                print("Error saving selected scale: \(error.localizedDescription)")
            } else {
                print("Selected scale saved successfully!")
            }
        }
    }
}

struct RatingScaleCategoryButton: View {
    let labelText: String
    let image: String
    var available: Bool = true
    var imageColor: String = "AACBlack"
    var body: some View {
        VStack{}
       .frame(width: 160,height: 160)
       .padding()
       .accentColor(Color.black)
       .cornerRadius(10.0)
       .background(Color("AACGrey"))
       .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
       .overlay {
           VStack{
           Spacer()
               .frame(height: 10)
               
               if(available) {
                   HStack {
                       Spacer()
                           .frame(width: 135)
                       Image(systemName: "chevron.right.circle")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 25, height: 25)
                   }
               }
               
               Spacer()
                   .frame(height: 5)
               
               Image(systemName: image)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 75, height: 75)
                   .foregroundColor(Color(imageColor))

               
               Spacer()
                   .frame(height: 10)
    
               
               Text(labelText)
                   .font(.system(size: 32))
                   .multilineTextAlignment(.leading)
               
               Spacer()
                   .frame(height: 10)
           }
           
       }
       
    }
}

struct RatingScaleGrid_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleGrid()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}
