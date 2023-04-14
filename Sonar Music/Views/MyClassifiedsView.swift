//
//  MyClassifiedsView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-16.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

// ToDo add single my classified view

import SwiftUI

struct MyClassifiedsView: View {
        @ObservedObject var viewModel: ClassifiedsViewModel
        @ObservedObject var jwt: JWT

        
        var body: some View {
            ScrollView(.vertical){
                VStack{
                ForEach(self.viewModel.myClassifieds, id: \._id, content: {classified in
                    MyClassifiedView(classified, viewModel: self.viewModel, jwt: jwt)
                })
                }.frame(maxWidth: .infinity)
            }.onAppear{self.viewModel.getMyClassifeds()}
                .navigationBarTitle("My Classifieds")
        }
    }

struct MyClassifiedView: View {
    @ObservedObject var viewModel: ClassifiedsViewModel
    @ObservedObject var jwt: JWT

    var classified: MyClassified
    var pictureUrl: String?

    init(_ classified: MyClassified, viewModel: ClassifiedsViewModel, jwt: JWT) {
        self.classified = classified
        self.viewModel = viewModel
        self.jwt = jwt
        print(classified._id)
        print(classified.pictures)
        if(classified.pictures.count > 0){
            self.pictureUrl = classified.pictures[0]
        }
        }
    
    var body: some View {
        return AnyView(VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
                VStack{
                    Text(classified.title).bold()
                    Text(classified.description)
                }
            }
            .frame(width: 350, height: 150)
            Button(action: {
                self.viewModel.delete(self.classified._id)
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.red)
                    Text("Delete")
                }
            }.buttonStyle(PlainButtonStyle()).frame(width: 100, height: 20)
        }
            )
        }
}
