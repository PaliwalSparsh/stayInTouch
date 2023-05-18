
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
    @Environment(\.managedObjectContext) private var viewContext
    
    // We listen for when the value of isFirstTimeUser Changes
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Call.id, ascending: true)]) private var callList: FetchedResults<Call>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    private var contacts: FetchedResults<Contact>


    @State var isOn = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Button("Add weekly people to the call list", action: addUsersToList)
                    Button("Clear all entries from call list", action:
                            clearCallList)
                    
                    ForEach(callList) { call in
                        HStack {
                            Toggle(isOn: $isOn) {
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            
                            Image(systemName: "person.circle.fill").font(.system(size: 40)).padding(.trailing, 4)
                            VStack(alignment: .leading) {
                                Text(call.contact?.name ?? "None")
                                Text("Last called 6 days ago").foregroundStyle(Color(.secondaryLabel))
                            }
                            Spacer()
                            Button(action: {
                                print("call sparsh")
                            }) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .background(Circle().fill(Color(.secondarySystemBackground)))
                            }
                        }

                    }
                }.navigationTitle("Call List")
            }
            if (isFirstTimeUser) {
                WelcomeView()
            }
        }
    }
    
    private func clearCallList() {
        for call in callList {
            viewContext.delete(call)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo), and \(nsError.localizedDescription)")
        }
    }
    
    private func addUsersToList() {
        let weeklyContacts = contacts.filter { contact in
            contact.callFrequency == "W"
        }
        
        for weeklyContact in weeklyContacts {
            let tempCall = Call(context: viewContext)
            tempCall.id = weeklyContact.id
            tempCall.status = 0
            tempCall.contact = weeklyContact
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo), and \(nsError.localizedDescription)")
        }
    }
}



struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        CallListView()
    }
}
