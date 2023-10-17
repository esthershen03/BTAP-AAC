//
//  WhiteBoard.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct WhiteBoard: View {
    var body: some View {
        VStack() {
            Text("White Board Screen")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.red, width: 10)
        .padding(.bottom, -21)
        .navigationBarHidden(true)
    }
}

struct WhiteBoard_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBoard()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
