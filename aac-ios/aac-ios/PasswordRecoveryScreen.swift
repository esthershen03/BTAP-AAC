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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Recover Password")
                .font(.largeTitle)
                .padding(.top, 40)

            TextField("Enter your email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .frame(width: 350, height: 50)

            Button("Send Reset Link") {
                sendPasswordReset()
            }
            .foregroundColor(.black)
            .frame(width: 200, height: 50)
            .background(Color("AACBlue"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            Button("Back to Login") {
                dismiss()
            }
            .foregroundColor(.black)
            .frame(width: 200, height: 50)
            .background(Color("AACGreen"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func sendPasswordReset() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "A password reset email has been sent to \(email)."
            }
            showAlert = true
        }
    }
}
