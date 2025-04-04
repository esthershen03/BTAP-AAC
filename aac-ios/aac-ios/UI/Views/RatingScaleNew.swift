//
//  RatingScaleNew.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleGrid: View {
    @State private var selectedButton: String = UserDefaults.standard.string(forKey: "selectedButton") ?? "5 levels"
    @State private var numberButtons: Int = UserDefaults.standard.integer(forKey: "numberButtons")
    @State private var numSelected: String = UserDefaults.standard.string(forKey: "numSelected") ?? "3.square"
    @State private var screenSelect: String? = nil
    @State private var selectedScale: String? = nil
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: RatingScaleActivity(), tag: "Numeric", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Numeric", image: "list.number", imageColor: "AACBlack")
                    }.buttonStyle(.plain)
                    Spacer()
                    NavigationLink(destination: RatingScaleActivityTwo(), tag: "Energy", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Energy", image: "bolt.batteryblock", imageColor: "BatteryGreen")
                    }.buttonStyle(.plain)
                    Spacer()
                    NavigationLink(destination: RatingScaleActivityThree(), tag: "Pain", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Pain", image: "bandage", imageColor: "BandageBrown")
                    }.buttonStyle(.plain)
                    Spacer()
                    NavigationLink(destination: RatingScaleActivityFour(), tag: "Response", selection: $selectedScale){
                        RatingScaleCategoryButton(labelText: "Response", image: "questionmark.bubble", imageColor: "BlueQuestion")
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
