//
//  HorizontalNavBar.swift
//  aac-ios
//
//  Created by Sravya Paspunoori on 10/4/23.
//

import Foundation
import SwiftUI
import AVFoundation


struct HorizontalNavBar: View {
    @State private var searchText = ""
    @State private var selectedButton: String? = nil
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                
                Button(action: {
                            print("Logout button tapped")
                        }) {
                            HStack {
                                Image(systemName: "arrow.turn.up.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 38, height: 38)
                                
                                Spacer()
                                    .frame(width: 18)
                                
                                Text("Log Out")
                                    .font(.system(size: 24))
                                    .multilineTextAlignment(.leading)
                                    
                            }.frame(width: 150, height: 80)
                                .padding()
                                .background(selectedButton == "logout" ? Color("AACGreenDark") : Color("AACGreen"))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedButton = "logout"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        selectedButton = nil
                                    }
                                }
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "logout" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                        .buttonStyle(.plain)
                        .padding([.leading],50)
                
                Spacer(minLength: 100)
                
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        speakText()
                    }
                
                VStack {
                    TextField("Search", text: $searchText, onCommit:{
                        speakText()
                    })
                        .padding(10)
                        .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                }
                
                HStack(spacing: 20) { // Adjust spacing as needed
                    Button(action: {
                        let speechUtterance = AVSpeechUtterance(string: "STOP")
                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        self.speechSynthesizer.speak(speechUtterance)
                    }) {
                        Text("STOP")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .frame(width:100, height:100)
                        
                            .padding()
                            .background(Circle().fill(Color(UIColor.systemGray.withAlphaComponent(0.4))))
                        
                    }
                    
                    Button(action: {
                        let speechUtterance = AVSpeechUtterance(string: "HELP")
                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        self.speechSynthesizer.speak(speechUtterance)
                    }) {
                        Text("HELP")
                            .font(.system(size:30))
                            .foregroundColor(.black)
                            .frame(width:100, height:100)
                        
                            .padding()
                            .background(Circle().fill(Color(UIColor.systemGray.withAlphaComponent(0.4))))
                    }
                    
                }
                
                VStack {
                    HStack{
                        Button(action: {
                            let speechUtterance = AVSpeechUtterance(string: "YES")
                            speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                            self.speechSynthesizer.speak(speechUtterance)
                        }) {
                            Text("YES")
                                .font(.system(size: 20))
                            
                                .padding()
                                .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .frame(width: 100, height: 31)
                        .padding(.bottom,30)
                        
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 24, height:24)
                    }
                    HStack{
                        Button(action: {
                            let speechUtterance = AVSpeechUtterance(string: "NO")
                            speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                            self.speechSynthesizer.speak(speechUtterance)
                        }) {
                            Text("NO")
                                .font(.system(size: 20))
                            
                                .padding()
                                .background(Color(UIColor.systemGray.withAlphaComponent(0.4)))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .frame(width: 100, height: 31)
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 24, height:24)
                    }
                    
                    
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: Alignment.trailing)
    }
    func speakText() {
        let speechUtterance = AVSpeechUtterance(string: searchText)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}



struct HorizontalNavBar_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalNavBar().previewInterfaceOrientation(.landscapeLeft)
    }
}
