//
//  ContactView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 3/10/23.
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("Mom")
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        HStack (spacing: 12) {
                        Text("240-476-0453")
                            Button(action: {
                                print("Calling Sparsh")
                            }) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .background(Circle().fill(Color(.secondarySystemBackground)))
                            }
                        }
                    }.padding(.vertical, 8)
                } footer: {
                    Text("To change name and phone number go to contacts. Once finished with the change come back and again add the contacts here.")
                    
                }
                
                Section {
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Calling Frequency")) {
                        Text("Once a Week").tag(1)
                        Text("Twice a Week").tag(2)
                        Text("Thrice a Week").tag(3)
                        Text("Once a Month").tag(4)
                        Text("Twice a Month").tag(5)
                        Text("Thrice a Month").tag(6)
                        Text("Once a Quater").tag(7)
                    }

                }
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
