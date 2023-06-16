//
//  StatsView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/22/23.
//

import SwiftUI
import ContactsUI
import CoreData

func cardView(@ViewBuilder content: () -> some View) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)
        content()
    }
}

struct ContactsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    private var contacts: FetchedResults<Contact>

    @State var showPicker = false
    @State var showDuplicateContactAlert = false
    @State var selectedContact: CNContact?

    var body: some View {

            ZStack {
                ContactPicker(
                    showPicker: $showPicker,
                    // Always use onSelectContact, if you use onSelectContacts i.e. allow multiple
                    // selections, Search bar in Contact Picker UI disappears which is really bad UX for users.
                    onSelectContact: { contact in
                        if checkIfContactAlreadyExists(contact: contact) {
                            showDuplicateContactAlert = true
                            selectedContact = contact
                        } else {
                            addContact(contact: contact)
                        }
                    }
                )
                ScrollView {
                    ForEach(contacts) { contact in
                        LabeledContent {
                            HStack {
                                Button {
                                    putCallFrequency(contact: contact, callFrequency: "W")
                                } label: {
                                    Circle()
                                    .fill(Color(contact.callFrequency == "W" ? .blue: .tertiarySystemBackground))
                                    .overlay {
                                        Text("W").foregroundColor(Color.primary)
                                    }.frame(width:40, height: 40)
                                }

                                Button {
                                    putCallFrequency(contact: contact, callFrequency: "M")
                                } label: {
                                    Circle()
                                    .fill(Color(contact.callFrequency == "M" ? .blue: .tertiarySystemBackground))
                                    .overlay {
                                        Text("M").foregroundColor(Color.primary)
                                    }.frame(width:40, height: 40)
                                }

                                Button {
                                    putCallFrequency(contact: contact, callFrequency: "Y")
                                } label: {
                                    Circle()
                                    .fill(Color(contact.callFrequency == "Y" ? .blue: .tertiarySystemBackground))
                                    .overlay {
                                        Text("Y").foregroundColor(Color.primary)
                                    }.frame(width:40, height: 40)
                                }
                            }
                        } label: {
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
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground))
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .alert("Contact already exists. Do you want to override?", isPresented: $showDuplicateContactAlert) {
                Button("Yes", role: .destructive) {
                    addContact(contact: selectedContact!)
                    selectedContact = nil
                }
                Button("No", role: .cancel) {
                    selectedContact = nil
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        self.showPicker.toggle()
                    } label: {
                        Text("\(Image(systemName: "plus.circle.fill")) Add Contacts")
                    }.buttonStyle(.plain)
                    Spacer()
                }
            }
    }

    private func checkIfContactAlreadyExists(contact contactToCheck: CNContact) -> Bool {
        for contact in contacts where contact.id == contactToCheck.identifier {
            return true
        }
        return false
    }

    private func addContact(contact: CNContact) {
        // check if its repetitive
        let newContact = Contact(context: viewContext)
        newContact.id = contact.identifier
        newContact.name = contact.givenName
        newContact.phone = contact.phoneNumbers.map { $0.value.value(forKey: "digits") as? String ?? "" }
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
        ContactsView()
    }
}
