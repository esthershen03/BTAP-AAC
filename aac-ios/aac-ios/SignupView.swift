//
//  SignupView.swift
//  signup
//
//  Created by Joannaye on 2023/10/4.
//

import SwiftUI
import AuthenticationServices

struct SignupView: View {
    @State private var email: String = "" // by default it's empty
    @State private var username: String = "" // by default it's empty
    @State private var password: String = ""
    @StateObject private var viewModel = signupViewModel()
    var body: some View {
        VStack{
            Spacer()
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Welcome to AAC")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
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
                VStack{
                    TextField("user name", text: $username)
                        .font(.title3)
                        .padding()
                        .frame(width: 500, height: 40, alignment: .center)
                        .background(Color(.secondarySystemBackground))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .autocapitalization(.none)
                        .padding(8)
                        .padding(.vertical)
                    EntryField(sfSymbolName: "envelope", placeholder: "Email Address", prompt: viewModel.emailPrompt, field: $viewModel.email)
                        .frame(width: 500, height: 50, alignment: .center)
                    EntryField(sfSymbolName: "lock", placeholder: "Password", prompt: viewModel.passwordPrompt, field: $viewModel.password, isSecure: true)
                        .frame(width: 500, height: 70, alignment: .center)
                    //        TextField("Work email address", text: $email)
                    //                .font(.title3)
                    //                .padding()
                    //                .frame(width: 500, height: 70, alignment: .center)
                    //                .background(Color.white)
                    //                .cornerRadius(10.0)
                    //                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    //            TextField("password", text: $password)
                    //                    .font(.title3)
                    //                    .padding()
                    //                    .frame(width: 500, height: 70, alignment: .center)
                    //                    .background(Color.white)
                    //                    .cornerRadius(10.0)
                    //                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                    //                    .padding(.vertical)
                    HStack {
                        Spacer()
                        Button {
                            viewModel.signup()
                        } label: {
                            Text("Create Account")
                                .font(.title2)
                        }.foregroundColor(.black)
                            .frame(width: 250, height: 50)
                            .background(Color("AACBlue"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding()
//                            .opacity(viewModel.canSubmit ? 1 : 0.8)
//                            .disabled(!viewModel.canSubmit)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                }
            }
            VStack {
                Text("Returning User?")
                Button("Log In") {
                    
                }
                .foregroundColor(.black)
                .frame(width: 173, height: 40)
                .background(Color("AACBlue"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding()
            }
//            SignInWithAppleButton(.signIn, onRequest: { request in
//                            request.requestedScopes = [.fullName, .email]
//                        }, onCompletion: { result in
//                            switch result {
//                            case .success(let authResults):
//                                // Handle authResults
//                                print(authResults)
//                            case .failure(let error):
//                                // Handle error
//                                print(error.localizedDescription)
//                            }
//                        })
//                        .frame(height: 60) // Height for the button
//                        .padding()
        
//        HStack {
//            Spacer()
//            Text("Sign in with Google")
//                .font(.title2)
//            Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.white)
//        .cornerRadius(50.0)
//        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
//
        Spacer()
        Text("Read our Terms & Conditions.")
            .foregroundColor(.black)
            .padding()

        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
    }
}
