//
//  WelcomeView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 3/7/23.
//

import SwiftUI


struct FeatureListItem: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: 48, maxHeight: 48)
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(title).bold()
                Text(description).foregroundStyle(Color(.secondaryLabel))
            }
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            VStack(spacing: -12) {
                Text("Welcome to ")
                Text("Remember Me!").foregroundColor(.accentColor)
            }
            .font(
                .system(size: 48, design: .rounded)
            )
            .font(Font.body.leading(.tight))
            .multilineTextAlignment(.center)
            .bold()
            .padding(.bottom, 48)
            .padding(.top, 72)
            
            VStack(alignment: .leading, spacing: 16) {
                FeatureListItem(icon: "person.crop.circle.fill.badge.plus", title: "Add you contacts", description: "Tap the Add button and search for your contacts. You can add as many as you want!")
                FeatureListItem(icon: "waveform.path.ecg.rectangle.fill", title: "Set your call frequency", description: "How often do you want to call your contacts? Choose once a week, once a month, or once a year.")
                FeatureListItem(icon: "phone.connection.fill", title: "Get a call list everyday!", description: "Everyday, we'll create a list of people you need to call based on your selected frequency.")
            }
            Spacer()
            Button(action: {}) {
                Text("Continue")
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .buttonStyle(.borderedProminent)
        }.padding(16)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
