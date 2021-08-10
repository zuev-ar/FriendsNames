//
//  EditScreen.swift
//  FriendsNames
//
//  Created by Arkasha Zuev on 05.08.2021.
//

import SwiftUI

struct EditScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarTitle(Text("Your friend's name"))
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
