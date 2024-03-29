//
//  AddButton.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct AddButton: View {
    let action: ()->Void
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "plus.app")
                    .font(.system(size: 70))
            }
                .frame(width: 150, height: 70)
                .font(.title)
                .background(Color.gray.opacity(0.0))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton {
            print("Hello")
        }
    }
}
