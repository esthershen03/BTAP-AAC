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
        @State var inputImage: UIImage? = nil

        var body: some View {
            
            HStack() {
                PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked, imageData: $viewState.imageData, inputImage: $inputImage, screen: "VSD")
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
            .onAppear {
                if let loadedImage = imageViewModel.loadImage() {
                    inputImage = loadedImage
                }
                return
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
