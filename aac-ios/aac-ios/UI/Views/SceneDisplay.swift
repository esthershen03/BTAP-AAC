//
//  SceneDisplay.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct SceneDisplay: View {
    var body: some View {
        VStack() {
            Text("Scene Display Screen")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.red, width: 10)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
    }
}

struct SceneDisplay_Previews: PreviewProvider {
    static var previews: some View {
        SceneDisplay()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
