//
//  RatingScale.swift
//  aac-ios
//
//  Created by harshitha kotlure on 11/17/23.
//

import SwiftUI
import Firebase

struct RatingScale: View {
    @State private var is3levelPopoverVisible = false
    @State private var is5levelPopoverVisible = false
    @State private var selectedLevel: Int?
    
    var body: some View {
        HStack() {
            Button(action: {
                is3levelPopoverVisible.toggle()
                selectedLevel = 3
                if let level = selectedLevel {
                    saveSelectedLevel(selectedLevel: level)
                }
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
                if let level = selectedLevel {
                    saveSelectedLevel(level: selectedLevel!)
                }
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
            retrieveSelectedLevel()
        }
    }
}

/*
* Saves the user's selected rating level to Firebase.
* 
* @param selectedLevel: Int - the integer representing the user's selected rating scale.
* Firebase Realtime Database is used to store the data, structured under the user's unique ID.
* This method enables saving a single selected rating level per user.
*/
func saveSelectedLevel(selectedLevel: Int) {
    guard let userId = Auth.auth().currentUser?.uid else {
        print("User not logged in")
        return
    }

    let levelData: [String: Any] = [
    "userID": userId,
    "selectedLevel": selectedLevel,
    "timestamp": ServerValue.timestamp() // Optionally track when the data was saved
    ]
    
    let ref = Database.database().reference()
    ref.child("selectedLevels").child(userId).setValue(levelData) { error, _ in
        if let error = error {
            print("Error saving selected level: \(error.localizedDescription)")
        } else {
            print("Selected level saved successfully!")
        }
    }
}

/*
 * Retrieves the user's saved selected rating level from Firebase.
 *
 * This function accesses the Firebase Realtime Database to fetch the selected rating level for the currently logged-in user.
 * If a saved rating level is found, it updates the `selectedLevel` state variable and prints the retrieved value.
 * If no saved level is found, it prints an appropriate message.
 * 
 * @return Int? - the retrieved rating scale, or nil if the user is not logged in or no level is found.
 */
func retrieveSelectedLevel() -> Int? {
    guard let userId = Auth.auth().currentUser?.uid else {
        print("User not logged in")
        return
    }
        
    let ref = Database.database().reference()
    ref.child("selectedLevels").child(userId).observeSingleEvent(of: .value) { snapshot in
        if let value = snapshot.value as? [String: Any],
            let retrievedLevel = value["selectedLevel"] as? Int {
            print("The saved rating level is \(retrievedLevel).")
            self.selectedLevel = retrievedLevel
        } else {
            print("No saved rating level found.")
        }
    } withCancel: { error in
        print("Error retrieving selected level: \(error.localizedDescription)")
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
