//
//  StatsView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/22/23.
//

import SwiftUI
import ContactsUI
import CoreData

struct ImportedContactsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Contact>
    
    @State var showPicker = false
    
    
    var body: some View {
        ZStack {
            ContactPicker(
                showPicker: $showPicker,
                onSelectContacts: { selectedContacts in
                    for selectedContact in selectedContacts {
                        addContact(contact: selectedContact)
                    }
                }
            )
            
            NavigationView {
                List {
                    Button(action: {
                        self.showPicker.toggle()
                    }) {
                        Text("\(Image(systemName: "plus")) Add Contacts")
                    }
                    
                    ForEach(contacts) { contact in
                        HStack {
                            VStack {
                                Text(contact.name ?? "").font(.subheadline)
                                Text(contact.phone ?? "Not found")
                            }
                            Spacer()
                            Button("Delete") {
                                deleteContact(contact: contact)
                            }
                        }
                    }
                }
                .navigationTitle("Imported Contacts")
            }
        }
    }
    private func addContact(contact: CNContact) {
        withAnimation {
            let newContact = Contact(context: viewContext)
            newContact.id = contact.identifier
            newContact.name = contact.givenName
            newContact.phone = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo), and \(nsError.localizedDescription)")
            }
        }
    }
    
    private func deleteContact(contact: NSManagedObject) {
        withAnimation {
            viewContext.delete(contact)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ImportedContactsView().preferredColorScheme(.dark)
    }
}
