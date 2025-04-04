import Foundation
import CoreData
import SwiftUI

@objc(LineEntity)
public class LineEntity: NSManagedObject {
    @NSManaged public var points: [NSValue]?
    @NSManaged public var color: String?
    @NSManaged public var lineWidth: Float
}

class LineViewModel: ObservableObject {
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func addLine(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        let line = LineEntity(context: persistentContainer.viewContext)
        line.points = points.map { NSValue(cgPoint: $0) }
        line.color = color.description
        line.lineWidth = Float(lineWidth)
        saveContext()
    }
    
    func fetchLines() -> [Line] {
        let lineEntities = fetchLineEntities()
        return lineEntities.map { entity in
            let points = (entity.points as? [CGPoint] ?? []).map { $0 }
            let color = Color(entity.color ?? "") // Convert string to Color
            let lineWidth = CGFloat(entity.lineWidth)
            return Line(points: points, color: color, lineWidth: lineWidth)
        }
    }
    
    private func fetchLineEntities() -> [LineEntity] {
        let fetchRequest: NSFetchRequest<LineEntity> = NSFetchRequest(entityName: "LineEntity")
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch line entities: \(error)")
            return []
        }
    }

    private func saveContext() {
        do {
            try persistentContainer.viewContext.save()
            print("Saved!")
        } catch {
            print("Unable to save context: \(error)")
        }
    }
}
