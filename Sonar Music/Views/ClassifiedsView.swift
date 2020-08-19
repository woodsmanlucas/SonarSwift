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
        ScrollView{
                ForEach(self.viewModel.classifieds, id: \._id, content: {classified in
            Text("This is coming bear with me")
            })
        }.onAppear{self.viewModel.GetClassifieds()}
    }
}

struct ClassifiedsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifiedsView(viewModel: ClassifiedsViewModel())
    }
}
