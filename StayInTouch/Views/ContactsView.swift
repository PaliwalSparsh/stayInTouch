//
//  StatsView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/22/23.
//

import SwiftUI
import ContactsUI
import CoreData

struct ContactsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    private var contacts: FetchedResults<Contact>

    @State var showPicker = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            ContactPicker(
                showPicker: $showPicker,
                // Always use onSelectContact, if you use onSelectContacts i.e. allow multiple
                // selections, Search bar in Contact Picker UI disappears which is really bad UX for users.
                onSelectContact: { selectedContact in
                    addContact(contact: selectedContact)
                }
            )

            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        self.showPicker.toggle()
                    }, label: {
                        Text("\(Image(systemName: "plus")) Add Contacts")
                    })

                    ForEach(contacts) { contact in
                        HStack {
                            Text(contact.name ?? "").font(.subheadline)
                            Spacer()
                            Button("W") {
                                putCallFrequency(contact: contact, callFrequency: "W")
                            }.background {
                                Color(contact.callFrequency == "W" ? .yellow: .systemBackground)
                            }
                            Button("M") {
                                putCallFrequency(contact: contact, callFrequency: "M")
                            }.background {
                                Color(contact.callFrequency == "M" ? .yellow: .systemBackground)
                            }
                            Button("Y") {
                                putCallFrequency(contact: contact, callFrequency: "Y")
                            }.background {
                                Color(contact.callFrequency == "Y" ? .yellow: .systemBackground)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .navigationTitle("My People")
            }
        }
    }

    private func addContact(contact: CNContact) {
        print(contact)
        withAnimation {
            let newContact = Contact(context: viewContext)
            newContact.id = contact.identifier
            newContact.name = contact.givenName
            newContact.phone = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String
            newContact.lastCalled = getMinDate()
            newContact.lastAttempted = getMinDate()
            newContact.callFrequency = "W"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                           " and \(nsError.localizedDescription)")
            }
        }
    }

    private func putCallFrequency(contact: Contact, callFrequency: String) {
        contact.callFrequency = callFrequency

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                       " and \(nsError.localizedDescription)")
        }
    }

    private func deleteContact(contact: NSManagedObject) {
        withAnimation {
            viewContext.delete(contact)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)," +
                           " and \(nsError.localizedDescription)")
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView().preferredColorScheme(.dark)
    }
}
