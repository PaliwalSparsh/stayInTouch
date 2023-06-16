//
//  TempView.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 6/15/23.
//

import SwiftUI

struct TempView: View {
    @State private var batteryLevel = 0.4

    @State private var currentView = "Call List"
    let topLevelViews = ["Call List", "Contacts"]

    var body: some View {
        VStack {
            Form {
                LabeledContent("Custom Value") {

                }
                Picker(selection: $currentView) {
                    Text("Option 1").tag(1)
                    Text("Option 2").tag(2)
                } label: {
                    Text("Sparsh Paliwal")
                    Text("Last called years ago")
                }
            }

        GroupBox(label:
                Label("End-User Agreement", systemImage: "building.columns")
        ) {
            List {

                Gauge(value: batteryLevel) {
                    Text("%")
                }.gaugeStyle(.accessoryCircularCapacity)

                Label {
                    Text("Title \(1)")
                        .font(.headline)
                } icon: {
                    Text("Subtitle \(1)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                HStack {

                    VStack(alignment: .leading) {
                        Text("Sparsh Paliwal").font(.subheadline)
                        Text("Last called 2 days ago").font(.caption)
                    }
                    Spacer()
                    Picker(selection: $currentView, content: {
                        ForEach(topLevelViews, id: \.self) {
                            Text($0)
                        }
                    }, label: {})
                }.padding(.vertical, 8)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Sparsh Paliwal").font(.subheadline)
                        Text("Last called 2 days ago").font(.subheadline)
                    }
                    Spacer()
                    Picker(selection: $currentView, content: {
                        ForEach(topLevelViews, id: \.self) {
                            Text($0)
                        }
                    }, label: {})
                }
            }
            .listStyle(.plain)
            .listRowSeparatorTint(.none)
        }
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
