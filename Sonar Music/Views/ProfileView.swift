//
//  ProfileView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-10.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var user: UserViewModel
    let defaultURL = URL(string: "https://www.sonarmusic.social/profile.png")!
    
    var body: some View {
        
        VStack{
            Spacer()
            if self.user.profile.count > 0 {
                if self.user.profile[0].profilePicUrl != nil {
                AsyncImage(
                    url: URL(string: self.user.profile[0].profilePicUrl!)!,
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
            if(user.jwt.userId == user.userId){
                NavigationLink(destination: EditProfilePictureView(profile: user)){
                    Text("Edit Your Picture")
                }
                
                NavigationLink(destination: EditProfileView(profile: user)){
                    Text("Edit Your Profile")
                }
                
                NavigationLink(destination: EditProfileLocation()){
                    Text("Edit your location")
                }
            }else{
                NavigationLink(destination: RateUser(user: user)){
                    Text("Rate This User")
                }                }
            Text("Username: " + user.profile[0].username)
            HStack{
                Text(user.profile[0].firstName)
                Text(user.profile[0].lastName)
            }
                Text("Instruments Played:")
                HStack{
                    VStack{
                    ForEach(0..<user.profile[0].instrumentsPlayed.count){
                        instrument in
                        Text(self.user.profile[0].instrumentsPlayed[instrument])
                    }
                    }
                    VStack{
                        ForEach(0..<user.profile[0].experience.count){
                            experience in
                            Text(
                                String(format: "%.1f years",
                                       -NSDate(timeIntervalSince1970: TimeInterval(self.user.profile[0].experience[experience]/1000)).timeIntervalSinceNow/31556952))
                        }
                    }
                }
                if(user.profile[0].links.count > 0){
                Text("Links:")
                ForEach(0..<user.profile[0].links.count){
                    link in
                    Text(self.user.profile[0].links[link])
                }
                }
            }
            Spacer()
            Text("Ratings:").bold()
            if(self.user.ratings != nil && self.user.ratings!.data.count > 0){
                HStack{
                    Spacer()
                Text("Average Rating:")
                    Spacer()
                    Text(String(self.user.ratings!.average))
                    Spacer()
                }
                Spacer()
                VStack{
                    ForEach(0..<self.user.ratings!.data.count){
                        index in
                        HStack{
                            Spacer()
                            Text("Rating:")
                            Spacer()
                            Text(String(self.user.ratings!.data[index].rating))
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("Comment:")
                            Spacer()
                            Text(self.user.ratings!.data[index].comments)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }else{
             Text("This user doesn't have any ratings")
            Spacer(minLength: 200)
            }
        }.onAppear{self.user.GetProfile()
            self.user.GetRatings()
        }
    }
}
