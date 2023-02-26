//
//  PeopleView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/22/23.
//

import SwiftUI
import UIKit
import ContactsUI

struct PeopleView: View {
    @State var showPicker = false
    @EnvironmentObject var model:ContactModel

    var body: some View {
        ZStack {
            // This is just a dummy view to present the contact picker,
            // it won't display anything, so place this anywhere.
            // Here I have created a ZStack and placed it beneath the main view.
            ContactPicker(
                showPicker: $showPicker,
                onSelectContacts: { contacts in
                    for contactDetail in contacts {
                        model.addContacts(contacts: [Contact(details: contactDetail)])
                    }
                }
            )
            VStack {
                Button(action: {
                    self.showPicker.toggle()
                }) {
                    Text("Pick a contact")
                }
                List(model.contacts) { contact in
                    Text("Name: \(contact.details.givenName)")
                }
            }
        }
    }
    
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
