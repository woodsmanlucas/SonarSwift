//
//  ProfileView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-10.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profile: ProfileViewModel
    let defaultURL = URL(string: "https://www.sonarmusic.social/profile.png")!
    
    var body: some View {
        
        VStack{
            if self.profile.profile.count > 0 {
                if self.profile.profile[0].profilePicUrl != nil {
                AsyncImage(
                    url: URL(string: self.profile.profile[0].profilePicUrl!)!,
                    placeholder: Text("Loading ...")
                ).aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            else {
                                AsyncImage(
                    url: self.defaultURL,
                    placeholder: Text("Loading ...")
                ).aspectRatio(contentMode: .fit)
                .frame(width:100, height: 100)
            }
            if(profile.jwt.userId == profile.userId){
                NavigationLink(destination: EditProfileView(profile: profile)){
                    Text("Edit Your Profile")
                }
            }
            Text("Username: " + profile.profile[0].username)
            HStack{
                Text(profile.profile[0].firstName)
                Text(profile.profile[0].lastName)
            }
                Text("Instruments Played:")
                HStack{
                    VStack{
                    ForEach(0..<profile.profile[0].instrumentsPlayed.count){
                        instrument in
                        Text(self.profile.profile[0].instrumentsPlayed[instrument])
                    }
                    }
                    VStack{
                        ForEach(0..<profile.profile[0].experience.count){
                            experience in
                            Text(
                                String(format: "%.1f years",
                                       -NSDate(timeIntervalSince1970: TimeInterval(self.profile.profile[0].experience[experience]/1000)).timeIntervalSinceNow/31556952))
                        }
                    }
                }
                Text("Links:")
                ForEach(0..<profile.profile[0].links.count){
                    link in
                    Text(self.profile.profile[0].links[link])
                }
            }
        }.onAppear{self.profile.GetProfile()}
    }
}
