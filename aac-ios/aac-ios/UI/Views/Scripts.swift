import SwiftUI
import Foundation
import AVFoundation

struct Scripts: View {
    // Define your categories here
    @State private var categories = ["Health", "Food", "Activities", "TV"]
    
    // State variable to control which view is currently being shown
    @State private var showScriptText = false
    @State private var showError = false

    // State variable to hold the new category name
    @State private var newCategoryName = ""

    var body: some View {
        // Create a grid layout with 3 columns
        let columns = Array(repeating: GridItem(.fixed(200), spacing: 60), count: 4)

        VStack {
            HStack(spacing: 15) {
                TextField("New Category", text: $newCategoryName)
                    .font(.system(size:30))
                    .padding()
                    .background(Color.white)
                    .frame(width: 900, height: 60)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))

                Button(action: {
                    // When the button is clicked, add the new category
                    if !newCategoryName.isEmpty {
                        if !categories.contains(newCategoryName) {
                            self.categories.append(newCategoryName)
                            self.newCategoryName = ""
                        } else {
                            showError = true
                        }
                    }
                }) {
                    Text("Add")
                        .frame(width: 40, height: 30)
                        .font(.system(size:20))
                        .padding()
                        .background(Color("AACBlue"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))

                }
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 60) {
                    // Create a button for each category
                    ForEach(categories, id: \.self) { category in
                        ScriptsCategoryButton(labelText: category, image: "circle", available: false, imageColor: "red", showScriptText: $showScriptText)
                    }
                }
                .padding()
            }
            .padding(15)
            .sheet(isPresented: $showScriptText) {
                // This is the view that will be shown when showScriptText is true
                ScriptTextScreen(showScriptText: $showScriptText)
            }
            .sheet(isPresented: $showError) {
                ErrorScreen(showError: $showError)
            }
        } //end of vstck
    }
}

struct ScriptTextScreen: View {
    @Binding var showScriptText: Bool
    @Environment(\.presentationMode) var presentationMode

    @State private var textValues: [String] = Array(repeating: "", count: 4)
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack {
            ForEach(0..<textValues.count, id: \.self) { index in
                HStack {
                    TextField("Text", text: $textValues[index], axis: .vertical)
                        .font(.title2)
                        .frame(width: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))

                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CustomGray")))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))

                    Image(systemName: "speaker.wave.2.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.black) // Change the color to black
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CustomGray")))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        .onTapGesture {
                            speakText(text: textValues[index])
                        }
                }
            }
        }
        .padding(30)
        VStack {
            Button(action: {
                self.showScriptText = false
            }) {
                Text("Go Back")
                    .font(.system(size:20)) // Increase the font size
                    .frame(width: 100, height: 50) // Set a specific width and height
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    func speakText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }
}

struct ScriptsCategoryButton: View {
    let labelText: String
    let image: String
    var available: Bool = true
    var imageColor: String = "AACBlack"
    @Binding var showScriptText: Bool // Binding to toggle showScriptText
    
    var body: some View {
        Button(action: {
            showScriptText = true // Toggle showScriptText to true when the button is clicked
        }) {
            VStack {
                Spacer()
                    .frame(height: 10)
                
                if available {
                    HStack {
                        Spacer()
                            .frame(width: 135)
                        Image(systemName: "chevron.right.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
                }
                
                Spacer()
                    .frame(height: 5)
                
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(imageColor))
                
                Spacer()
                    .frame(height: 10)
                
                Text(labelText)
                    .font(.system(size: 28))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                    .frame(height: 10)
            }
            .frame(width: 160, height: 160)
            .padding()
            .accentColor(Color.black)
            .cornerRadius(10.0)
            .background(Color("AACGrey"))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
        }
    }
}

struct ErrorScreen: View {
    @Binding var showError: Bool
    
    var body: some View {
        Text("That category already exists!")
            .font(.title)
            .padding()
        Button(action: {
            showError = false
        }) {
            Text("Close")
                .font(.system(size:20)) // Increase the font size
                .frame(width: 100, height: 50) // Set a specific width and height
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .font(.title)
    }
}

struct ScriptsPreview: PreviewProvider {
    static var previews: some View {
        Scripts()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
