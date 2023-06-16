import SwiftUI
import ContactsUI
import CoreData

func contactCardView(contact: Contact, @ViewBuilder content: () -> some View) -> some View {
    LabeledContent {
        content()
    } label: {
        Text(contact.name ?? "None").font(.system(.body, design: .rounded)).bold()
        if contact.lastCalled! == getMinDate() {
            Text("Call them for the first time")
                .foregroundStyle(Color(.secondaryLabel))
        } else {
            Text("Last called" + (contact.lastCalled ?? Date.now)
                .formatted(date: .abbreviated, time: .omitted))
            .foregroundStyle(Color(.secondaryLabel))
        }
    }
    .padding(16)
    .background {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground))
    }
}

struct CallListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // We listen for when the value of isFirstTimeUser Changes
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    private var contacts: FetchedResults<Contact>

    var callLists: (callsScheduled: [Contact], callsVerified: [Contact], callsAttempted: [Contact]) {
        var callScheduled: [Contact] = []
        var callAttempted: [Contact] = []
        var callVerified: [Contact] = []

        for contact in contacts {
            var firstDayOfTheCallFrequency = Date()

            switch contact.callFrequency {
            case "W":
                firstDayOfTheCallFrequency = getFirstDayOfTheWeek()
            case "M":
                firstDayOfTheCallFrequency = getFirstDayOfTheMonth()
            case "Y":
                firstDayOfTheCallFrequency = getFirstDayOfTheYear()
            default:
                print("Not a default option")
            }

            if firstDayOfTheCallFrequency < (contact.lastCalled ?? Date()) {
                // wasLastCalledWithinCurrentCallFrequency
                // NOTE - this if else is dependent on order in which it's written.
                callVerified.append(contact)
            } else if firstDayOfTheCallFrequency < (contact.lastAttempted ?? Date()) {
                // wasLastAttemptedWithinCurrentCallFrequency
                callAttempted.append(contact)
            } else {
                callScheduled.append(contact)
            }

        }
        return (callsScheduled: callScheduled,
                callsVerified: callVerified,
                callsAttempted: callAttempted)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("Call", systemImage: "phone.fill").bold()
                    if(!callLists.callsScheduled.isEmpty) {
                        ForEach(callLists.callsScheduled) { contact in
                            contactCardView(contact: contact, content: {
                                Menu(content: {
                                    ForEach(contact.phone!, id: \.self) { phoneNumber in
                                        Button(phoneNumber, action: {
                                            makeCall(contact: contact, phone: phoneNumber)
                                        })
                                    }
                                }, label: {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(Color(.systemGreen))
                                        .frame(maxWidth: 40, maxHeight: 40)
                                        .background(Circle().fill(Color(.tertiarySystemBackground)))
                                })
                            })
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)

                VStack(alignment: .leading) {
                    Label("Verify", systemImage: "checkmark").bold()
                    if(callLists.callsAttempted.isEmpty) {
                        Text("You are all set! No calls to be made right now.")
                            .multilineTextAlignment(.center)
                            .font(.system(.body, design: .rounded)).bold()
                            .foregroundStyle(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(callLists.callsAttempted) { contact in
                            contactCardView(contact: contact, content: {
                                    Button(action: {
                                        verifyCall(contact: contact)
                                    }, label: {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(.systemOrange))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                            .background(Circle().fill(Color(.tertiarySystemBackground)))
                                    })
                            })
                        }
                    }

                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }.padding(.horizontal, 8)

            if isFirstTimeUser {
                WelcomeView()
            }
        }
    }

    func makeCall(contact: Contact, phone: String) {
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Calling: ", phone)
        } else {
            print("Call didn't happen for: ", phone)
            return
        }

        contact.lastAttempted = Date.now
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                       " and \(nsError.localizedDescription)")
        }
    }

    func verifyCall(contact: Contact) {
        contact.lastCalled = contact.lastAttempted

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
