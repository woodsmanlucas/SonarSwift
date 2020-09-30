//
//  EditProfileLocation.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-13.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI
import MapKit


enum MKAnnotationViewDragState {
    case starting, dragging, ending, none, canceling
}

struct EditProfileLocationMap: UIViewRepresentable {
    @ObservedObject var lm: LocationManager
    @ObservedObject var profile: UserViewModel
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: EditProfileLocationMap
        
        init(_ parent: EditProfileLocationMap){
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView,
         annotationView view: MKAnnotationView,
              didChange newState: MKAnnotationView.DragState,
              fromOldState oldState: MKAnnotationView.DragState){
            if view.annotation?.title! == "your ads will appear here" {
                parent.profile.location = view.annotation?.coordinate
            }
        }


            
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pav:MKPinAnnotationView?
            

            
        if (pav == nil)
        {
            pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)

        if annotation.title! == "your ads will appear here" {
            pav?.isDraggable = true;
            pav?.canShowCallout = true;
            pav?.pinTintColor = UIColor.purple
            } else {
                pav?.pinTintColor = UIColor.green
            pav?.canShowCallout = true;

            }
        }
        else
        {
        pav?.annotation = annotation;
            
        }
        return pav;
        }
}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator

        
        let coordinate = (profile.profile[0].lat != nil && profile.profile[0].lng != nil) ? CLLocationCoordinate2D(
            latitude: profile.profile[0].lat!, longitude: profile.profile[0].lng!) :  CLLocationCoordinate2D(
            latitude: 49.2577143, longitude: -123.1939435)
        let currentLocation = lm.location != nil ? lm.location!.coordinate : CLLocationCoordinate2D(
        latitude: 49.2577143, longitude: -123.1939435)
        print(coordinate)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
               let region = MKCoordinateRegion(center: currentLocation, span: span)
               view.setRegion(region, animated: true)
        
            let redAnnotation = MKPointAnnotation()
            redAnnotation.coordinate = coordinate
            redAnnotation.title = "your ad was here"
        
        view.addAnnotation(redAnnotation)
        
        
        let purpleAnnotation = MKPointAnnotation()
        purpleAnnotation.coordinate = currentLocation
        purpleAnnotation.title = "your ads will appear here"
        view.addAnnotation(purpleAnnotation)
        
        
        return view
    }
}

//
//func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//    if annotation is MKPointAnnotation {
//        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
//
//        pinAnnotationView.isDraggable = true
//        pinAnnotationView.canShowCallout = true
//        pinAnnotationView.animatesDrop = true
//
//        return pinAnnotationView
//    }
//
//    return nil
//}
