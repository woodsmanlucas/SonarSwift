//
//  EditProfileView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-11.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var profile: ProfileViewModel
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var instrumentsPlayed: [String] = []
    @State var experience: [String] = []
    @State var links: [String] = []
    
    private func isUserInformationValid() -> Bool {
       if username.isEmpty {
           return false
       }
           
           return true
       }
    
    var body: some View {
        VStack{
        Form{
            VStack(alignment: .leading){
            Text("Username:").bold()
            Divider()
            TextField("Username", text: $username)
            Divider()
            Text("First name:").bold()
            Divider()
            TextField("First name", text: $firstName)
            Divider()
            Text("Last name:").bold()
            Divider()
            }
            TextField("Last name", text: $lastName)
            Text("Instruments played and experience:").bold()
            HStack{
                // INSTRUMENTS PLAYED
                VStack{
                    ForEach(0..<instrumentsPlayed.count, id: \.self){
                        index in
                        TextField("Instrument", text: self.$instrumentsPlayed[index])
                    }
                }
                Spacer()
                // EXPERIENCE
                VStack{
                    ForEach(0..<experience.count, id: \.self){
                        index in
                        TextField("Experience", text: self.$experience[index])
                    }
                }
            }
            ZStack{
                RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color.green)
                Text("+").foregroundColor(Color.white)
            }.onTapGesture {
                self.instrumentsPlayed.append("")
                self.experience.append("")
                print(self.instrumentsPlayed)
            }
            Text("Links:").bold()
            VStack{
                ForEach(0..<links.count, id: \.self){
                    index in
                    TextField("Link", text: self.$links[index])
                }
            }
            ZStack{
                RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color.green)
                Text("+").foregroundColor(Color.white)
            }.onTapGesture {
                self.links.append("")
            }
            Button(action: {
                self.profile.EditProfile(username: self.username, firstName: self.firstName, lastName: self.lastName, instrumentsPlayed: self.instrumentsPlayed, experience: self.experience, links: self.links)
                self.presentationMode.wrappedValue.dismiss()

            }, label: {
                Text("Submit")
            })
            
        }.onAppear{
            if(self.profile.profile.count > 0){
                self.username = self.profile.profile[0].username
                print(self.profile.profile[0].username)
                self.firstName = self.profile.profile[0].firstName
                self.lastName = self.profile.profile[0].lastName
                self.instrumentsPlayed = self.profile.profile[0].instrumentsPlayed
                for index in 0..<self.profile.profile[0].experience.count {
                    self.experience.append(String(format: "%f",
                                                  -NSDate(timeIntervalSince1970: TimeInterval(self.profile.profile[0].experience[index]/1000)).timeIntervalSinceNow/31556952))
                }
                self.links = self.profile.profile[0].links
            }
            
            }
        }
    }
}
