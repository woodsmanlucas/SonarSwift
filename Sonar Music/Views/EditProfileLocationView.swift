//
//  EditProfileLocationView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-26.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct EditProfileLocationView: View {
    @ObservedObject var profile: UserViewModel
    
    var body: some View {
        EditProfileLocation(profile: profile)
    }
}

struct EditProfileLocation: View{
    @ObservedObject var lm = LocationManager()
    @ObservedObject var profile: UserViewModel

    var body: some View {
        VStack{
        if(lm.location != nil){
            EditProfileLocationMap(lm: lm, profile: profile)
        Button(action: {
            self.profile.updateLocation()
        }){
            ZStack{
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green)
            Text("Update Location")
            }
        }.buttonStyle(PlainButtonStyle()).frame(width: 200, height: 40)
            }else{
            EditProfileLocationMap(lm: lm, profile: profile)
            Button(action: {
                self.profile.updateLocation()
            }){
                ZStack{
                RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green)
                Text("Update Location")
                }
            }.buttonStyle(PlainButtonStyle()).frame(width: 200, height: 40)
                }
        }
    }
}

struct EditProfileLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileLocationView(profile: UserViewModel("5f3bda80f01ebc00196e8902", jwt: JWT()))
    }
}
