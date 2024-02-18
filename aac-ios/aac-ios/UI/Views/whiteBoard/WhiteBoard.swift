//
//  WhiteBoard.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct Line {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}

struct WhiteBoard: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    @State private var thickness: Double = 1.0
    @State private var deletedLines = [Line]()
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    @State private var showConfirmation: Bool = false

        var body: some View {
            VStack() {
                Canvas { context, size in
                    
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                        
                    }
                    
                }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({
                    value in
                    let newPoint = value.location
                    currentLine.points.append(newPoint)
                    self.lines.append(currentLine)
                    
                }).onEnded({value in
                    self.lines.append(currentLine)
                    self.currentLine = Line(points: [], color: currentLine.color, lineWidth: thickness)
                })
                )
                
//                HStack {
//                                
//                    Slider(value: $thickness, in: 1...20) {
//                            Text("Thickness")
//                    }.frame(maxWidth: 200)
//                        .onChange(of: thickness) { newThickness in
//                            currentLine.lineWidth = newThickness
//                        }
//                        Divider()
//                    ColorPickerView(selectedColor: $currentLine.color)
//                                    .onChange(of: currentLine.color) { newColor in
//                                        print(newColor)
//                                        currentLine.color = newColor
//                                }
//                    Button {
//                        let last = lines.removeLast()
//                        deletedLines.append(last)
//                    } label: {
//                        Image(systemName: "arrow.uturn.backward.circle")
//                            .imageScale(.large)
//                    }.disabled(lines.count == 0)
//                    Button {
//                        let last = deletedLines.removeLast()
//                        lines.append(last)
//                    } label: {
//                        Image(systemName: "arrow.uturn.forward.circle")
//                            .imageScale(.large)
//                    }.disabled(deletedLines.count == 0)
//                }.frame(maxHeight: 50)
                HStack {
                    ColorPicker("line color", selection: $selectedColor)
                        .labelsHidden()
                    Slider(value: $selectedLineWidth, in: 1...20) {
                        Text("linewidth")
                    }.frame(maxWidth: 100)
                    Text(String(format: "%.0f", selectedLineWidth))
                    
                    Spacer()
                    
                    Button {
                        let last = lines.removeLast()
                        deletedLines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .imageScale(.large)
                    }.disabled(lines.count == 0)
                    
                    Button {
                        let last = deletedLines.removeLast()
                        
                        lines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                            .imageScale(.large)
                    }.disabled(deletedLines.count == 0)

                    Button(action: {
                       showConfirmation = true
                    }) {
                        Text("Delete")
                    }.foregroundColor(.red)
                        .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                            
                            Button("Delete", role: .destructive) {
                                lines = [Line]()
                                deletedLines = [Line]()
                            }
                        }
                                
                }.padding()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .navigationBarHidden(true)
            
        }
        
}

struct WhiteBoard_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBoard()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
