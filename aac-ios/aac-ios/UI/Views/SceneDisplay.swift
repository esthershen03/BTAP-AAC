//
//  SceneDisplay.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SceneDisplay: View {
    @State var galleryClicked = false
    @State var cameraClicked = false
    var body: some View {
        HStack() {
            PhotoUploadView(galleryClicked: $galleryClicked, cameraClicked: $cameraClicked)
            Divider()
            VStack {
                TextFieldsView()
                Divider()
                HStack(spacing: 40) {
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
    
struct PhotoUploadView: View { //includes the left rectangle
    @Binding var galleryClicked: Bool
    @Binding var cameraClicked: Bool
    @State var image: Image?
    @State var inputImage: UIImage?

    let context = CIContext()
    
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                    .border(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(30)
                Text("Image will display here")
                    .font(.title)
                    .foregroundColor(Color.gray)
                image?
                    .resizable()
                    .scaledToFit()
                    .padding(30)
            }
            //we can remove this so that clicking the image doesn't allow the user to choose new image
            .onTapGesture {
                galleryClicked = true
            }
            //makes the image picker pop up show when gallery is clicked
            .sheet(isPresented: $galleryClicked) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImageFromGallery()
            }
    }
    
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
                    .frame(width: 80, height: 70, alignment: .center)
                    .padding(20)
            }
            .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
            .border(Color.black, width: 1)
            .padding(30)
        }
    }
}

struct TextFieldsView: View {
    @State private var textValues: [String] = Array(repeating: "", count: 6)
    
    var body: some View {
        List {
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    TextField("Text", text: $textValues[index])
                        .font(.title)
                        .padding(15)
                        .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                        .border(Color.black, width: 1)
                        .padding(10)
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding(20)
    }
}

struct ButtonWithIcon: View {
    let systemName: String
    //need to make it do different thing based on whether camera or gallery clicked
    var body: some View {
        Button(action: {
            if systemName == "rectangle" {
                
            } else {
                
            }
        }) {
            Image(systemName: systemName)
                .resizable()
                .foregroundColor(.black)
                .frame(width: 80, height: 70, alignment: .center)
                .padding(20)
        }
        .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
        .border(Color.black, width: 1)
        .padding(30)
    }
}

struct SceneDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SceneDisplay()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
