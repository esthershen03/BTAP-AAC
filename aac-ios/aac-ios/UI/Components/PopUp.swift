import SwiftUI

struct PopUp: View {
    @State private var isShowingPopup = false
    var body: some View {
        VStack {
            Button("Click") {
                isShowingPopup.toggle()
            }
            .padding()
            .font(.title)
            .border(Color.blue, width: 2)
            .sheet(isPresented: $isShowingPopup) {
                PopupView(isPresented: $isShowingPopup)
            }
        }
    }
}

struct PopUp_Previews: PreviewProvider {
    static var previews: some View {
        PopUp()
    }
}

struct PopupView: View {
    @Binding var isPresented: Bool
    //tells the system that a property has read/write access to a value without ownership
    var body: some View {
        Text("Hello")
            .font(.title)
            .padding()
        Button("Close") {
            isPresented.toggle()
        }
        .font(.title)
    }
}
