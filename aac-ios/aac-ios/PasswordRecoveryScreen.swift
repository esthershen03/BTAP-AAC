//
//  PasswordRecoveryScreen.swift
//  aac-ios
//
//  Created by Dahyun on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct PasswordRecoveryScreen: View {
    @State private var email = ""
    @State private var message = ""
    @State private var isSuccess = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 150)

                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: geometry.size.width * 0.8, height: 300) // Scaled width
                        .foregroundColor(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                    
                    VStack {
                        Text("Enter your email to reset your password")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: geometry.size.width * 0.75, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)

                        Button("Send Reset Link") {
                            sendPasswordReset()
                        }
                        .foregroundColor(.black)
                        .frame(width: 250, height: 50)
                        .background(Color("AACBlue"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.top, 10)

                        Text(message)
                            .foregroundColor(isSuccess ? .green : .red)
   
                        Button("Back to Login") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.black)
                        .frame(width: 250, height: 50)
                        .background(Color("AACGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }

    func sendPasswordReset() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Please enter a valid email."
            isSuccess = false
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                message = "Error: \(error.localizedDescription)"
                isSuccess = false
            } else {
                message = "Password reset email sent!"
                isSuccess = true
            }
        }
    }
}

#Preview {
    PasswordRecoveryScreen()
}
