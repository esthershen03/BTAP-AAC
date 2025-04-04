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
    
    // Add a closure that gets called when logout is triggered
    var onLogout: () -> Void = {}

    var body: some View {
        ZStack {
            
            HStack(spacing: 10) {
                
                Button(action: {
                            selectedButton = "logout"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                selectedButton = nil
                            }
                            onLogout()
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
                                    .font(.system(size: 26))
                                    .multilineTextAlignment(.leading)
                                    
                            }.frame(width: 150, height: 80)
                                .padding()
                                .background(selectedButton == "logout" ? Color("AACGreenDark") : Color("AACGreen"))
                                .cornerRadius(10)
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "logout" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                        .buttonStyle(.plain)
                        .padding([.leading],105)
                
                Spacer(minLength: 70)
                
                
                
                VStack(spacing:0) {
                    HStack {
                        Text(autocompleteWord(text: searchText)?[0] ?? " ")
                            .padding(10)
                            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: true)
                            .frame(width: 110, height: 40)
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                changeText(fix: autocompleteWord(text: searchText)?[0] ?? "")
                            }.font(.system(size: 16))
                        Text(autocompleteWord(text: searchText)?[1] ?? " ")
                            .padding(10)
                            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: true)
                            .frame(width: 110, height: 40)
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                changeText(fix: autocompleteWord(text: searchText)?[1] ?? "")
                            }.font(.system(size: 16))
                        Text(autocompleteWord(text: searchText)?[2] ?? " ")
                            .padding(10)
                            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: true)
                            .frame(width: 110, height: 40)
                            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                changeText(fix: autocompleteWord(text: searchText)?[2] ?? "")
                            }.font(.system(size: 16))
                    } .padding(0)
                        .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    HStack {
                        TextField("Search", text: $searchText, onCommit:{
                            speakText()
                        }).font(.system(size: 24))
                            .padding(10)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 2)
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 30, height: 30)
                            Ellipse()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    speakText()
                                }
                            
                        }
                    }
                    .padding(.trailing,10)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                }.background(Color("AACGreen"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "logout" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                
                HStack(spacing: 5) { // Adjust spacing as needed
                    Button(action: {
                        let speechUtterance = AVSpeechUtterance(string: "STOP")
                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        self.speechSynthesizer.speak(speechUtterance)
                    }) {
                        HStack {
                            Image(systemName: "stop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 38, height: 38)
                            
                            Spacer()
                                .frame(width: 18)
                            
                            Text("Stop")
                                .font(.system(size: 30))
                                .multilineTextAlignment(.leading)
                        }
                            .frame(width: 150, height: 80)
                                .padding()
                                .background(selectedButton == "stop" ? Color("AACGreenDark") : Color("AACGreen"))
                                .clipShape(Ellipse())
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedButton = "stop"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        selectedButton = nil
                                    }
                                    let speechUtterance = AVSpeechUtterance(string: "Stop")
                                    speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                                    self.speechSynthesizer.speak(speechUtterance)
                                }
                    }.overlay(Ellipse().stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "stop" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                        .buttonStyle(.plain)
                        .padding([.leading],40)
                    
                    Button(action: {
                        let speechUtterance = AVSpeechUtterance(string: "HELP")
                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                        self.speechSynthesizer.speak(speechUtterance)
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 38, height: 38)
                            
                            Spacer()
                                .frame(width: 18)
                            
                            Text("Help")
                                .font(.system(size: 30))
                                .multilineTextAlignment(.leading)
                        }
                            .frame(width: 150, height: 80)
                                .padding()
                                .background(selectedButton == "help" ? Color("AACGreenDark") : Color("AACGreen"))
                                .clipShape(Ellipse())
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedButton = "help"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        selectedButton = nil
                                    }
                                    let speechUtterance = AVSpeechUtterance(string: "Help")
                                    speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                                    self.speechSynthesizer.speak(speechUtterance)
                                }
                    }.overlay(Ellipse().stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "help" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                        .buttonStyle(.plain)
                        .padding([.leading],35)
                }
                VStack {
                    Button(action: {
                                print("Yes button tapped")
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.shield")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 38, height: 38)
                                    
                                    Spacer()
                                        .frame(width: 18)
                                    
                                    Text("Yes")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.leading)
                                        
                                }.frame(width: 100, height: 25)
                                    .padding()
                                    .background(selectedButton == "yes" ? Color("AACGreenDark") : Color("AACGreen"))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedButton = "yes"
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            selectedButton = nil
                                        }
                                        let speechUtterance = AVSpeechUtterance(string: "Yes")
                                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                                        self.speechSynthesizer.speak(speechUtterance)
                                    }
                                
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "yes" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                            .buttonStyle(.plain)
                            .padding([.leading],20)
                    
                    Button(action: {
                                print("No button tapped")
                            }) {
                                HStack {
                                    Image(systemName: "xmark.shield")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 38, height: 38)
                                    
                                    Spacer()
                                        .frame(width: 18)
                                    
                                    Text("No")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.leading)
                                        
                                }.frame(width: 100, height: 25)
                                    .padding()
                                    .background(selectedButton == "no" ? Color("AACGreenDark") : Color("AACGreen"))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedButton = "no"
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            selectedButton = nil
                                        }
                                        let speechUtterance = AVSpeechUtterance(string: "No")
                                        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                                        self.speechSynthesizer.speak(speechUtterance)
                                    }
                                
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)        .shadow(color: Color.black, radius: selectedButton == "yes" ? CGFloat (15) : CGFloat(25), x: 0, y: 20))
                            .buttonStyle(.plain)
                            .padding([.leading],20)

                    
                }
                .padding([.leading],20)
                .padding([.trailing],80)
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
    func autocompleteWord(text: String) -> [String]? {
        let words = text.components(separatedBy: " ")
        let str = (words.count >= 0) ? words[words.count - 1] : "default"
        let rangeForEndOfStr = NSMakeRange(0, str.utf16.count)     // You had inverted parameters ; could also use NSRange(0..<str.utf16.count)
        let spellChecker = UITextChecker()
        let completions = spellChecker.completions(forPartialWordRange: rangeForEndOfStr, in: str, language: "en_US")
        print(completions ?? "")
        var phrase: [String] = ["","",""]
        if let unwrapped = completions {
            var counting = 0
            for word in unwrapped {
                if (!(word.contains("'"))) {
                    phrase.insert(word, at: 0)
                    counting += 1
                }
                if (counting >= 3) {
                    break
                }
            }
        }
        return(phrase)
    }
    func changeText(fix: String) {
        var words = searchText.components(separatedBy: " ")
        print(words)
        words[words.count - 1] = fix
        print(words)
        searchText = words.joined(separator: " ")
    }
}



struct HorizontalNavBar_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalNavBar().previewInterfaceOrientation(.landscapeLeft)
    }
}
