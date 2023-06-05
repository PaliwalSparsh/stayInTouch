import SwiftUI
import ContactsUI
import CoreData

struct ContactCard: View {
    var contact: Contact
    var cta: (_ contact: Contact) -> Void
    var ctaSymbol: String

    var body: some View {
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
            Button(action: { cta(contact) }, label: {
                Image(systemName: ctaSymbol)
                    .foregroundColor(.green)
                    .frame(maxWidth: 40, maxHeight: 40)
                    .background(Circle().fill(Color(.secondarySystemBackground)))
            })
        }
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
            var wasLastCalledWithinCurrentCallFrequency = false
            var wasLastAttemptedWithinCurrentCallFrequency = false
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

            if firstDayOfTheCallFrequency < (contact.lastCalled ?? Date()) { // wasLastCalledWithinCurrentCallFrequency, NOTE - this if else is dependent on order in which it's written.
                callVerified.append(contact)
            } else if firstDayOfTheCallFrequency < (contact.lastAttempted ?? Date()) { // wasLastAttemptedWithinCurrentCallFrequency
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
        return ZStack {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("To be called")
                    ForEach(callLists.callsScheduled) { contact in
                        ContactCard(contact: contact, cta: makeCall, ctaSymbol: "phone.fill")
                    }
                    Text("To be verified")
                    ForEach(callLists.callsAttempted) { contact in
                        ContactCard(contact: contact, cta: verifyCall, ctaSymbol: "checkmark")
                    }
                }
                .navigationTitle("Call List")
            }

            if isFirstTimeUser {
                WelcomeView()
            }
        }
    }

    func makeCall(contact: Contact) {
        if let url = URL(string: "tel://\(contact.phone!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
