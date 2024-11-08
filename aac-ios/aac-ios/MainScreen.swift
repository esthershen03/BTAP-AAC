//
//  ContentView.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 8/25/23.
//

import SwiftUI


struct MainScreen: View {
    @State private var selectedButton: String? = nil
    @State private var navigateToLogin = false

    let persistenceController = PersistenceController.shared

    
    var body: some View {
        NavigationView(){
            VStack() {
                HorizontalNavBar(onLogout: {
                    print("logging out")
                    navigateToLogin = true // Trigger navigation to the login screen
                })
                NavigationLink(destination: LoginScreen(), isActive: $navigateToLogin) {
                    EmptyView()
                }
                
                NavigationView() {
                    
                    VStack(spacing:40) {
                        NavigationLink(destination: SceneDisplay(), tag: "Images", selection: $selectedButton) {
                            NavigationButton(labelText: "Scene Display", image: "photo.circle", selected: selectedButton == "Images")
                        }.buttonStyle(.plain)
                        
                        
                        NavigationLink(destination: WhiteBoard(), tag: "WhiteBoard", selection: $selectedButton) {
                            NavigationButton(labelText: "White Board", image: "square.and.pencil", selected: selectedButton == "WhiteBoard")
                        }.buttonStyle(.plain)
                        
                        
                        NavigationLink(destination: Build(), tag: "Build", selection: $selectedButton) {
                            NavigationButton(labelText: "Build", image: "hammer", selected: selectedButton == "Build")
                        }.buttonStyle(.plain)
                        
                        
                        NavigationLink(destination: Scripts(), tag: "Scripts", selection: $selectedButton) {
                            NavigationButton(labelText: "Scripts", image: "scroll", selected: selectedButton == "Scripts")
                        }.buttonStyle(.plain)
                        
                        
                        NavigationLink(destination: RatingScaleGrid(), tag: "RatingScale", selection: $selectedButton) {
                            NavigationButton(labelText: "Rating Scale", image: "face.smiling", selected: selectedButton == "RatingScale")
                        }.buttonStyle(.plain)
                    }
                    .navigationBarHidden(true)
                    .padding(.top, 22)
                }
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
        } .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .environment(\.managedObjectContext, persistenceController.context)
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
