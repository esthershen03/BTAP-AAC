//
//  ContentView.swift
//  AAC Application
//
//  Created by Shreya Puvvula on 9/30/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Login()) {
                    VStack {
                        Image(systemName: "chevron.backward")
                            .font(.largeTitle)
                        Text("Login")
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                NavigationLink(destination: SceneDisplay()) {
                    VStack {
                        Image(systemName: "eye")
                            .font(.largeTitle)
                        Text("Scene Display")
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                NavigationLink(destination: WhiteBoard()) {
                    VStack {
                        Image(systemName: "pencil.and.outline")
                            .font(.largeTitle)
                        Text("White Board")
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                NavigationLink(destination: Build()) {
                    VStack {
                        Image(systemName: "note.text")
                            .font(.largeTitle)
                        Text("Build")
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                NavigationLink(destination: Script()) {
                    VStack {
                        Image(systemName: "doc.richtext")
                            .font(.largeTitle)
                        Text("Script")
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                NavigationLink(destination: AddOptions()) {
                    VStack {
                        Image(systemName: "plus.app")
                            //.font(.largeTitle)
                            .font(.system(size: 70))
                    }
                        .frame(width: 150, height: 70)
                        .font(.title)
                        .padding()
                        .background(Color.gray.opacity(0.0))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    ContentView()
}
