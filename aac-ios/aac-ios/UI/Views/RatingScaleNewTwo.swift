//
//  RatingScaleNewTwo.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//
import SwiftUI

struct RatingScaleSelectionButton: View {
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

struct RatingScaleLevelButton: View {
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


struct RatingScaleActivity: View {
    @State private var selectedButton: String = UserDefaults.standard.string(forKey: "selectedButton") ?? "5 levels"
    @State private var numberButtons: Int = UserDefaults.standard.integer(forKey: "numberButtons") == 0 ? 5 : UserDefaults.standard.integer(forKey: "numberButtons")
    @State private var numSelected: String = "1.square" // Default selection for any level
    @State private var screenSelect: String? = nil

    var body: some View {
        NavigationView {
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
                    RatingScaleLevelButton(labelText: "3 levels", selected: selectedButton == "3 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "3 levels", number: 3)
                        }
                    Spacer()
                    RatingScaleLevelButton(labelText: "5 levels", selected: selectedButton == "5 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "5 levels", number: 5)
                        }
                    Spacer()
                    RatingScaleLevelButton(labelText: "7 levels", selected: selectedButton == "7 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "7 levels", number: 7)
                        }
                    Spacer()
                    RatingScaleLevelButton(labelText: "10 levels", selected: selectedButton == "10 levels")
                        .onTapGesture {
                            updateSelection(scaleType: "10 levels", number: 10)
                        }
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
                        let imageRef = "\(level).square"
                        RatingScaleSelectionButton(image: imageRef, totalButtons: numberButtons)
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
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        Spacer()
    }

    // MARK: - Data Persistence Functions

    private func updateSelection(scaleType: String, number: Int) {
        selectedButton = scaleType
        numberButtons = number
        UserDefaults.standard.set(scaleType, forKey: "selectedButton")
        UserDefaults.standard.set(number, forKey: "numberButtons")
        
        // Load the saved selection for this level
        numSelected = getSavedValue(for: scaleType) ?? "1.square"
    }

    private func updateSelectedValue(imageRef: String) {
        numSelected = imageRef
        
        // Save the selected value for the current level
        var savedValues = UserDefaults.standard.dictionary(forKey: "selectedValues") as? [String: String] ?? [:]
        savedValues[selectedButton] = imageRef
        UserDefaults.standard.set(savedValues, forKey: "selectedValues")
    }

    private func loadSavedData() {
        selectedButton = UserDefaults.standard.string(forKey: "selectedButton") ?? "5 levels"
        numberButtons = UserDefaults.standard.integer(forKey: "numberButtons") == 0 ? 5 : UserDefaults.standard.integer(forKey: "numberButtons")
        
        // Load the saved selection for the current level
        numSelected = getSavedValue(for: selectedButton) ?? "1.square"
    }

    private func getSavedValue(for level: String) -> String? {
        let savedValues = UserDefaults.standard.dictionary(forKey: "selectedValues") as? [String: String]
        return savedValues?[level]
    }
}
