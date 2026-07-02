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
    
    @State private var isShowingAdd = false
    @Query var clients: [Client]
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(clients){ client in
                    NavigationLink(client.name, destination: ClientDetailView(client : client))
                }
            }
            .toolbar {
                Button("Add Client"){
                    isShowingAdd = true
                }

            }
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

