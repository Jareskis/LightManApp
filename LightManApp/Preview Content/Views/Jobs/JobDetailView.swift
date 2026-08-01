//
//  JobDetailView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 7/9/26.
//

import SwiftUI
import SwiftData

struct JobDetailView: View{
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    
    @State private var updatedType = JobType.install
    @State private var updatedDate = Date.now
    @State private var updatedStatus = StatusType.notStarted
    @State private var updatedNotes = ""
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var job: Job
    
    
    var body: some View {
        if job.modelContext != nil {
            Form{
                Section("Client"){
                    Text(job.client.name)
                }
                
                Section("Details"){
                    if isEditing {
                        DatePicker("Job Date", selection: $updatedDate, in: Date.now..., displayedComponents: .date)
                        Picker("Job Type", selection: $updatedType){
                            ForEach(JobType.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                        Picker("Job Status", selection: $updatedStatus){
                            ForEach(StatusType.allCases, id: \.self){
                                Text($0.rawValue)
                            }
                        }
                    } else {
                        Text(job.date, style: .date)
                        Text(job.type.rawValue)
                        Text(job.status.rawValue)
                    }
                }
                
                Section("Notes"){
                    if isEditing {
                        TextEditor(text: $updatedNotes)
                    } else {
                        Text(job.notes ?? "")
                    }
                }
                
                if !isEditing {
                    Button("Delete Job") {
                        isShowingAlert = true
                    }
                    .alert("Are you sure you want to delete this job?", isPresented: $isShowingAlert){
                        Button("Yes", role: .destructive){
                            deleteJob()
                        }
                        Button("No", role: .cancel) {}
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            .onDisappear{
                try? modelContext.save()
            }
            .toolbar{
                if !isEditing{
                    ToolbarItem(placement: .confirmationAction){
                        Button("Edit"){
                            updatedDate = job.date
                            updatedType = job.type
                            updatedStatus = job.status
                            updatedNotes = job.notes ?? ""
                            isEditing = true
                        }
                    }
                } else {
                    ToolbarItem(placement: .confirmationAction){
                        Button("Save"){
                            saveJob()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction){
                        Button("Cancel"){
                            isEditing = false
                        }
                    }
                }
            }
        }
    }
    
    func saveJob() {
        job.date = updatedDate
        job.type = updatedType
        job.status = updatedStatus
        job.notes = updatedNotes
        try? modelContext.save()
        isEditing = false
    }
    
    func deleteJob() {
        dismiss()
        modelContext.delete(job)
        try? modelContext.save()
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Client.self, configurations: config)
    let client = Client(name: "Jarek Carlson", email: "jarek@email.com", phone: "506-570-7848", address: "353 Milestone Drive")
    let job = Job(type: .install, date: .now, status: .notStarted, notes: nil, client: client)
    container.mainContext.insert(job)
    return JobDetailView(job: job)
        .modelContainer(container)
}
