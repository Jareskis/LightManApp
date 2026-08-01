//
//  ClientListView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI
import Foundation
import SwiftData

struct ClientListView: View {
    
    @State private var searchText = ""
    @State private var isShowingAdd = false
    @Query var clients: [Client]
    
    var filteredClients: [Client]{
        if searchText.isEmpty {
            return clients.sorted{ $0.name < $1.name}
        } else {
            return clients.filter{ client in
                client.name.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.name < $1.name}
        }
    }
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(filteredClients){ client in
                    NavigationLink(client.name, destination: ClientDetailView(client : client))
                }
            }
            .toolbar {
                Button("Add Client"){
                    isShowingAdd = true
                }
                

            }
            .searchable(text: $searchText)
            .navigationTitle("Clients")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowingAdd) { AddClientView() }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Client.self, configurations: config)
    let client = Client(name: "Jarek Carlson", email: "jarek@email.com", phone: "506-570-7848", address: "353 Milestone Drive")
    container.mainContext.insert(client)
    return ClientListView()
        .modelContainer(container)
}

