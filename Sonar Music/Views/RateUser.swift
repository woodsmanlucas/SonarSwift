//
//  RateUser.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-16.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct RateUser: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var user: UserViewModel
    @State var rating: String = ""
    @State var comment: String = ""

    private func isUserInformationValid() -> Bool {
          if self.comment.isEmpty {
                  return false
              }
              
        if self.rating.isEmpty || Double(self.rating) == nil || Double(self.rating)! < 0 || Double(self.rating)! > 5 {
                  return false
              }
              
              return true
    }
    
    var body: some View {
        VStack{
            Form{
                TextField("Rating", text: $rating).keyboardType(.numberPad)
                TextField("Comment", text: $comment)
            
                Button(action: {
                let boolean = self.user.PostRatings(comment: self.comment, rating: self.rating)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   // Excecute after 1 seconds
                if (boolean) {
                    self.presentationMode.wrappedValue.dismiss()
                    }

                    }
                }) {
                Text("Rate User")
            }.disabled(!self.isUserInformationValid())
        }
    }
    }
}
