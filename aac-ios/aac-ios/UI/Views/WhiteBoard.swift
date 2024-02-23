//
//  WhiteBoard.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

struct Line {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}

struct WhiteBoard: View {
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    @State private var showConfirmation: Bool = false
    @State var galleryClicked = false
    @State var cameraClicked = false
    @State var imageText = false

    let engine = DrawingEngine()

    var body: some View {
        HStack(spacing: 50) {
            VStack() {
                ZStack() {
                    PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageDisplayText: $imageText)
                    VStack(spacing: 50) {
                        Canvas { context, size in
                            for line in lines {
                                
                                let path = engine.createPath(for: line.points)
                                
                                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                                
                            }
                        }
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                            let newPoint = value.location
                            if value.translation.width + value.translation.height == 0 {
                                lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                            } else {
                                let index = lines.count - 1
                                lines[index].points.append(newPoint)
                            }
                            
                        }).onEnded({ value in
                            if let last = lines.last?.points, last.isEmpty {
                                lines.removeLast()
                            }
                        }))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .navigationBarHidden(true)
                    
                }.padding(30) // zstack end
                HStack {
                    ColorPicker("line color", selection: $selectedColor)
                        .labelsHidden()
                    Slider(value: $selectedLineWidth, in: 1...20) {
                        Text("linewidth")
                    }.frame(maxWidth: 100)
                    Text(String(format: "%.0f", selectedLineWidth))
                    
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
                        Text("Delete All")
                    }.foregroundColor(.red)
                        .alert(isPresented: $showConfirmation) {
                            Alert(
                                title: Text("Are you sure you want to delete everything?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    lines = [Line]()
                                    deletedLines = [Line]()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                }
            }
            
            VStack() {
                PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
                PhotoUploadView.ButtonWithIcon(systemName: "camera", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
            }
        }.padding(30)
    }
}

struct WhiteBoard_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBoard()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

