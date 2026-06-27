
import Foundation
import SwiftData
import MapKit

@Model
class Client {
    var name: String
    var email: String?
    var phone : String?
    var address : String //Figure out how to store address
    @Relationship(deleteRule: .cascade) var jobs : [Job]
    
    init(name: String, email: String?, phone: String?, address: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.jobs = []
    }
    
}



