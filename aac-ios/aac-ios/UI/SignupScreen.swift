//
//  SignupScreen.swift
//  aac-ios
//
//  Created by Smera Bhatia on 9/6/24.
//

import Foundation
import SwiftUI
import AuthenticationServices
import Firebase

struct SignupScreen: View {
    @State private var emailaddress = ""
    @State private var username = ""
    @State private var password = ""
    @State private var wrongEmail: Float = 0
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingMainScreen = false
    @State private var showingLogin = false
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
                        .frame(width: 600, height: 500)
                        .foregroundColor(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                    VStack {
                        VStack{
                            Spacer().frame(height: 10)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Please enter a valid email address.").font(.system(size: 14))
                                ZStack(alignment: .leading) {
                                    // Icon
                                    Image(systemName: "envelope")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15) // Adjust padding to fit inside the text field
                                    
                                    // TextField
                                    TextField("Email Address", text: $emailaddress)
                                        .padding()
                                        .padding(.leading, 35) // Add padding to avoid overlap with the icon
                                        .frame(height: 50) // Height only, so it fits better with the icon
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                        .border(.red, width: CGFloat(wrongEmail))
                                }
                                .frame(width: 550) // Set width for the ZStack
                                .padding(.vertical, 2)
                            }
                            Spacer().frame(height: 10)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Please enter a username of your choice.").font(.system(size: 14))
                                ZStack(alignment: .leading) {
                                    // Icon
                                    Image(systemName: "person")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15) // Adjust padding to fit inside the text field
                                    
                                    // TextField
                                    TextField("Username", text: $username)
                                        .padding()
                                        .padding(.leading, 35) // Add padding to avoid overlap with the icon
                                        .frame(height: 50) // Height only, so it fits better with the icon
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                        .border(.red, width: CGFloat(wrongUsername))
                                }
                                .frame(width: 550) // Set width for the ZStack
                                .padding(.vertical, 2)
                            }
                            Spacer().frame(height: 10)
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Please enter a password with at least 8 characters, containing at least 1 number, 1 letter, and 1 special character.")
                                    .font(.system(size: 14))
                                    .lineLimit(nil) // Allows the text to wrap to multiple lines
                                    .fixedSize(horizontal: false, vertical: true) // Ensures wrapping in vertical direction
                                    .padding(.bottom, 2)
                                
                                ZStack(alignment: .leading) {
                                    // Icon
                                    Image(systemName: "lock")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 15) // Adjust padding to fit inside the text field
                                    
                                    // TextField
                                    SecureField("Password", text: $password)
                                        .padding()
                                        .padding(.leading, 35) // Add padding to avoid overlap with the icon
                                        .frame(height: 50) // Height only, so it fits better with the icon
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                        .border(.red, width: CGFloat(wrongPassword))
                                }
                                .frame(width: 550) // Set width for the ZStack
                                .padding(.vertical, 2)
                                
                            }.frame(width: 550)
                            Spacer().frame(height: 10)
                        }
                        .padding()
                        
                        Button("Create Account") {
                            register()
                            authenticateUser(username: username, password: password, email: emailaddress)
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
                        
                        Text("Unfamiliar with our terms and conditions?")
                        
                        
                        Button("Read Our T&C") {
                            
                        }
                        .foregroundColor(.black)
                        .frame(width: 173, height: 40)
                        .background(Color("AACGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        Spacer().frame(height:20)
                    }
                    
                    
                    
                }
                
                
                VStack {
                    Text("Returning user?")
                    Button("Sign In") {
                        showingLogin = true
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
                NavigationLink(destination: LoginScreen(), isActive: $showingLogin) {
                    EmptyView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle(Text("").font(.system(size:1)), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func authenticateUser(username: String, password: String, email: String) {
        // Check if username is NOT "spongebob"
        if username.lowercased() != "spongebob" && username.count >= 1 {
            wrongUsername = 0
        } else {
            wrongUsername = 2
        }
        
        // Check if password is at least 8 characters long
        if password.count >= 8 {
            wrongPassword = 0
        } else {
            wrongPassword = 2
        }
            
        // Check if password contains at least 1 number, 1 letter, and 1 special character
        let numberRegex = ".*[0-9]+.*"
        let letterRegex = ".*[A-Za-z]+.*"
        let specialCharacterRegex = ".*[!&^%$#@()/]+.*"
        
        if NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: password),
              NSPredicate(format: "SELF MATCHES %@", letterRegex).evaluate(with: password),
           NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex).evaluate(with: password) {
            wrongPassword = 0
        } else {
            print("Password must contain at least 1 number, 1 letter, and 1 special character.")
            wrongPassword = 2
        }
        
        // Check if email contains an "@" symbol
        if email.contains("@") && email.contains(".") {
            wrongEmail = 0
        } else {
            print("Invalid email address.")
            wrongEmail = 2
        }
        
        // If all checks pass, return true
        if wrongPassword == 0 && wrongEmail == 0 && wrongUsername == 0 {
            showingMainScreen = true
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: emailaddress, password: password) { result, error in
            if error != nil {
                print("Success")
            }
        }
    }
    
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen().previewInterfaceOrientation(.landscapeLeft)
    }
}
