//
//  ScheduleView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI
import SwiftData

struct ScheduleView: View {
    
    @State private var searchText = ""
    @Query var jobs: [Job]
    
    var jobsByDay: [Date : [Job]] {
        Dictionary(grouping: jobs) { job in
            Calendar.current.startOfDay(for: job.date)
        }
    }
    
    var sortedDays: [Date] {
        jobsByDay.keys.sorted()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedDays, id: \.self){day in
                    Section(day.formatted(date: .abbreviated, time: .omitted)){
                        ForEach(jobsByDay[day] ?? []) { job in
                            NavigationLink(destination: JobDetailView(job : job)) {
                                VStack(alignment: .leading) {
                                    Text(job.type)
                                        .font(.headline)
                                    Text(job.client.name)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    Text(job.status.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ScheduleView()
}
