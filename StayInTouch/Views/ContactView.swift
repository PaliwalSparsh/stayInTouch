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
            GeometryReader { geo in
                HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "pencil")
                }.frame(maxWidth: geo.size.width/2)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "pencil")
                }.frame(maxWidth: geo.size.width/2)
                }
            }
            
            List {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Mom")
                }
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Mom")
                }
            }
            
            Text("To change name and phone number go to contacts. Once finished with the change come back and again add the contacts here.").font(.caption)
            
            List {
                HStack {
                    Text("Calling Frequency")
                    Spacer()
                    Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
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
