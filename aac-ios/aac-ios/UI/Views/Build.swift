//
//  Build.swift
//  aac-ios
//
//  Created by Sydney DeFelice on 10/4/23.
//

import SwiftUI

struct Build: View {
    private var data: [Int] = Array(1...20)
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach(data, id: \.self) { number in
                    GridTile(labelText: String(number), image: "eye")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .padding(.bottom, -21)
        .padding(.top)
        .navigationBarHidden(true)
    }
}

struct Build_Previews: PreviewProvider {
    static var previews: some View {
        Build()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
