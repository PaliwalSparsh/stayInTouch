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
        var callAttempted: [Contact] = []
        for contact in contacts {
            switch contact.callFrequency {
                case "W":
                
                    let wasLastCalledBeforeCurrentWeek = getFirstDayOfTheWeek() > (contact.lastCalled ?? Date())

                    if wasLastCalledBeforeCurrentWeek {
                        callList.append(contact)
                    }
                
                    if !wasLastCalledBeforeCurrentWeek && contact.callStatus == 1 {
                        callAttempted.append(contact)
                    }

                case "M":
                    let wasLastCalledBeforeCurrentMonth = getFirstDayOfTheMonth() > (contact.lastCalled ?? Date())

                    if wasLastCalledBeforeCurrentMonth {
                        callList.append(contact)
                    } else {
                        if contact.callStatus == 1 {
                            callAttempted.append(contact)
                        }
                    }
                case "Y":
                    let wasLastCalledBeforeCurrentYear = getFirstDayOfTheYear() > (contact.lastCalled ?? Date())

                    if wasLastCalledBeforeCurrentYear {
                        callList.append(contact)
                    } else {
                        if contact.callStatus == 1 {
                            callAttempted.append(contact)
                        }
                    }
                default:
                    print("Not a default option")
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
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .padding(.trailing, 4)
                            VStack(alignment: .leading) {
                                Text(contact.name ?? "None")
                                if contact.lastCalled! == getMinDate() {
                                    Text("Call them for the first time")
                                        .foregroundStyle(Color(.secondaryLabel))

                                } else {
                                    Text("Last called" + (contact.lastCalled ?? Date.now)
                                        .formatted(date: .abbreviated, time: .omitted))
                                    .foregroundStyle(Color(.secondaryLabel))
                                }
                            }
                            Spacer()
                            Button(action: {
                                makeCall(contact: contact)
                                putCallVerified(contact: contact)
                            }, label: {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .background(Circle().fill(Color(.secondarySystemBackground)))
                            })
                        }
                    }
                }.navigationTitle("Call List")
            }.onAppear {
                for contact in contacts {
                    switch contact.callFrequency {
                        case "W":
                            if getFirstDayOfTheWeek() > (contact.lastCalled ?? Date()) {
                                refreshCallStatusForContact(contact: contact)
                            }
                        case "M":
                            if getFirstDayOfTheMonth() > (contact.lastCalled ?? Date()) {
                                refreshCallStatusForContact(contact: contact)
                            }
                        case "Y":
                            if getFirstDayOfTheYear() > (contact.lastCalled ?? Date()) {
                                refreshCallStatusForContact(contact: contact)
                            }
                        default:
                            print("Not a default option")
                    }
                }
            }
            if isFirstTimeUser {
                WelcomeView()
            }
        }
    }
    
    func refreshCallStatusForContact(contact: Contact) {
        contact.callStatus = 0

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                       " and \(nsError.localizedDescription)")
        }
    }

    func makeCall(contact: Contact) {
        if let url = URL(string: "tel://\(contact.phone!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func putCallVerified(contact: Contact) {
        contact.lastCalled = Date.now

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                       " and \(nsError.localizedDescription)")
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        CallListView()
    }
}
