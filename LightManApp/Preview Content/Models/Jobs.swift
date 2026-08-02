//
//  Jobs.swift
//  LightManApp
//
//  Created by Jarek Carlson on 6/26/26.
//
import Foundation
import SwiftData
import SwiftUI

enum StatusType: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case finished = "Finished"
}

@Model
class Job {
    var type : String
    var date : Date
    var status : StatusType
    var notes : String?
    var client : Client
    var street : String
    var city : String
    var state : String
    var zip : String
    var latitude : Double?
    var longitude : Double?
    
    init(type: String,
         date: Date,
         status: StatusType,
         notes: String?,
         client: Client,
         street : String,
         city : String,
         state : String,
         zip : String
        )
      {
        self.type = type
        self.date = date
        self.status = status
        self.notes = notes
        self.client = client
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.latitude = nil
        self.longitude = nil
    }
}
