import SwiftUI
import ContactsUI
import CoreData

struct CallListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // We listen for when the value of isFirstTimeUser Changes
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    private var contacts: FetchedResults<Contact>

    var callList: [Contact] {
        var callList: [Contact] = []
        for contact in contacts {
            switch contact.callFrequency {
            case "W":
                if getFirstDayOfTheWeek() > (contact.lastCalled ?? Date()) {
                    callList.append(contact)
                }
                break
            case "M":
                if getFirstDayOfTheMonth() > (contact.lastCalled ?? Date()) {
                    callList.append(contact)
                }
                break
            case "Y":
                if getFirstDayOfTheYear() > (contact.lastCalled ?? Date()) {
                    callList.append(contact)
                }
            default:
                print("not possible case")
            }
        }
        return callList
    }

    var body: some View {

        return ZStack {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(callList) { contact in
                        HStack {
                            Image(systemName: "person.circle.fill").font(.system(size: 40)).padding(.trailing, 4)
                            VStack(alignment: .leading) {
                                Text(contact.name ?? "None")
                                if contact.lastCalled! == getMinDate() {
                                    Text("Call them for the first time")
                                        .foregroundStyle(Color(.secondaryLabel))

                                } else {
                                    Text("Last called \((contact.lastCalled ?? Date.now).formatted(date: .abbreviated, time: .omitted))").foregroundStyle(Color(.secondaryLabel))
                                }
                            }
                            Spacer()
                            Button(action: {
                                putCallVerified(contact: contact)
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
            if isFirstTimeUser {
                WelcomeView()
            }
        }
    }

    func putCallVerified(contact: Contact) {
        contact.lastCalled = Date.now

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
