//
//  ContentView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView()
            }
            .tabItem{
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            NavigationStack {
                ClientListView()
            }
            .tabItem {
                Label("Clients", systemImage: "person.2.fill")
            }
            .tag(1)
            
            NavigationStack {
                ScheduleView()
            }
            .tabItem{
                Label("Schedule", systemImage: "calendar")
            }
            .tag(2)
            
            NavigationStack {
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "mappin")
            }
            .tag(3)
                      
        }
    }
}

#Preview {
    ContentView()
}
