//
//  LineViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/4/24.
//

import Foundation
import CoreData
import SwiftUI

class LineViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var lines: [LineEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "AAC_CoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading")
            }
        }
        fetchLines()
    }
    
    func fetchLines() {
        let request: NSFetchRequest<LineEntity> = LineEntity.fetchRequest()
        
        do {
            lines = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Lines")
            print(error)
        }
    }
    
    func addLine(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        let newLine = LineEntity(context: container.viewContext)
        newLine.points = points.map { NSValue(cgPoint: $0) }
        newLine.color = color.description // Store color as string for now
        newLine.lineWidth = Float(lineWidth)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchLines() // Update lines after saving
        } catch let error {
            print("Error Saving")
            print(error)
        }
    }
}

extension LineEntity {
    func toLine() -> Line {
        let points = self.points.compactMap { ($0 as? NSValue)?.cgPointValue }
        let color = Color(self.color)
        let lineWidth = CGFloat(self.lineWidth)
        return Line(points: points, color: color, lineWidth: lineWidth)
    }
}
