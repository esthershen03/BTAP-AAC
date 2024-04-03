//
//  WhiteBoard.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
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
    @State var inputImage: UIImage? = nil
    @State var imageText = false
    @StateObject private var viewState = ViewStateData()

    
    let engine = DrawingEngine()
    
        var body: some View {
            VStack() {
                HStack{
                    VStack {
                        ZStack {
                            PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData, inputImage: $inputImage)
                            Canvas { context, size in
                                
                                for line in lines {
                                    
                                    let path = engine.createPath(for: line.points)
                                    
                                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                                    
                                }
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.gray.opacity(0.2))
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
                                })
                                         
                                )
                                .padding()
                        } // end of Zstack
                        HStack {
                            Button {
                                let last = lines.removeLast()
                                deletedLines.append(last)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.uturn.backward.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }

                            }.disabled(lines.count == 0)
                            .padding(5)
                            
                            Button {
                                let last = deletedLines.removeLast()
                                
                                lines.append(last)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.uturn.forward.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }
                            }.disabled(deletedLines.count == 0)
                            .padding(5)

                            Button(action: {
                                showConfirmation = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }
                            }
                            Spacer()
                            .foregroundColor(.red)
                                .alert(isPresented: $showConfirmation) {
                                    Alert(
                                        title: Text("Are you sure you want to delete everything?"),
                                        message: Text("There is no undo"),
                                        primaryButton: .destructive(Text("Delete")) {
                                            lines = [Line]()
                                            deletedLines = [Line]()
                                            inputImage = nil
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                .padding(10)
                            ColorPicker("line color", selection: $selectedColor)
                                .labelsHidden()
                            Slider(value: $selectedLineWidth, in: 1...20) {
                                Text("linewidth")
                            }.frame(maxWidth: 300)
                            Text(String(format: "%.0f", selectedLineWidth))
                        }.padding()
                    }
                    VStack(spacing: 30) {
                        PhotoUploadView.ButtonWithIcon(systemName: "camera.fill", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        Button(action: {
                            inputImage = nil
                        }) {
                            Text("Clear Image")
                                .font(.system(size: 20))
                                .foregroundColor(.red) // Set text color to red
                        }

                    }
                        .padding()
                        .navigationBarHidden(true)
                }
                .padding(20)
                
            }
        }
}

struct WhiteBoard_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBoard()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
