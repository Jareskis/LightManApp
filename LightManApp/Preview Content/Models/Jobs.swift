//
//  Jobs.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import Foundation
import SwiftData
import SwiftUI

enum JobType: String, Codable, CaseIterable {
    case install = "Install"
    case takedown = "Take Down"
    case repair = "Repair"
}

enum StatusType: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case finished = "Finished"
}

@Model
class Job {
    var type : JobType
    var date : Date
    var status : StatusType
    var notes : String?
    var client : Client
    
    init(type: JobType, date: Date, status: StatusType, notes: String?, client: Client) {
        self.type = type
        self.date = date
        self.status = status
        self.notes = notes
        self.client = client
    }
}
