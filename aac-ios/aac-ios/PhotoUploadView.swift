//
//  ImageViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/4/24.
//

import Foundation
import SwiftUI
import CoreData

struct PhotoUploadView: View {
    //includes the left rectangle
    @Binding var galleryClicked: Bool
    @Binding var cameraClicked: Bool
    @Binding var imageData: Data?
    @State var image: Image?
    @Binding var inputImage: UIImage?
    var screen: String
    

    let context = CIContext()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray.withAlphaComponent(0)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
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
            if screen == "VSD" {
                if let inputImage = inputImage {
                    imageViewModel.saveImage(inputImage)
                }
            }
            if screen == "whiteboard" {
                if let inputImage = inputImage {
                    whiteboardImageViewModel.saveImage(inputImage)
                }
            }
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
                } else if systemName == "camera.fill" {
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

class VSDImageViewModel: ObservableObject {
    private let imageKey = "VSDImageData"

    func saveImage(_ image: UIImage?) {
        guard let image = image else {
            UserDefaults.standard.set(nil, forKey: imageKey)
            return
        }
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: imageKey)
        }
    }

    func loadImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: imageKey) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

class WhiteboardImageViewModel: ObservableObject {
    private let imageKey = "whiteboardImageData"

    func saveImage(_ image: UIImage?) {
        guard let image = image else {
            UserDefaults.standard.set(nil, forKey: imageKey)
            return
        }
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: imageKey)
        }
    }

    func loadImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: imageKey) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

