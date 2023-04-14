//
//  ClassifiedMapView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-25.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

// ToDo Fix coordinate out of range on open

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
    @ObservedObject var lm = LocationManager()


    var body: some View {
        ClassifiedsMap(classifieds: classifieds, lm: lm)
    }
}



struct ClassifiedsMap: UIViewRepresentable {
    var classifieds: [Classified]
    var lm: LocationManager
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    class Coordinator: NSObject, MKMapViewDelegate {
            var parent: ClassifiedsMap
            
            init(_ parent: ClassifiedsMap){
                self.parent = parent
            }
            
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
            var pav:MKPinAnnotationView?
                
            if (pav == nil)
            {
                pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId);
                pav?.pinTintColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
                pav?.canShowCallout = true;
            } else {
            pav?.annotation = annotation;
                
            }
            
            return pav;
    }
    
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
    }
    
    func makeUIView(context: Context) -> MKMapView {
          let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator

        let coordinate = lm.coordinate
        
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
                for classified in classifieds {
                    var lat: Double, lng: Double
                    
                    if(classified.user.count > 0){
                        lat = classified.user[0]?.lat ?? 47.533272
                        lng = classified.user[0]?.lng ?? -122.035332
                    }else{
                        lat = 47.533272
                        lng = -122.035332
                    }
                    let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat),longitude: CLLocationDegrees(lng))
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    annotation.title = classified.title
                    annotation.subtitle = classified.description
                    
                    view.addAnnotation(annotation)
                    
                }
        
//        for classified in classifieds {
//            if locations.contains(where: { (location) -> Bool in
//            return classified.user[0]!.lat == location.lat && classified.user[0]!.lng == location.lng
//            }){
//                let first = locations.firstIndex(where: { (location) -> Bool in
//                return classified.user[0]!.lat == location.lat && classified.user[0]!.lng == location.lng
//                })
//                print(first!)
//                print(classified)
//
//
//            }else{
//                let location = Location(lat: classified.user[0]!.lat, lng: classified.user[0]!.lng, title: classified.title, subtitle: classified.description, multi: false)
//
//                locations.append(location)
//            }
//        }
//
//        for location in locations {
//            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.lat ??  49.2577143),longitude: CLLocationDegrees(location.lng ?? -123.1939435))
//
//            let annotation = MKAnnotation()
//            annotation.coordinate = coordinates
//
//                annotation.title = location.title
//                annotation.subtitle = location.subtitle
//            annotation.clusteringIdentifier = "ad"
//            view.addAnnotation(annotation)
//
//        }
        return view
    }
}
