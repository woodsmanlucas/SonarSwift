//
//  CreateClassifiedView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct CreateClassifiedView: View {
    @ObservedObject var classifieds: ClassifiedsViewModel
    @ObservedObject var jwt: JWT
    @State var title: String = ""
    @State var description: String = ""
    @State var state: types = .Buy
    @State var price: Double = 0
    @State var imageIndex: Int = 0
    @State var offset = CGSize.zero
    
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
                   Form{
                       TextField("Subject", text: $title)
                       TextField("Description", text: $description)
                    if(state.rawValue == "Buy" || state.rawValue == "Sell"){
                        TextField("Price", value: $price, formatter: NumberFormatter()).keyboardType(.numberPad)                    }
                    
                        Picker("Type of Ad", selection: $state) {
                            Text("Buy").tag(types.Buy)
                            Text("Sell").tag(types.Sell)
                            Text("Looking for Musician").tag(types.Looking_for_musician)
                            Text("Looking for Band").tag(types.Looking_for_band)
                            Text("Looking for gigs").tag(types.Looking_for_gigs)
                        }
                    
                    NavigationLink(destination: AddImageToClassified(classifieds: self.classifieds, jwt: self.jwt)) {
                        Text("Add an Image")
                    }
                    

                       if (self.isUserInformationValid()) {
                           Button(action: {
                            self.classifieds.CreateClassified(self.jwt.token!, title: self.title, description: self.description, type: self.state.rawValue.replacingOccurrences(of: "_", with: " "))
                           }, label: {
                               Text("Create Classified")
                           })
                       }
                    
                    if(self.classifieds.images.count > 0){
                        HStack{
                            Spacer()
                        Image(uiImage: self.classifieds.images[imageIndex])
                            .resizable()
                        .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(Double(offset.width / 5)))
                            .offset(x: offset.width * 5, y: 0)
                            .opacity(2 - Double(abs(offset.width / 50)))
                            .gesture(
                                DragGesture()
                                    .onChanged {
                                        gesture in
                                        self.offset = gesture.translation
                                    }
                                .onEnded{
                                    _ in
                                    if (abs(self.offset.width) > 100)
                                        {
                                            print(self.offset.width)
                                            if(self.offset.width > 0){
                                                if(self.imageIndex >= self.classifieds.images.count - 1){
                                                    self.imageIndex = 0
                                                    self.offset.width = .zero
                                                }else{
                                                    self.imageIndex += 1
                                                    self.offset.width = .zero
                                                }
                                                    
                                            }else{
                                                if(self.imageIndex <= 0){
                                                    self.imageIndex = self.classifieds.images.count - 1
                                                    self.offset.width = .zero

                                                }else{
                                                    self.imageIndex -= 1
                                                    self.offset.width = .zero
                                                }
                                            }
                                            print(self.imageIndex)
                                    } else {
                                        self.offset = .zero
                                        }
                            })
                            Spacer()
                        }
                        
                   }
         }.navigationBarTitle("Create Classified")
    }
}
