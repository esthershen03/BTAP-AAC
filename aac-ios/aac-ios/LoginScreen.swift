//
//  Login Screen.swift
//  aac-ios
//
//  Created by Asma on 10/10/23.
//

//
//  Login.swift
//  AAC Application
//
//  Created by Shreya Puvvula on 10/2/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false
    @State private var forgotUserColor: Color = .black
    @State private var forgotPassColor: Color = .black

    
    var body: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Welcome to AAC")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 600, height: 400)
                    .foregroundColor(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                VStack {
                    VStack{
                        HStack {
                            SignInWithAppleButton(.signIn, onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            }, onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    // Handle authResults
                                    print(authResults)
                                case .failure(let error):
                                    // Handle error
                                    print(error.localizedDescription)
                                }
                            })
                            .frame(height: 48) // Height for the button
                            .frame(maxWidth: 250)
                            .cornerRadius(10)
                            .padding()
                            Button(action: {}) {
                                Image("Google-Logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                Text("Sign in with Google")
                            }
                            .foregroundColor(.black)
                            .frame(width: 250, height: 48)
                            .background(Color("AACGreen"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding()
                        }
                        TextField("Username", text: $username)
                            .padding()
                            .frame(width: 550, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(wrongUsername))
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 550, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(wrongPassword))
                        
                    }
                    .padding()
                    Button("Login") {
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.black)
                    .frame(width: 250, height: 50)
                    .background(Color("AACBlue"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    
                    HStack {
                        Text("Forgot username?")
                            .foregroundColor(forgotUserColor)
                            .onTapGesture {
                                forgotUserColor = Color.blue
                            }
                        
                        Text("Forgot password?")
                            .foregroundColor(forgotPassColor)
                            .onTapGesture {
                                forgotPassColor = Color.blue
                            }
                    }
                    
                    NavigationLink(destination: Text("You are logged in @\(username)"), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
            }
            VStack {
                Text("New User?")
                Button("Sign Up") {
                    
                }
                .foregroundColor(.black)
                .frame(width: 173, height: 40)
                .background(Color("AACBlue"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
    }
    
    func authenticateUser(username: String, password: String) {
        if username.lowercased() == "Spongebob" {
            wrongUsername = 0
            if password.lowercased() == "qwerty" {
                wrongPassword = 0
                showingLoginScreen = true
            } else {
                wrongPassword = 2
            }
        } else {
            wrongUsername = 2
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
