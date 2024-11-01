//
//  SceneDisplay.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import Foundation
import AVFoundation

class ViewStateData: ObservableObject {
    @Published var imageData: Data?

    init(imageData: Data? = nil) {
        self.imageData = imageData
    }
}

let imageViewModel = VSDImageViewModel()

struct SceneDisplay: View {
        @StateObject private var viewState = ViewStateData()
        @State var galleryClicked = false
        @State var cameraClicked = false
        @State private var showFolder = false
        @State var inputImage: UIImage? = nil
        @State var savedSceneDisplayNames: [String] = []
        @State var currentSceneDisplayName: String = ""
        @State private var showSaveConfirm: Bool = false

    var body: some View {
        ZStack {
            HStack() {
                PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData, inputImage: $inputImage, screen: "VSD")
                VStack {
                    TextFieldsView()
                    Divider()
                    HStack(spacing: 2) {
                        Button {
                            showSaveConfirm = true
                        } label: {
                            Image(systemName: "arrow.down.to.line.circle")
                                .resizable()
                                .frame(width: 55, height: 55)
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
                        .foregroundColor(.red)
                        .alert("Enter the name of your drawing.", isPresented: $showSaveConfirm) {
                            TextField("scene display name", text: $currentSceneDisplayName)
                            // replace action with real save functionality
                            Button("Save", action: {
                                imageViewModel.saveImage(nil)
                                savedSceneDisplayNames.append(currentSceneDisplayName)
                                } )
                            Button("Cancel", role: .cancel) {}
                        }
                        .onChange(of: showSaveConfirm) { newValue in
                            if newValue {
                                currentSceneDisplayName = "" // Reset to an empty string when the alert is shown
                            }
                        }
                        PhotoUploadView.ButtonWithIcon(systemName: "camera.fill", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
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
                    }
                    .padding()
                    .navigationBarHidden(true)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, -21)
            .navigationBarHidden(true)
            .onAppear {
                if let loadedImage = imageViewModel.loadImage() {
                    inputImage = loadedImage
                }
                return
            }
            // saved drawings pop-up (only show when showFolder is true)
            if showFolder {
                ZStack { // outer z stack for entire sheet and grey background
                    Color("AACGrey")
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
                            Text("Saved Scene Displays")
                                .font(.system(size: 40))
                                .padding()
                            
                            
                            ScrollView {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 60) {
                                    // Create a button for each category
                                    ForEach(savedSceneDisplayNames, id: \.self) { name in
                                        SceneDisplayTile(labelText: name)
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
            }
        }
    }
}
    


struct TextFieldsView: View {
    @State private var textValues: [String] = Array(repeating: "", count: 4)
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        List {
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    if #available(iOS 16.0, *) {
                        TextField("Text", text: $textValues[index], axis: .vertical)
                            .font(.title)
                            .padding(15)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                            .padding(10)
                    } else {
                        TextField("Text", text: $textValues[index])
                            .font(.title)
                            .frame(height: 40)
                            .padding(15)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                            .padding(5)
                    }
                    
                    Button {
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                            Ellipse()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                        }
                        
                    }
                    Button(action: {
                        speakText(text: textValues[index])
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                            
                            Ellipse()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listRowBackground(Color.white)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.white)
    }
    func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}

// tile for saved scene display
struct SceneDisplayTile: View {
    let labelText: String
    let image: String = "photo.circle" // should be replaced with preview of image
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

struct SceneDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SceneDisplay()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
