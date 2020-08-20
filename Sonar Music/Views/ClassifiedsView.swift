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
            ForEach(self.viewModel.classifieds, id: \._id, content: {classified in
                    ClassifiedView(classified: classified)
            })
            }.frame(maxWidth: .infinity)
        }.onAppear{self.viewModel.GetClassifieds()}
    }
}

struct ClassifiedView: View {
    var classified: Classified
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)
            VStack{
                Text(classified.title).bold()
                Text(classified.description)
            }
        }.frame(width: 400, height: 150)
    }
}

struct ClassifiedsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedsView(viewModel: ClassifiedsViewModel())
    }
}
