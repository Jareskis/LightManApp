//
//  DashboardView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI
import SwiftData


struct DashboardView: View {
    
    @Query var jobs: [Job]
    
    var todaysJobs : [Job] {
        jobs.filter {Calendar.current.isDateInToday($0.date)}
    }
    
    var overdueJobs: Int {
        let today = Calendar.current.startOfDay(for: Date.now)
        return jobs.filter { $0.date < today && $0.status != .finished}.count
    }
    
    var upcomingJobs: Int {
        let today = Calendar.current.startOfDay(for: Date.now)
        return jobs.filter { $0.date >= today && $0.status != .inProgress }.count
    }
    
    var inProgressJobs: Int {
        jobs.filter {$0.status == .inProgress}.count
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    VStack{
                        Text("Overdue")
                            .bold()
                        Text("\(overdueJobs)")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(15)
                    
                    VStack{
                        Text("Upcoming")
                            .bold()
                        Text("\(upcomingJobs)")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(15)
                    
                    VStack{
                        Text("Active")
                            .bold()
                        Text("\(inProgressJobs)")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(15)
                    
                }
                .padding()
                Spacer()
            }
            List{
                ForEach(todaysJobs) { job in
                    NavigationLink(destination: JobDetailView(job : job)){
                        VStack(alignment: .leading) {
                            Text(job.type)
                                .font(.headline)
                            Text(job.client.name)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview{
    DashboardView()
}
