//
//  SceneDisplay.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct SceneDisplay: View {
    var body: some View {
        HStack() {
            PhotoUploadView()
            Divider()
            VStack {
                TextFieldsView()
                Divider()
                HStack(spacing: 40) {
                    ButtonWithIcon(systemName: "camera")
                    //change to gallery icon
                    ButtonWithIcon(systemName: "rectangle")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
    }
}
    
struct PhotoUploadView: View {
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
