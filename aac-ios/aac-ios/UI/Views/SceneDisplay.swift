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

struct SceneDisplay: View {
    @State var galleryClicked = false
    @State var cameraClicked = false
    var body: some View {
        HStack() {
            PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
            VStack {
                TextFieldsView()
                Divider()
                HStack(spacing: 50) {
                    PhotoUploadView.ButtonWithIcon(systemName: "camera", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
                    PhotoUploadView.ButtonWithIcon(systemName: "photo", galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
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
    @State var image: Image?
    @State var inputImage: UIImage?
    @State private var isShowingImagePicker = false

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
        //need to make it do a different thing based on whether camera or gallery clicked
        @Binding var galleryClicked: Bool
        @Binding var cameraClicked: Bool
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
                    .foregroundColor(.black)
                    .frame(width: 45, height: 40, alignment: .center)
                    .padding(7)
            }
            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
            .border(Color.black, width: 1)
            .padding(.bottom, 25)
            .padding(.top, 25)

        }
    }
}

struct TextFieldsView: View {
    @State private var textValues: [String] = Array(repeating: "", count: 4)
    
    var body: some View {
        List {
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    if #available(iOS 16.0, *) {
                        TextField("Text", text: $textValues[index], axis: .vertical)
                            .font(.title)
                            .padding(.top, 5)
                            .padding(.bottom, 50)
                            .frame(height: 90)
                            .padding(15)
                            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                            .border(Color.black, width: 1)
                            .padding(10)
                    } else {
                        TextField("Text", text: $textValues[index])
                            .font(.title)
                            .frame(height: 40)
                            .padding(15)
                            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                            .border(Color.black, width: 1)
                            .padding(5)
                    }
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
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
