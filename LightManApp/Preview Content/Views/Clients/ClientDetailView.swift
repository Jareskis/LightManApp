//
//  ClientDetailView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import Foundation
import SwiftUI
import SwiftData

struct ClientDetailView: View {
    
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newPhone = ""
    @State private var newAddress = ""
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var client: Client
    
    var body: some View {
        Form {
            Section("Name") {
                if isEditing {
                    TextField(client.name, text: $newName)
                        .textContentType(.name)
                } else {
                    Text(client.name)
                }
            }
            Section("Email") {
                if isEditing {
                    TextField(client.email ?? "", text: $newEmail)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                } else {
                    Text(client.email ?? "Not Provided")
                }
            }
            Section("Phone") {
                if isEditing {
                    TextField(client.phone ?? "", text: $newPhone)
                        .textContentType(.telephoneNumber)
                } else {
                    Text(client.phone ?? "Not Provided")
                    
                }
            }
            Section("Address") {
                if isEditing {
                    TextField(client.address, text: $newAddress)
                        .textContentType(.fullStreetAddress)
                } else {
                    Text(client.address)
                }
            }
            Button("Delete Client"){
                isShowingAlert = true
            }
            .alert("Are you sure you want to delete this client?", isPresented: $isShowingAlert) {
                Button("Yes", role: .destructive) {
                    deleteClient()
                }
                Button("No", role: .cancel) {}
            }
            
        }
        .toolbar {
            if !isEditing {
                ToolbarItem(placement: .confirmationAction){
                    Button("Edit"){
                        newName = client.name
                        newEmail = client.email ?? ""
                        newPhone = client.phone ?? ""
                        newAddress = client.address
                        isEditing = true
                    }
                }
            } else {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        saveClient()
                        }
                    .disabled(newName.isEmpty || newAddress.isEmpty || (newEmail.isEmpty && newPhone.isEmpty))
                    }
                }
            }
        }
    func saveClient() {
        client.name = newName
        client.email = newEmail
        client.phone = newPhone
        client.address = newAddress
        isEditing = false
    }
    
    func deleteClient() {
        modelContext.delete(client)
        try? modelContext.save()
        dismiss()
    }
}


#Preview {
 let config = ModelConfiguration(isStoredInMemoryOnly: true)
 let container = try! ModelContainer(for: Client.self, configurations: config)
 let client = Client(name: "Jarek Carlson", email: "jarek@email.com", phone: "506-570-7848", address: "353 Milestone Drive")
 container.mainContext.insert(client)
 return ClientDetailView(client:client)
 .modelContainer(container)
 }

