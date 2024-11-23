//
//  RatingScaleNewThree.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI

struct RatingScaleSelectionButtonThree: View {
    let image: String
    var imageColor: String = "AACBlack"
    var totalButtons: Int = 5

    var body: some View {
        VStack {}
            .frame(width: totalButtons <= 5 ? 125 : CGFloat(450 / totalButtons),
                   height: totalButtons <= 5 ? 125 : CGFloat(450 / totalButtons))
            .padding()
            .accentColor(Color.black)
            .cornerRadius(10.0)
            .background(Color("AACGrey"))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            .overlay {
                VStack {
                    Text(image) // Render emoji
                        .font(.system(size: totalButtons <= 5 ? 70 : CGFloat(300 / totalButtons))) // Adjust font size
                        .frame(width: totalButtons <= 5 ? 100 : CGFloat(450 / totalButtons),
                               height: totalButtons <= 5 ? 100 : CGFloat(450 / totalButtons))
                        .foregroundColor(Color(imageColor))
                }
            }
    }
}

struct RatingScaleLevelButtonThree: View {
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

struct RatingScaleActivityThree: View {
    @State private var selectedButton: String = UserDefaults.standard.string(forKey: "selectedButtonThree") ?? "5 levels"
    @State private var numberButtons: Int = UserDefaults.standard.integer(forKey: "numberButtonsThree") == 0 ? 5 : UserDefaults.standard.integer(forKey: "numberButtonsThree")
    @State private var numSelected: String = "😐" // Default selection
    @State private var screenSelect: String? = nil

    var body: some View {
        NavigationView() {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: RatingScaleGrid(), tag: "Rating Scale Grid", selection: $screenSelect) {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    RatingScaleLevelButtonThree(labelText: "3 levels", selected: selectedButton == "3 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "3 levels", number: 3)
                        }
                    Spacer()
                    RatingScaleLevelButtonThree(labelText: "5 levels", selected: selectedButton == "5 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "5 levels", number: 5)
                        }
                    Spacer()
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()

                HStack {
                    Text(numSelected)
                        .font(.system(size: 300))
                }
                Spacer()
                Spacer()
                Spacer()

                HStack {
                    Spacer()
                    Spacer()
                    ForEach(1...numberButtons, id: \.self) { level in
                        let emotion = getEmotion(for: level)
                        let imageRef = emotion
                        RatingScaleSelectionButtonThree(image: imageRef, totalButtons: numberButtons)
                            .onTapGesture {
                                updateSelectedValue(imageRef: imageRef)
                            }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
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
        UserDefaults.standard.set(scaleType, forKey: "selectedButtonThree")
        UserDefaults.standard.set(number, forKey: "numberButtonsThree")

        // Load the saved selection for this level
        numSelected = getSavedValue(for: scaleType) ?? "😐"
    }

    private func updateSelectedValue(imageRef: String) {
        numSelected = imageRef

        // Save the selected value for the current level
        var savedValues = UserDefaults.standard.dictionary(forKey: "selectedValuesThree") as? [String: String] ?? [:]
        savedValues[selectedButton] = imageRef
        UserDefaults.standard.set(savedValues, forKey: "selectedValuesThree")
    }

    private func loadSavedData() {
        selectedButton = UserDefaults.standard.string(forKey: "selectedButtonThree") ?? "5 levels"
        numberButtons = UserDefaults.standard.integer(forKey: "numberButtonsThree") == 0 ? 5 : UserDefaults.standard.integer(forKey: "numberButtonsThree")

        // Load the saved selection for the current level
        numSelected = getSavedValue(for: selectedButton) ?? "😐"
    }

    private func getSavedValue(for level: String) -> String? {
        let savedValues = UserDefaults.standard.dictionary(forKey: "selectedValuesThree") as? [String: String]
        return savedValues?[level]
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

struct RatingScaleActivityThree_Preview: PreviewProvider {
    static var previews: some View {
        RatingScaleActivityThree()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
