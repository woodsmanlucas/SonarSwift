//
//  EditProfileLocation.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-13.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI
import MapKit

struct EditProfileLocation: UIViewRepresentable {
    @ObservedObject var lm = LocationManager()
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = MKMapType.standard
        let coordinate = lm.location != nil ? lm.location!.coordinate : CLLocationCoordinate2D(
            latitude: 49.2577143, longitude: -123.1939435)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Where your ad will appear"
        
        view.addAnnotation(annotation)
    }
    
    func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")

            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true

            return pinAnnotationView
        }

        return nil
    }
}
