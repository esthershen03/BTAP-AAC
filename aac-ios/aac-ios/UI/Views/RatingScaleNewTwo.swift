//
//  RatingScaleNewTwo.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI
import CoreData

struct RatingScaleActivity: View {
    @State private var selectedButton: String = "5 levels"
    @State private var numberButtons: Int = 5
    @State private var numSelected: String = "3.square"
    @State private var screenSelect: String? = nil

    @Environment(\.managedObjectContext) private var moc // Access to the managed object context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \RatingScaleSelection.timestamp, ascending: true)], animation: .default)
    private var selections: FetchedResults<RatingScaleSelection> // Fetch saved selections
    
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
                    RatingScaleLevelButton(labelText: "3 levels", selected: selectedButton == "3 levels").onTapGesture {
                        selectedButton = "3 levels"
                        numberButtons = 3
                        numSelected = "2.square"
                        saveSelection(level: 3)
                    }
                    Spacer()
                    RatingScaleLevelButton(labelText: "5 levels", selected: selectedButton == "5 levels").onTapGesture {
                        selectedButton = "5 levels"
                        numberButtons = 5
                        numSelected = "3.square"
                        saveSelection(level: 5)
                        
                    }
                    Spacer()
                    RatingScaleLevelButton(labelText: "7 levels", selected: selectedButton == "7 levels").onTapGesture {
                        selectedButton = "7 levels"
                        numberButtons = 7
                        numSelected = "4.square"
                        saveSelection(level: 7)
                    }
                    Spacer()
                    RatingScaleLevelButton(labelText: "10 levels", selected: selectedButton == "10 levels").onTapGesture {
                        selectedButton = "10 levels"
                        numberButtons = 10
                        numSelected = "5.square"
                        saveSelection(level: 10)
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
                Spacer()

                HStack{
                    Spacer()
                    Spacer()
                    ForEach(1...numberButtons, id: \.self) { level in
                        let imageRef = "\(level).square"
                        RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons).onTapGesture {
                            numSelected = imageRef
                            saveSelection(level: level)
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

    // Save selection to Core Data
    private func saveSelection(level: Int) {
        let newSelection = RatingScaleSelection(context: moc)
        newSelection.level = Int16(level)
        newSelection.timestamp = Date()

        do {
            try moc.save()
        } catch {
            print("Error saving selection: \(error.localizedDescription)")
        }
    }
}

struct RatingScaleLevelButton: View {
    let labelText: String
    var selected: Bool = false
    var body: some View {
        VStack{}
       .frame(width: 150,height: 50)
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

struct RatingScaleSelectionButton: View {
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

struct RatingScaleActivity_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivity()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}

