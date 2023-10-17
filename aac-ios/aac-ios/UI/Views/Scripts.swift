//
//  Scripts.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct Scripts: View {
    var body: some View {
        VStack() {
            Text("Scripts Screen")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.red, width: 10)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
    }
}

struct Scripts_Previews: PreviewProvider {
    static var previews: some View {
        Scripts()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
