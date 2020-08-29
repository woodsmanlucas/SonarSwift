//
//  SingleClassifiedView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-25.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct SingleClassifiedView: View {
    var classified: Classified
    var pictureUrl: URL?
        
    init(_ classified: Classified) {
        self.classified = classified
        if(classified.pictures.count > 0){
            self.pictureUrl = URL(string: classified.pictures[0])!
        }
        }
    
    var body: some View {
        guard let url = pictureUrl else {
                   return AnyView(
                   VStack{
                       Text(classified.title).bold()
                       Text(classified.description)
                    NavigationLink(destination: MessageUser(userId: classified.user[0]!._id)){
                        Text("Message this user")
                    }
                       }.navigationBarTitle("Classified")            )
               }
               
               return AnyView(
                   VStack{
                       Text(classified.title).bold()
                       Text(classified.description)
                           AsyncImage(
                               url: url,
                               placeholder: Text("Loading ...")
                           ).aspectRatio(contentMode: .fit)
                   }.navigationBarTitle("Classified")
               )
    }
}
