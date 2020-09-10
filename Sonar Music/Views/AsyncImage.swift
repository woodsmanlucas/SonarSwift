//
//  AsyncImage.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-24.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader

    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil){
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
        
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View{
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}


