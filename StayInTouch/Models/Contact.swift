//
//  Person.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/23/23.
//

import Foundation
import Contacts

enum CallStatus {
    case didTalk, didNotTalk, notReported
}

class Contact: Identifiable {
    var id = UUID()
    var details: CNContact
    var callLog: [Call] = []
    init(details: CNContact) {
        self.details = details
    }
    
    func addCallToLog(call: Call) {
        callLog.append(call)
    }
}

class Call {
    var id: UUID = UUID()
    var time: NSDate
    var status: CallStatus = .notReported
    
    init(time: NSDate) {
        self.time = time
    }
}
