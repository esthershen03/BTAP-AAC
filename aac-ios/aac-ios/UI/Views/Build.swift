//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct Build: View {
    var body: some View {
        VStack() {
            Text("Build Screen")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.red, width: 10)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
    }
}

struct Build_Previews: PreviewProvider {
    static var previews: some View {
        Build()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
