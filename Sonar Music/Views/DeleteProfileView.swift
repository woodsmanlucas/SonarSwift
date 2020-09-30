//
//  DeleteProfileView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-27.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct DeleteProfileView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var user: UserViewModel
    
    var body: some View {
        VStack{
        Text("Are you sure you want to delete your Profile?")
            Button(action: {self.user.DeleteProfile()
                self.presentation.wrappedValue.dismiss()
                self.user.jwt.logout()
            }){
                Text("Yes")
            }
        Button(action: {self.presentation.wrappedValue.dismiss()}){
            Text("No")
        }
        }
    }
}

struct DeleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileView(user: UserViewModel("5f3bda80f01ebc00196e8902", jwt: JWT()))
    }
}
