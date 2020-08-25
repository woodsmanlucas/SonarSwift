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
                NavigationLink(destination: ClassifiedMapView()) {
                    Text("View the Map")
                }
            ForEach(self.viewModel.classifieds, id: \._id, content: {classified in
                    ClassifiedView(classified)
            })
            }.frame(maxWidth: .infinity)
        }.onAppear{self.viewModel.GetClassifieds()}
    }
}

struct ClassifiedView: View {
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
            return AnyView(ZStack{
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
            VStack{
                Text(classified.title).bold()
                Text(classified.description)
                }
            }.frame(width: 350, height: 150))
        }
        
        return AnyView(ZStack{
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
            NavigationLink(destination: SingleClassifiedView(classified)){
            VStack{
                Text(classified.title).bold()
                Text(classified.description)
                    AsyncImage(
                        url: url,
                        placeholder: Text("Loading ...")
                    ).aspectRatio(contentMode: .fit)
            }
            }.buttonStyle(PlainButtonStyle())        }.frame(width: 350, height: 150)
        )
    }
}

struct ClassifiedsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedsView(viewModel: ClassifiedsViewModel())
    }
}
