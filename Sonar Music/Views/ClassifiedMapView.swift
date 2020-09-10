//
//  ClassifiedMapView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-25.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import MapKit
import SwiftUI

struct Location{
    var lat: Float?
    var lng: Float?
    var title: String
    var subtitle: String
    var multi: Bool
}


struct ClassifiedMapView: UIViewRepresentable {
    var classifieds: [Classified]
    
    func updateUIView(_ view: MKMapView, context: Context){        view.mapType = MKMapType.standard // (satellite)

        let coordinate = CLLocationCoordinate2D(
            latitude: 49.2577143, longitude: -123.1939435)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        var locations: [Location] = []
        
        for classified in classifieds {
            if locations.contains(where: { (location) -> Bool in
            return classified.user[0]!.lat == location.lat && classified.user[0]!.lng == location.lng
            }){
                let first = locations.firstIndex(where: { (location) -> Bool in
                return classified.user[0]!.lat == location.lat && classified.user[0]!.lng == location.lng
                })
                print(first!)
                print(classified)
                
                
            }else{
                let location = Location(lat: classified.user[0]!.lat, lng: classified.user[0]!.lng, title: classified.title, subtitle: classified.description, multi: false)
                
                locations.append(location)
            }
        }
        
        for location in locations {
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.lat ??  49.2577143),longitude: CLLocationDegrees(location.lng ?? -123.1939435))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates

                annotation.title = location.title
                annotation.subtitle = location.subtitle
            view.addAnnotation(annotation)
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
    }
}
