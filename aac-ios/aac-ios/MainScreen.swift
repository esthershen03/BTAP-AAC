//
//  ContentView.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 8/25/23.
//

import SwiftUI



struct MainScreen: View {
    var body: some View {
        HorizontalNavBar()
        NavigationView {
            VStack {
                
                VStack {
                    NavigationLink(destination: SceneDisplay()) {
                        NavigationButton(labelText: "Images",image: "eye")
                    }
                    NavigationLink(destination: WhiteBoard()) {
                        NavigationButton(labelText: "White Board", image: "hand.draw")
                    }
                    NavigationLink(destination: Build()) {
                        NavigationButton(labelText: "Build", image: "pencil.line")
                    }
                    NavigationLink(destination: Scripts()) {
                        NavigationButton(labelText: "Scripts", image: "scroll")
                    }
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
