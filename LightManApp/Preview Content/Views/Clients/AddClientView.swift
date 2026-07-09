//
//  AddClientView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import Foundation
import SwiftData
import SwiftUI

struct AddClientView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Client Name", text: $name)
                TextField("Client Email", text: $email)
                TextField("Client Phone Number", text: $phone)
                TextField("Client Address", text: $address)
            
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Client"){
                        addClient()
                    }
                    .disabled(name.isEmpty || address.isEmpty || (email.isEmpty && phone.isEmpty))
                    /*  is Name missing or
                     address missing or
                     both email and phone missing
                     */
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }

            }
            .navigationTitle("Add Client")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
    func addClient() {
        let client = Client(name: name, email: email, phone: phone, address: address)
        modelContext.insert(client)
        try? modelContext.save()
        dismiss()
    }
}


#Preview {
    AddClientView()
}
