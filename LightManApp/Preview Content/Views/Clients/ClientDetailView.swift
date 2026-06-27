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
    
    var client: Client
    
    var body: some View {
        Text(client.name)
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
