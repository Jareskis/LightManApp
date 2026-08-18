//
//  MapView.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var selectedDate = Date.now
    
    @StateObject private var locationManager = LocationManager()
    
    @Query var jobs: [Job]
    
    var jobsForSelectedDay: [Job] {
        jobs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        Map(position: $position){
            UserAnnotation()
            
            ForEach(jobsForSelectedDay) { job in
                if let lat = job.latitude, let lon = job.longitude {
                    Annotation(job.client.name, coordinate: CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: lon
                    )){
                        VStack{
                            Text(job.type)
                                .font(.caption)
                                .bold()
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                                .font(.title)
                        }
                        .padding(6)
                        .background(.white)
                        .cornerRadius(8)
                    }
                }
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
    job.latitude = 45.6770
    job.longitude = -111.0429
    container.mainContext.insert(client)
    container.mainContext.insert(job)
    client.jobs.append(job)
    return MapView()
        .modelContainer(container)
}
