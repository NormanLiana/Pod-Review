//
//  LibraryModel.swift
//  CocoaPod-Review
//
//  Created by Liana Norman on 11/7/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import MapKit
import CoreLocation
import Foundation

struct Libraries: Codable {
    let locations: [Library]
}

struct Library: Codable {
    let data: LibraryWrapper
}

class LibraryWrapper: NSObject, Codable, MKAnnotation {
    let title: String?
    let address: String
    
    private let position: String
    
    @objc var coordinate: CLLocationCoordinate2D {
        let latlong = position.components(separatedBy: ", ").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).map({Double($0)})
        
        guard latlong.count == 2, let lat = latlong[0], let long = latlong[1] else {return CLLocationCoordinate2D.init()}
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
    
    var hasValidCoordinates: Bool {
        return coordinate.latitude != 0 && coordinate.longitude != 0
    }
    
    static func getLibraries(from jsonData: Data) -> [LibraryWrapper] {
        do {
            return try JSONDecoder().decode(Libraries.self, from: jsonData).locations.map({$0.data})
        } catch {
            print("decoding error: \(error)")
            return []
        }
    }
}

