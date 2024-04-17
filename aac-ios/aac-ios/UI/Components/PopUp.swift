import SwiftUI
import symbolpicker

struct PopUp: View {
    @State private var selectedSymbol: String = "smiley"

    @State private var icon = "star.fill"
    @State private var isPresented = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Select a symbol") {
                    isPresented.toggle()
                }

                Image(systemName: icon)

                .sheet(isPresented: $isPresented, content: {
                    SymbolsPicker(selection: $icon)
                })

            }
        }
    }
}

struct PopUp_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
