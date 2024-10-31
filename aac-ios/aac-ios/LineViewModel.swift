import Foundation
import FirebaseDatabase
import SwiftUI

@objc(LineEntity)
public class LineEntity: NSObject {
    var points: [NSValue]?
    var color: String?
    var lineWidth: Float

    init(points: [NSValue]?, color: String?, lineWidth: Float) { // Added initializer
        self.points = points
        self.color = color
        self.lineWidth = lineWidth
    }
}

class LineViewModel: ObservableObject {
    private var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func addLine(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        let line = LineEntity(points: points.map { NSValue(cgPoint: $0) }, color: color.description, lineWidth: Float(lineWidth))
        let newLineRef = ref.child("lines").childByAutoId()
        let lineData: [String: Any] = [
            "points": line.points?.map { ["x": $0.cgPointValue.x, "y": $0.cgPointValue.y] }, // Keep as is
            "color": line.color ?? "", // Keep as is
            "lineWidth": line.lineWidth // Keep as is
        ]
        newLineRef.setValue(lineData) { error, _ in
            if let error = error {
                print("Saving Error: \(error.localizedDescription)")
            } else {
                print("Saved line data successfully!")
            }
        }
    }
    
    func fetchLines() -> [Line] {
        var lines: [Line] = []
        let ref = Database.database().reference().child("lines")
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let lineDict = childSnapshot.value as? [String: Any],
                   let pointsArray = lineDict["points"] as? [[String: CGFloat]],
                   let colorString = lineDict["color"] as? String,
                   let lineWidth = lineDict["lineWidth"] as? Float {
                
                    let points = pointsArray.map { CGPoint(x: $0["x"] ?? 0, y: $0["y"] ?? 0) }
                    let color = Color(colorString) // Convert string to Color
                    lines.append(Line(points: points, color: color, lineWidth: CGFloat(lineWidth)))
                }
            }
        }
        return lines
    }
}
