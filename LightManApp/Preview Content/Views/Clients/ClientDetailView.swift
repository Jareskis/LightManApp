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
    @State private var newStreet = ""
    @State private var newCity = ""
    @State private var newState = "MT"
    @State private var newZip = ""
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var isAddingJob = false
    
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
                    TextField(client.street, text: $newStreet)
                    TextField(client.city, text: $newCity)
                    Picker(client.state, selection: $newState){
                        ForEach(usStates, id: \.self) {
                            state in Text(state)
                        }
                    }
                    TextField(client.zip, text: $newZip)
                } else {
                    Text(client.street)
                    Text(client.city)
                    Text(client.state)
                    Text(client.zip)
                }
            }
            
            Section("Jobs"){
                
                ForEach(client.jobs){ job in
                    NavigationLink(job.type, destination: JobDetailView(job: job))
                }
                
                Button("Add Job"){
                    isAddingJob = true
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
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .toolbar {
            if !isEditing {
                ToolbarItem(placement: .confirmationAction){
                    Button("Edit"){
                        newName = client.name
                        newEmail = client.email ?? ""
                        newPhone = client.phone ?? ""
                        newStreet = client.street
                        newCity = client.city
                        newState = client.state
                        newZip = client.zip
                        isEditing = true
                    }
                }
            } else {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        saveClient()
                        }
                    .disabled(
                        newName.isEmpty ||
                        newStreet.isEmpty ||
                        newCity.isEmpty ||
                        newState.isEmpty ||
                        newZip.isEmpty ||
                        (newEmail.isEmpty && newPhone.isEmpty))
                    }
                }
            }
        .sheet(isPresented: $isAddingJob){ AddJobView(client: client) }
        .onDisappear{
            try? modelContext.save()
        }
        }
    
    func saveClient() {
        client.name = newName
        client.email = newEmail
        client.phone = newPhone
        client.street = newStreet
        client.city = newCity
        client.state = newState
        client.zip = newZip
        try? modelContext.save()
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
    let client = Client(
        name: "Jarek Carlson",
        email: "jarek@email.com",
        phone: "506-570-7848",
        street: "353 Milestone Drive",
        city: "Bozeman",
        state: "MT",
        zip: "59715"
    )
    let job = Job(
        type: "Install",
        date: .now,
        status: .notStarted,
        notes: nil,
        client: client,
        street: "353 Milestone Drive",
        city: "Bozeman",
        state: "MT",
        zip: "59715"
    )
    container.mainContext.insert(client)
    container.mainContext.insert(job)
    client.jobs.append(job)
    return ClientDetailView(client: client)
}

