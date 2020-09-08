//
//  MenuView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-30.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    let Classifieds = ClassifiedsViewModel()

    
    var body: some View {
        VStack{
        RectangleView("Inbox"){InboxView()   }
            RectangleView("View Classifieds List"){ClassifiedsView(viewModel: self.Classifieds)}
            RectangleView("View Classifieds Map"){ClassifiedMapView(classifieds: self.Classifieds.classifieds)}
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
