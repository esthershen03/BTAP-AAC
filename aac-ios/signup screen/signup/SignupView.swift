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
    var body: some View {
        VStack{
            Spacer()
            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
        TextField("Work email address", text: $email)
                .font(.title3)
                .padding()
                .frame(width: 500, height: 70, alignment: .center)
                .background(Color.white)
                .cornerRadius(10.0)
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                .padding(.vertical)
            
            TextField("user name", text: $username)
                    .font(.title3)
                    .padding()
                    .frame(width: 500, height: 70, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                    .padding(.vertical)
            TextField("password", text: $password)
                    .font(.title3)
                    .padding()
                    .frame(width: 500, height: 70, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                    .padding(.vertical)
            HStack {
                Spacer()
                Text("Sign up")
                    .font(.title2)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(50.0)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
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
                        .frame(height: 60) // Height for the button
                        .padding()
        
        HStack {
            Spacer()
            Text("Sign in with Google")
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
            
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
