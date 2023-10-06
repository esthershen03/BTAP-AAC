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
        HorizontalNavBar()
        NavigationView {
            VStack {
                
                VStack {
                    NavigationLink(destination: SceneDisplay(), tag: "Images", selection: $selectedButton) {
                        NavigationButton(labelText: "Images", image: "eye")
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == "Images"))
                    
                    NavigationLink(destination: WhiteBoard(), tag: "WhiteBoard", selection: $selectedButton) {
                        NavigationButton(labelText: "White Board", image: "hand.draw")
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == "WhiteBoard"))
                    
                    NavigationLink(destination: Build(), tag: "Build", selection: $selectedButton) {
                        NavigationButton(labelText: "Build", image: "pencil.line")
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == "Build"))
                    
                    NavigationLink(destination: Scripts(), tag: "Scripts", selection: $selectedButton) {
                        NavigationButton(labelText: "Scripts", image: "scroll")
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == "Scripts"))
                    AddButton()
                }
                .navigationBarHidden(true)
                
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(selected ? Color.blue : Color.clear)
            .cornerRadius(8)
    }
}
