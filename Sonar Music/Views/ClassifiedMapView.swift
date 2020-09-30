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


struct ClassifiedsMapView: View {
    var classifieds: [Classified]

    var body: some View {
        ClassifiedsMap(classifieds: classifieds)
    }
}



struct ClassifiedsMap: UIViewRepresentable {
    @ObservedObject var lm = LocationManager()
    var classifieds: [Classified]
    
    func updateUIView(_ view: MKMapView, context: Context){        view.mapType = MKMapType.standard // (satellite)
        if(view.region.center.latitude == 49.2577143 && view.region.center.longitude == -123.1939435){
        let coordinate = lm.location != nil ? lm.location!.coordinate : CLLocationCoordinate2D(
            latitude: 49.2577143, longitude: -123.1939435)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        }
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
          let view = MKMapView(frame: .zero)
        
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
        return view
    }
}
