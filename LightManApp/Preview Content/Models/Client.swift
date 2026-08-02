
import Foundation
import SwiftData


@Model
class Client {
    var name: String
    var email: String?
    var phone : String?
    var street : String
    var city : String
    var state : String
    var zip : String
    var latitude : Double?
    var longitude : Double?
    @Relationship(deleteRule: .cascade) var jobs : [Job]
    
    init(name: String,
         email: String?,
         phone: String?,
         street: String,
         city: String,
         state: String,
         zip: String
    ){
        self.name = name
        self.email = email
        self.phone = phone
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.latitude = nil
        self.longitude = nil
        self.jobs = []
    }
    
}



