//
//  ContentView.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 8/25/23.
//

import SwiftUI



struct MainScreen: View {
    @State private var selectedButton: String? = nil
    var body: some View {
        VStack() {
            HorizontalNavBar()
            NavigationView() {
                VStack {
                    Spacer()

                    NavigationLink(destination: SceneDisplay(), tag: "Images", selection: $selectedButton) {
                        NavigationButton(labelText: "Scene Display", image: "photo.circle", selected: selectedButton == "Images")
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: WhiteBoard(), tag: "WhiteBoard", selection: $selectedButton) {
                        NavigationButton(labelText: "White Board", image: "square.and.pencil", selected: selectedButton == "WhiteBoard")
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: Build(), tag: "Build", selection: $selectedButton) {
                        NavigationButton(labelText: "Build", image: "hammer", selected: selectedButton == "Build")
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: Scripts(), tag: "Scripts", selection: $selectedButton) {
                        NavigationButton(labelText: "Scripts", image: "scroll", selected: selectedButton == "Scripts")
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: RatingScaleGrid(), tag: "RatingScale", selection: $selectedButton) {
                        NavigationButton(labelText: "Rating Scale", image: "face.smiling", selected: selectedButton == "RatingScale")
                    }.buttonStyle(.plain)

                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
    }
}



struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(selected ? Color("AACBlueDark") : Color.clear)
            .cornerRadius(8)
    }
}
