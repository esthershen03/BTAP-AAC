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

struct SceneDisplay: View {
        @StateObject private var viewState = ViewStateData()
        @State var galleryClicked = false
        @State var cameraClicked = false
        @State var inputImage: UIImage? = nil
    

        var body: some View {
            HStack() {
                PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData, inputImage: $inputImage)
                VStack {
                    TextFieldsView()
                    Divider()
                    HStack(spacing: 50) {
                        PhotoUploadView.ButtonWithIcon(systemName: "camera.fill", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                        PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, -21)
            .navigationBarHidden(true)
        }
}
    
struct PhotoUploadView: View {
    //includes the left rectangle
    @Binding var galleryClicked: Bool
    @Binding var cameraClicked: Bool
    @Binding var imageData: Data?
    @State var image: Image?
    @Binding var inputImage: UIImage?
    

    let context = CIContext()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray.withAlphaComponent(0)))
                .border(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(15)
                .alignmentGuide(.top) { dimensions in
                    dimensions[VerticalAlignment.top]
                }
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
        //need to make it do a different thing based on whether camera or gallery clicked
        @Binding var galleryClicked: Bool
        @Binding var cameraClicked: Bool
        @Binding var imageData: Data?
        var body: some View {
            Button(action: {
                if systemName == "photo" {
                    galleryClicked = true
                } else if systemName == "camera" {
                    cameraClicked = true
                }
            }) {
                Image(systemName: systemName)
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
        } // end of body view
    } // end of button with icon view
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
                            .background(Color(UIColor.systemGray.withAlphaComponent(0.2)))
                            .padding(10)
                    } else {
                        TextField("Text", text: $textValues[index])
                            .font(.title)
                            .frame(height: 40)
                            .padding(15)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                            .padding(5)
                    }
                    
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CustomGray")))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    Image(systemName: "speaker.wave.2.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black) // Change the color to black
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CustomGray")))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        .onTapGesture {
                            speakText(text: textValues[index])
                        }
                }
            }
        }
    }
    func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}

struct SceneDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SceneDisplay()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
