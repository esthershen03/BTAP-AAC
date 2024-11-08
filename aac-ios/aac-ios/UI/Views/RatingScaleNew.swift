//
//  RatingScaleNew.swift
//  aac-ios
//
//  Created by Smera Bhatia on 3/9/24.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "RatingScaleModel") // Replace with your actual model name
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    // Save a new RatingScale
    func saveRatingScale(id: String, labelText: String, image: String, isAvailable: Bool, imageColor: String) {
        let context = container.viewContext
        let ratingScale = RatingScaleEntity(context: context)
        ratingScale.id = id
        ratingScale.labelText = labelText
        ratingScale.image = image
        ratingScale.isAvailable = isAvailable
        ratingScale.imageColor = imageColor
        
        do {
            try context.save()
        } catch {
            print("Failed to save rating scale: \(error)")
        }
    }

    // Fetch all RatingScales
    func fetchAllRatingScales() -> [RatingScaleEntity] {
        let context = container.viewContext
        let request: NSFetchRequest<RatingScaleEntity> = RatingScaleEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch rating scales: \(error)")
            return []
        }
    }

    // Update a RatingScale
    func updateRatingScale(ratingScale: RatingScaleEntity, labelText: String?, image: String?, isAvailable: Bool?, imageColor: String?) {
        let context = container.viewContext
        if let labelText = labelText {
            ratingScale.labelText = labelText
        }
        if let image = image {
            ratingScale.image = image
        }
        if let isAvailable = isAvailable {
            ratingScale.isAvailable = isAvailable
        }
        if let imageColor = imageColor {
            ratingScale.imageColor = imageColor
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to update rating scale: \(error)")
        }
    }

    // Delete a RatingScale
    func deleteRatingScale(ratingScale: RatingScaleEntity) {
        let context = container.viewContext
        context.delete(ratingScale)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete rating scale: \(error)")
        }
    }
}

struct RatingScaleGrid: View {
    @State private var selectedScale: String? = nil
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \RatingScaleEntity.id, ascending: true)], animation: .default)
    private var ratingScales: FetchedResults<RatingScaleEntity> // Fetch all RatingScales from Core Data
    
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                
                // Use the fetched rating scales to populate the RatingScaleCategoryButton views
                ForEach(ratingScales) { scale in
                    NavigationLink(destination: RatingScaleActivity(), tag: scale.id ?? "", selection: $selectedScale) {
                        RatingScaleCategoryButton(
                            labelText: scale.labelText ?? "",
                            image: scale.image ?? "",
                            available: scale.isAvailable,
                            imageColor: scale.imageColor ?? "AACBlack"
                        )
                    }.buttonStyle(.plain)
                }
                
                Spacer()
                
                // Example of saving a new rating scale on appearance
                Button("Save New Scale") {
                    CoreDataManager.shared.saveRatingScale(id: "Numeric", labelText: "Numeric", image: "list.number", isAvailable: true, imageColor: "AACBlack")
                }
            }
            .onAppear {
                // Example of saving a new rating scale when the view appears
                if ratingScales.isEmpty {
                    CoreDataManager.shared.saveRatingScale(id: "Numeric", labelText: "Numeric", image: "list.number", isAvailable: true, imageColor: "AACBlack")
                    CoreDataManager.shared.saveRatingScale(id: "Energy", labelText: "Energy", image: "bolt.batteryblock", isAvailable: true, imageColor: "BatteryGreen")
                    CoreDataManager.shared.saveRatingScale(id: "Pain", labelText: "Pain", image: "bandage", isAvailable: true, imageColor: "BandageBrown")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("").font(.system(size: 1)), displayMode: .inline)
        .navigationBarHidden(true)
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
               Spacer().frame(height: 10)
               
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
