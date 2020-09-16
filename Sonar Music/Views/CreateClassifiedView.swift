//
//  CreateClassifiedView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct CreateClassifiedView: View {
    @ObservedObject var classifiedsViewModel: ClassifiedsViewModel
    var jwt: JWT
    @State var title: String = ""
    @State var description: String = ""
    @State var state: types = .Buy
    @State var price: Double = 0
    enum types: String, CaseIterable, Identifiable {
        case Buy
        case Sell
        case Looking_for_musician
        case Looking_for_band
        case Looking_for_gigs
        
        var id: String {self.rawValue}
    }

    private func isUserInformationValid() -> Bool {
       if self.title.isEmpty {
               return false
           }
           
       if self.description.isEmpty {
               return false
           }
           
           return true
       }
    var body: some View {
         VStack{
                   Form{
                       TextField("Subject", text: $title)
                       TextField("Description", text: $description)
                    if(state.rawValue == "Buy" || state.rawValue == "Sell"){
                        TextField("Price", value: $price, formatter: NumberFormatter())
                    }
                    
                        Picker("Type of Ad", selection: $state) {
                            Text("Buy").tag(types.Buy)
                            Text("Sell").tag(types.Sell)
                            Text("Looking for Musician").tag(types.Looking_for_musician)
                            Text("Looking for Band").tag(types.Looking_for_band)
                            Text("Looking for gigs").tag(types.Looking_for_gigs)
                        }
                       
                       if self.isUserInformationValid() {
                           Button(action: {
                            self.classifiedsViewModel.CreateClassified(self.jwt.token!, title: self.title, description: self.description, type: self.state.rawValue.replacingOccurrences(of: "_", with: " "))
                           }, label: {
                               Text("Create Classified")
                           })
                       }
                   }
               .navigationBarTitle("Create Classified")
        }
    }
}
