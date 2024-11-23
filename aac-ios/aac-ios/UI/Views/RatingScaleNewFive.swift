//
//  RatingScaleNewThree.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleSelectionButtonFour: View {
    let image: String
    let totalButtons: Int

    var body: some View {
        VStack {}
            .frame(width: totalButtons <= 5 ? 125 : CGFloat(450 / totalButtons),
                   height: totalButtons <= 5 ? 125 : CGFloat(450 / totalButtons))
            .padding()
            .accentColor(Color.black)
            .cornerRadius(10.0)
            .background(Color.gray.opacity(0.2)) // Replace with your custom color if needed
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            .overlay {
                VStack {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: totalButtons <= 5 ? 100 : CGFloat(450 / totalButtons),
                               height: totalButtons <= 5 ? 100 : CGFloat(450 / totalButtons))
                        .foregroundColor(Color.black)
                }
            }
    }
}

struct RatingScaleLevelButtonFour: View {
    let labelText: String
    var selected: Bool = false

    var body: some View {
        VStack {}
            .frame(width: 150, height: 50)
            .padding()
            .accentColor(Color.black)
            .cornerRadius(10.0)
            .background(selected ? Color.blue : Color.gray.opacity(0.2)) // Replace with your custom colors
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            .overlay {
                Text(labelText)
                    .font(.system(size: 20))
                    .foregroundColor(selected ? .white : .black)
                    .multilineTextAlignment(.center)
            }
    }
}

struct RatingScaleActivityFour: View {
    @State private var selectedButton: String = UserDefaults.standard.string(forKey: "selectedButtonFour") ?? "3 levels"
    @State private var numberButtons: Int = UserDefaults.standard.integer(forKey: "numberButtonsFour") == 0 ? 3 : UserDefaults.standard.integer(forKey: "numberButtonsFour")
    @State private var numSelected: String = UserDefaults.standard.string(forKey: "numSelectedFour") ?? "questionmark.square"
    @State private var screenSelect: String? = nil

    var body: some View {
        NavigationView() {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: RatingScaleGrid(), tag: "Rating Scale Grid", selection: $screenSelect) {
                        Image(systemName: "chevron.backward.circle").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    RatingScaleLevelButtonFour(labelText: "3 levels", selected: selectedButton == "3 levels").onTapGesture {
                        updateSelection(scaleType: "3 levels", number: 3)
                    }
                    Spacer()
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()

                HStack {
                    Image(systemName: numSelected)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                Spacer()
                Spacer()
                Spacer()

                HStack {
                    Spacer()
                    Spacer()
                    ForEach(1...numberButtons, id: \.self) { level in
                        let personChoice = getPerson(for: level)
                        let imageRef = "\(personChoice).square"
                        RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons).onTapGesture {
                            updateSelectedValue(imageRef: imageRef, level: level)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }.onAppear {
            loadSavedData()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("").font(.system(size: 1)), displayMode: .inline)
        .navigationBarHidden(true)
        Spacer()
    }

    // MARK: - Data Persistence Functions

    private func updateSelection(scaleType: String, number: Int) {
        selectedButton = scaleType
        numberButtons = number
        UserDefaults.standard.set(scaleType, forKey: "selectedButtonFour")
        UserDefaults.standard.set(number, forKey: "numberButtonsFour")
    }

    private func updateSelectedValue(imageRef: String, level: Int) {
        numSelected = imageRef
        UserDefaults.standard.set(imageRef, forKey: "numSelectedFour")
    }

    private func loadSavedData() {
        selectedButton = UserDefaults.standard.string(forKey: "selectedButtonFour") ?? "3 levels"
        numberButtons = UserDefaults.standard.integer(forKey: "numberButtonsFour") == 0 ? 3 : UserDefaults.standard.integer(forKey: "numberButtonsFour")
        numSelected = UserDefaults.standard.string(forKey: "numSelectedFour") ?? "questionmark.square"
    }

    // Helper function to handle choice logic
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
