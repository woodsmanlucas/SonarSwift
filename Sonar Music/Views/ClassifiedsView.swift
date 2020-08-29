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

    
    var body: some View {
        ScrollView(.vertical){
            VStack{
                NavigationLink(destination: ClassifiedMapView(classifieds: self.viewModel.classifieds)) {
                    Text("View the Map")
                }
                ClassifiedView()
            ForEach(self.viewModel.classifieds, id: \._id, content: {classified in
                ClassifiedView()
            })
            }.frame(maxWidth: .infinity)
        }.onAppear{self.viewModel.GetClassifieds()}        .navigationBarTitle("Classifieds")
    }
}

struct ClassifiedView: View {
    var user = User(_id: "asdf", username: "Asdf", firstName: "Lucas", lastName: "Johnson", lat: 49.2577143, lng: -123.1939435)
    var classified: Classified
    var pictureUrl: URL?
        
    init(){
//    init(_ classified: Classified) {
//        self.classified = classified
        self.classified = Classified(_id: "asdfsadf", datePosted: 12, pictures: [], tags: [], title: "Hard Coded Please Remove me", description: "This is a hard coded classified", type: "Buy", yearsOfExperience: "1", user: [self.user])
        if(classified.pictures.count > 0){
            self.pictureUrl = URL(string: classified.pictures[0])!
        }
        }
    
    var body: some View {
        guard let url = pictureUrl else {
            return AnyView(NavigationLink(destination: SingleClassifiedView(classified)){
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
        
        return AnyView(
            NavigationLink(destination: SingleClassifiedView(classified)){
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
            
            VStack{
                Text(classified.title).bold()
                Text(classified.description)
                    AsyncImage(
                        url: url,
                        placeholder: Text("Loading ...")
                    ).aspectRatio(contentMode: .fit)
            }
                
            }.buttonStyle(PlainButtonStyle()).frame(width: 350, height: 150)
        )
    }
}

struct ClassifiedsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedsView(viewModel: ClassifiedsViewModel())
    }
}
