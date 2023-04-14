//
//  ClassifiedsView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct ClassifiedsView: View {
    @ObservedObject var viewModel: ClassifiedsViewModel
    @ObservedObject var jwt: JWT

    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                NavigationLink(destination: ClassifiedsMapView(classifieds: self.viewModel.classifieds)) {
                    Text("View the Map")
                }
//                NavigationLink(destination: ClassifiedMapRedo()) {
//                    Text("View the other Map")
//                }
            ForEach(self.viewModel.classifieds, id: \._id, content: {classified in
                ClassifiedView(classified, jwt: self.jwt)
            })
            }.frame(maxWidth: .infinity)
        }.onAppear{self.viewModel.GetClassifieds()}        .navigationBarTitle("Classifieds")
    }
}

struct ClassifiedView: View {
    var classified: Classified
    var pictureUrl: String?
    @ObservedObject var jwt: JWT

    init(_ classified: Classified, jwt: JWT) {
        self.classified = classified
        self.jwt = jwt
        print(classified._id)
        print(classified.pictures)
        if(classified.pictures.count > 0){
            self.pictureUrl = classified.pictures[0]
        }
        }
    
    var body: some View {
            return AnyView(NavigationLink(destination: SingleClassifiedView(classified, jwt: jwt)){
                ZStack{
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
            VStack{
                Text(classified.title).bold()
                Text(classified.description)
                }
                }
            }
            .buttonStyle(PlainButtonStyle()).frame(width: 350, height: 150))
    }
}
