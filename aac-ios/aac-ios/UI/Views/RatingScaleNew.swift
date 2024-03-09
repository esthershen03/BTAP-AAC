//
//  RatingScaleNew.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleGrid: View {
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                RatingScaleCategoryButton(labelText: "Numeric", image: "list.number", imageColor: "AACBlack")
                Spacer()
                RatingScaleCategoryButton(labelText: "Pain", image: "bandage", imageColor: "BandageBrown")
                Spacer()
                RatingScaleCategoryButton(labelText: "Energy", image: "bolt.batteryblock", imageColor: "BatteryGreen")
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
                   .frame(width: 80, height: 80)
                   .foregroundColor(Color(imageColor))

               
               Spacer()
                   .frame(height: 10)
    
               
               Text(labelText)
                   .font(.system(size: 28))
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
