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
    let engine = DrawingEngine()
    
    @StateObject private var viewState = ViewStateData()
    @State var galleryClicked = false
    @State var cameraClicked = false

        var body: some View {
            VStack() {
                HStack{
                    VStack {
                        Canvas { context, size in
                            
                            for line in lines {
                                
                                let path = engine.createPath(for: line.points)
                                
                                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                                
                            }
                        }.frame(maxWidth: .infinity, maxHeight: 600)
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
                    VStack(spacing: 50) {
                        PhotoUploadView2.ButtonWithIcon(systemName: "camera.fill", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        PhotoUploadView2.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
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

struct PhotoUploadView2: View {
    //includes the left rectangle
    @Binding var galleryClicked: Bool
    @Binding var cameraClicked: Bool
    @Binding var imageData: Data?
    @State var image: Image?
    @State var inputImage: UIImage?
    
    
    let context = CIContext()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                .border(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(15)
                .alignmentGuide(.top) { dimensions in
                    dimensions[VerticalAlignment.top]
                }
            Text("Image will display here")
                .font(.title)
                .foregroundColor(Color.gray)
            Image(uiImage: inputImage ?? UIImage())
                .resizable()
                .scaledToFit()
                .padding(17)
        }
        //makes the image picker pop up show when gallery is clicked
        .sheet(isPresented: $galleryClicked) {
            ImagePicker(image: $inputImage, sourceType: .photoLibrary)
        }
        .onChange(of: inputImage) { _ in loadImageFromGallery()
        }
        .sheet(isPresented: $cameraClicked) {
            ImagePicker(image: $inputImage, sourceType: .camera)
        }
        
        
    }//end of struct
    
    func loadImageFromGallery() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    struct ButtonWithIcon: View { //includes the bottom right buttons
        let systemName: String
        let selected: Bool = false
        //need to make it do a different thing based on whether camera or gallery clicked
        @Binding var galleryClicked: Bool
        @Binding var cameraClicked: Bool
        @Binding var imageData: Data?
        var body: some View {
            VStack{}
                .frame(width: 90.0,height: 90.0)
                .padding()
                .accentColor(Color.black)
                .cornerRadius(10.0)
                .background(Color("AACBlue"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selected ? CGFloat(15) : CGFloat(25), x: 0, y: 20))
                .overlay {
                    HStack{
                        Image(systemName: systemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                        Button(action: {
                            if systemName == "photo" {
                                galleryClicked = true
                            } else if systemName == "camera" {
                                cameraClicked = true
                            }
                        }) {
                            //image already set above
                        }
                    }
                }
        }
    }
}
