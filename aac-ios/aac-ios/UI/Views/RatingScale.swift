//
//  RatingScale.swift
//  aac-ios
//
//  Created by harshitha kotlure on 11/17/23.
//

import SwiftUI

struct RatingScale: View {
    @State private var is3levelPopoverVisible = false
    @State private var is5levelPopoverVisible = false
    @State private var selectedLevel: Int?
    
    var body: some View {
        HStack() {
            Button(action: {
                is3levelPopoverVisible.toggle()
                selectedLevel = 3
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
