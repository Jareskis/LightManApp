//
//  AddJobView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 7/9/26.
//

import SwiftUI
import SwiftData

struct AddJobView: View {
    
    @State private var type =  ""
    @State private var date = Date.now
    @State private var status = StatusType.notStarted
    @State private var notes = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = "MT"
    @State private var zip = ""
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
                
                Section(){
                    TextField("Job Type", text: $type)
                }
                
                Picker("Job Status", selection: $status){
                    ForEach(StatusType.allCases, id: \.self){
                        Text($0.rawValue)
                    }
                }
                
                Section("Address") {
                    TextField("Address", text: $street)
                    TextField("City", text: $city)
                    Picker("State", selection: $state){
                        ForEach(usStates, id: \.self){
                            state in Text(state)
                        }
                    }
                    TextField("Zip Code", text: $zip)
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
        let job = Job(type: type, date: date, status: status, notes: notes, client: client, street: street, city: city, state: state, zip: zip)
        modelContext.insert(job)
        client.jobs.append(job)
        LocationManager.geocode(street: street, city: city, state: state, zip: zip) { lat, lon in
            print("Geocoded: \(lat), \(lon)")
            print("\(street)")
            print("\(city)")
            print("\(state)")
            print("\(zip)")
            job.latitude = lat
            job.longitude = lon
            try? self.modelContext.save()
            DispatchQueue.main.async {
                self.dismiss()
            }
        }
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
    container.mainContext.insert(client)
    return AddJobView(client: client)
        .modelContainer(container)
}
