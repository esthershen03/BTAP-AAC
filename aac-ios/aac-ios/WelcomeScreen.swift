//
//  ContentView.swift
//  signup
//
//  Created by Joannaye on 2023/10/4.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        WelcomeScreenView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}

struct startButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .bold()
            .foregroundColor(.white)
            .frame(width: 300, height: 70, alignment: .center)
            .background(Color.teal)
            .cornerRadius(20)
            .padding()
    }
}

struct WelcomeScreenView: View{
    var body: some View{
        NavigationView {
            VStack{
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 500, height: 500)
                Spacer()
                startButton(title: "Get Started")
                
                NavigationLink(
                    destination: SignupView().navigationBarHidden(true),
                    label: {
                        Text("Sign Up")
                            .font(.title3)
                            .bold()
                            .frame(width: 300, height: 70, alignment: .center)
                            .foregroundColor(Color.teal)
                            .border(.black)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                    }).navigationBarHidden(true)
                Spacer()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
