
import SwiftUI
import UIKit
import ContactsUI
import CoreData

struct PeopleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.name, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Contact>
    
    @State var showPicker = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // MARK: Heading People
                Text("People")
                
                Group {
                    // MARK: Check List
                    Text("Today's Call List")
                    List(1...4, id: \.self) { index in
                        HStack {
                            // Checkbox
                            Image(systemName: "crop.circle.fill")
                            VStack {
                                Text("Sparsh")
                                Text("Last called 6 days ago")
                            }
                            
                            Button(action: {
                                print("Calling Sparsh")
                            }) {
                                Image(systemName: "phone.fill").foregroundColor(.green)
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(.infinity)
                        }
                    }
                }
                
                // MARK: Imported Contacts
                Group {
                    HStack {
                        Text("Favorite Contacts")
                        Spacer()
                        Button(action: {
                            self.showPicker.toggle()
                        }) {
                            Text("\(Image(systemName: "plus")) Add Contacts")
                                .padding(.trailing, 6)
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(.infinity)
                    }
                    
                    List(contacts) { contact in
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
            }
            
            ContactPicker(
                showPicker: $showPicker,
                onSelectContacts: { selectedContacts in
                    for selectedContact in selectedContacts {
                        addContact(contact: selectedContact)
                    }
                }
            )
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

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
