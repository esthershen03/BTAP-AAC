//
//  WhiteBoard.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import PhotosUI
import CoreData

let whiteboardImageViewModel = WhiteboardImageViewModel()

struct Line {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}

struct WhiteBoard: View {
    @StateObject var lvm = LineViewModel()
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    @State private var showConfirmation: Bool = false
    @State private var showSaveConfirm: Bool = false
    @State var galleryClicked = false
    @State var cameraClicked = false
    @State var inputImage: UIImage? = nil
    @State var imageText = false
    @StateObject private var viewState = ViewStateData()
    @State var deletedAllLines = false
    @State private var showFolder = false
    @State var savedDrawingNames: [String] = [] // list of all saved drawings
    @State var currentImageName: String = "" // name to save current drawing

    
    
    let engine = DrawingEngine()
    
    var body: some View {
        ZStack{
            VStack() {
                HStack{
                    VStack {
                        ZStack {
                            // button to add photo
                            PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData, inputImage: $inputImage, screen: "whiteboard")
                            
                            // code for actual whiteboard
                            Canvas { context, size in
                                
                                //                            for oldLine in lvm.fetchLines() {
                                //                                let oldPath = engine.createPath(for: oldLine.points)
                                //                                context.stroke(oldPath, with: .color(oldLine.color), style: StrokeStyle(lineWidth: oldLine.lineWidth, lineCap: .round, lineJoin: .round))
                                //                            }
                                
                                for line in lines {
                                    let path = engine.createPath(for: line.points)
                                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                                    lvm.addLine(points: line.points, color:line.color, lineWidth: line.lineWidth)
                                    
                                }
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("AACGrey").opacity(inputImage == nil ? 1 : 0))
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
                                .padding()
                        } // end of Zstack
                        
                        // horizontal row of black buttons
                        HStack {
                            // undo button
                            Button {
                                deletedAllLines = false
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
                            
                            // redo button
                            Button {
                                if deletedAllLines {
                                    lines = deletedLines
                                    deletedLines = [Line]()
                                    deletedAllLines = false
                                } else {
                                    let last = deletedLines.removeLast()
                                    
                                    lines.append(last)
                                }
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
                            
                            // remove all lines button
                            Button {
                                deletedLines = lines
                                lines = [Line]()
                                deletedAllLines = true
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }
                                
                            }.disabled(lines.count == 0)
                                .padding(5)
                            
                            // remove picture button
                            Button {
                                inputImage = nil
                                whiteboardImageViewModel.saveImage(nil)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "rectangle.on.rectangle.slash.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }
                            }.padding(5)
                            
                            // trash button (clear drawing and lines)
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
                                .foregroundColor(.red)
                                .alert(isPresented: $showConfirmation) {
                                    Alert(
                                        title: Text("Are you sure you want to delete everything?"),
                                        message: Text("There is no undo."),
                                        primaryButton: .destructive(Text("Delete")) {
                                            lines = [Line]()
                                            deletedLines = [Line]()
                                            inputImage = nil
                                            whiteboardImageViewModel.saveImage(nil)
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                .padding(5)
                            
                            // save image button
                            Button {
                                showSaveConfirm = true
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                    Ellipse()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.down.to.line.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.black)
                                }
                            }
                                .foregroundColor(.red)
                                .alert("Enter the name of your drawing.", isPresented: $showSaveConfirm) {
                                    TextField("drawing name", text: $currentImageName)
                                    // replace action with real save functionality
                                    Button("Save", action: {
                                        whiteboardImageViewModel.saveImage(nil)
                                        savedDrawingNames.append(currentImageName)
                                        } )
                                    Button("Cancel", role: .cancel) {}
                                }
                                .padding(5)
                            
                            // push color picker to right
                            Spacer()
                            Spacer()
                            
                            // color picker and slider
                            ColorPicker("line color", selection: $selectedColor)
                                .labelsHidden()
                            Slider(value: $selectedLineWidth, in: 1...20) {
                                Text("linewidth")
                            }.frame(maxWidth: 300)
                            Text(String(format: "%.0f", selectedLineWidth))
                        }.padding()
                    } // end of H-Stack
                    
                    // vertical column of blue buttons
                    VStack(spacing: 30) {
                        PhotoUploadView.ButtonWithIcon(systemName: "camera.fill", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        // saved drawings button that triggers pop-up
                        Button(action: {
                            withAnimation {
                                showFolder.toggle()
                            }
                        }) {
                            Image(systemName: "folder")
                                .resizable()
                                .frame(width: 65, height: 55)
                                .foregroundColor(.black)
                                .padding(20)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                                .shadow(color: Color.black, radius: false ? 15 : 25, x: 0, y: 20)
                        )
                        .background(Color("AACBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 15)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut)
                    }
                    .padding()
                    .navigationBarHidden(true)
                }
                .padding(20)
            }.onAppear { // refreshing in case image added
                if let loadedImage = whiteboardImageViewModel.loadImage() {
                    inputImage = loadedImage
                }
                return
            }// end of v stack
            
            // saved drawings pop-up (only show when showFolder is true)
            if showFolder {
                ZStack { // outer z stack for entire sheet and grey background
                    Color.black.opacity(0.15)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            // Hide the popup when the background is tapped
                            withAnimation {
                                showFolder.toggle()
                            }
                        }

                    ZStack(alignment: .topLeading) { // inner zstack for drawings area
                        // Main popup content
                        VStack {
                            Text("Saved Drawings")
                                .font(.system(size: 40))
                                .padding()
                            
                            ScrollView {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 60) {
                                    // Create a button for each category
                                    ForEach(savedDrawingNames, id: \.self) { name in
                                        WhiteBoardTile(labelText: name)
                                    }
                                }
                                .padding()
                            }                        }
                        .frame(width: 1000, height: 750)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 20)

                        // Close button (top-right)
                        Image(systemName: "x.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .padding(25)
                            .onTapGesture {
                                withAnimation {
                                    showFolder.toggle()
                                }
                            }
                    }
                    .frame(width: 1000, height: 750)
                }
                .transition(.move(edge: .bottom)) // Apply the transition to the inner z stack
                .animation(.easeInOut)
            } // end of outer z stack
        } // end of entire z stack for the whole view
    } //body view
} // white board struct

// tile for saved drawing
struct WhiteBoardTile: View {
    let labelText: String
    let image: String = "photo.artframe" // should be replaced with preview of image
    var available: Bool = false
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
           Spacer()
               .frame(height: 10)
               
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
               
               // currently using logos as placeholder; must be replaced with preview of drawing
               Image(systemName: image)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 75, height: 75)
                   .foregroundColor(Color(imageColor))

               
               Spacer()
                   .frame(height: 10)
    
               
               Text(labelText)
                   .font(.system(size: 26))
                   .multilineTextAlignment(.leading)
                   .padding(.horizontal)
               
               Spacer()
                   .frame(height: 10)
           }
           
       }
       
    }
}

struct WhiteBoard_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBoard()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
