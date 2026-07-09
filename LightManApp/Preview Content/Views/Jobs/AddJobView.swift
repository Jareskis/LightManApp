//
//  AddJobView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 7/9/26.
//

import SwiftUI
import SwiftData

struct AddJobView: View {
    
    @State private var type =  JobType.install
    @State private var date = Date.now
    @State private var status = StatusType.notStarted
    @State private var notes = ""
    var client: Client
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form{
                
                Section("Client"){
                    Text(client.name)
                }
                
                DatePicker(selection: $date, in: Date.now..., displayedComponents: .date){
                    Text("Job Date")
                }
                
                Picker("Job Type", selection: $type){
                    ForEach(JobType.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }
                
                Picker("Job Status", selection: $status){
                    ForEach(StatusType.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }
                
                Section("Job Notes"){
                    TextEditor(text: $notes)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Save Job"){
                        saveJob()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Job")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func saveJob() {
        let job = Job(type: type, date: date, status: status, notes: notes, client: client)
        modelContext.insert(job)
        client.jobs.append(job)
        try? modelContext.save()
        dismiss()
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Client.self, configurations: config)
    let client = Client(name: "Jarek Carlson", email: "jarek@email.com", phone: "506-570-7848", address: "353 Milestone Drive")
    container.mainContext.insert(client)
    return AddJobView(client: client)
        .modelContainer(container)
}
