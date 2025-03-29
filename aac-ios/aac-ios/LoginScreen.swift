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
import Firebase
import FirebaseAuth

struct LoginScreen: View {
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingMainScreen = false
    @State private var showingRecoveryScreen = false
    @State private var showingSignup = false
    @State private var forgotUserColor: Color = .black
    @State private var forgotPassColor: Color = .black

    
    var body: some View {
        NavigationView{
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
                        .frame(width: 600, height: 425)
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
                                        .frame(width: 25, height: 25)
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
                            TextField("Email", text: $emailAddress)
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
                        
                        Button("Sign In") {
                            Login()
                        }
                        .foregroundColor(.black)
                        .frame(width: 250, height: 50)
                        .background(Color("AACBlue"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(5)
                        
                        
                        NavigationLink(destination: MainScreen(), isActive: $showingMainScreen) {
                            EmptyView()
                        }
                        
                        Spacer().frame(height:30)
            
                        Text("Forgot password?")
                                
        
                        Button("Recover Password") {
                            showingRecoveryScreen = true
                        }
                        .foregroundColor(.black)
                        .frame(width: 173, height: 40)
                        .background(Color("AACGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        NavigationLink(destination: PasswordRecoveryScreen(), isActive: $showingRecoveryScreen) {
                                    EmptyView()
                                }
                        Spacer().frame(height:20)
                    }
                   

                    
                    }
                

                VStack {
                    Text("New user?")
                    Button("Sign Up") {
                        showingSignup = true
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
                NavigationLink(destination: SignupScreen(), isActive: $showingSignup) {
                    EmptyView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func authenticateUser(username: String, password: String) {
            if username.lowercased() == "spongebob" {
                wrongUsername = 0
                if password.lowercased() == "qwerty" {
                    wrongPassword = 0
                    // Navigate to main screen only on successful login
                    showingMainScreen = true
                    print("worked!")
                } else {
                    wrongPassword = 2
                }
            } else {
                wrongUsername = 2
            }
        }
    
    func Login() {
        // Check if fields are empty
        guard !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            // Handle empty fields, e.g., show an alert or change the UI
            print("Email or Password cannot be empty.")
            return
        }

        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                // Handle the error (e.g., show an alert)
                print("Login failed: \(error.localizedDescription)")
            } else {
                // Successfully logged in
                showingMainScreen = true
                print("Login successful!")
            }
        }
    }


    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen().previewInterfaceOrientation(.landscapeLeft)
    }
}
