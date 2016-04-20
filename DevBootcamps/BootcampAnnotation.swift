//
//  BootcampAnnotation.swift
//  DevBootcamps
//
//  Created by William L. Marr III on 4/20/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
