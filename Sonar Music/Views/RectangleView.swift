//
//  RectangleView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-30.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct RectangleView<ItemView>: View where ItemView: View {
    var text: String
    var destination: ItemView
    
    init(_ text: String, destination: @escaping () -> ItemView){
        self.text = text
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination){
            ZStack{
                RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color.green)
                Text(text).foregroundColor(Color.white)
            }.frame(width: 200, height: 40)
        }
    }
    
}
