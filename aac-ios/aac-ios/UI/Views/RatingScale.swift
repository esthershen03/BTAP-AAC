//
//  RatingScale.swift
//  aac-ios
//
//  Created by harshitha kotlure on 11/17/23.
//

import SwiftUI
import CoreData

class RatingLevelMOHHandler { //Core Data handler class for RatingLevel activity
    static func clearRatingLevelMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RatingLevel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not delete RatingLevel entity records. \(error)")
        }
    }
    static func saveSelectedLevel(_ selectedLevel: Int, moc: NSManagedObjectContext) {
        // Clear previous rating data
        RatingLevelMOHandler.clearRatingLevelMO(moc: moc)
        
        if let entity = NSEntityDescription.entity(forEntityName: "RatingLevel", in: moc) {
            let ratingLevelMO = NSManagedObject(entity: entity, insertInto: moc)
            ratingLevelMO.setValue(selectedLevel, forKey: "selectedLevel")
            ratingLevelMO.setValue(Date(), forKey: "timestamp")
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    static func fetchSavedRatingLevel(in moc: NSManagedObjectContext) -> Int? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RatingLevel")
        do {
            let ratingLevels = try moc.fetch(fetchRequest)
            if let savedLevel = ratingLevels.first {
                return savedLevel.value(forKey: "selectedLevel") as? Int
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
    

struct RatingScale: View {
    @State private var is3levelPopoverVisible = false
    @State private var is5levelPopoverVisible = false
    @State private var selectedLevel: Int?
    @Environment(\.managedObjectContext) private var moc
    
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
                // Save the selected level to Core Data when the button is pressed
                if let selectedLevel = selectedLevel {
                    RatingLevelMOHandler.saveSelectedLevel(selectedLevel, moc: moc)
                }
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
        .onAppear {
            // Fetch the saved rating level on appear
            if let savedLevel = RatingLevelMOHandler.fetchSavedRatingLevel(in: moc) {
            selectedLevel = savedLevel
            }
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
