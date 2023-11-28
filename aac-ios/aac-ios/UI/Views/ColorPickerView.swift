//
//  ColorPickerView.swift
//  aac-ios
//
//  Created by Karen Sun on 2023/11/18.
//

import SwiftUI

struct ColorPickerView: View {
    
    let colors = [Color.red, Color.orange, Color.green, Color.blue, Color.purple]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
            
                Image(systemName: selectedColor == color ? Icons.recordCircleFill : Icons.circleFill)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
        
    }
}

struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.blue))
    }
}

struct Icons {
    static let plusCircle = "plus.circle"
    static let line3HorizontalCircleFill = "line.3.horizontal.circle.fill"
    static let circle = "circle"
    static let circleInsetFilled = "circle.inset.filled"
    static let exclaimationMarkCircle = "exclamationmark.circle"
    static let recordCircleFill = "record.circle.fill"
    static let trayCircleFill = "tray.circle.fill"
    static let circleFill = "circle.fill"
}

