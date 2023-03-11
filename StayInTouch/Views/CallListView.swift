
import SwiftUI
import CoreData

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle").font(.system(size: 20))

                configuration.label
            }
        })
    }
}

struct CallListView: View {
    // We listen for when the value of isFirstTimeUser Changes
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @State var isOn = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List(1...4, id: \.self) { index in
                    HStack {
                        // Checkbox
                        Toggle(isOn: $isOn) {
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())

                        Image(systemName: "person.circle.fill").font(.system(size: 40)).padding(.trailing, 4)
                        VStack(alignment: .leading) {
                            Text("Sparsh")
                            Text("Last called 6 days ago").foregroundStyle(Color(.secondaryLabel))
                        }
                        Spacer()
                        Button(action: {
                            print("Calling Sparsh")
                        }) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                                .frame(maxWidth: 40, maxHeight: 40)
                                .background(Circle().fill(Color(.secondarySystemBackground)))
                        }
                    }
                }.navigationTitle("Call List")
            }
            if (isFirstTimeUser) {
                WelcomeView()
            }
        }
    }
}



struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        CallListView()
    }
}
