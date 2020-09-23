//
//  AddImageToClassified.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-23.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct AddImageToClassified: View {
        @ObservedObject var classifieds: ClassifiedsViewModel
    @ObservedObject var jwt: JWT
           @State private var isShowPhotoLibrary = false
           @State private var image = UIImage()
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        
           var body: some View {
               VStack {
        
                   Image(uiImage: self.image)
                       .resizable()
                       .scaledToFill()
                       .frame(width: 300, height: 300)
                       .cornerRadius(300)
        
                   Button(action: {
                       self.isShowPhotoLibrary = true
                   }) {
                       HStack {
                           Image(systemName: "photo")
                               .font(.system(size: 20))
        
                           Text("Photo library")
                               .font(.headline)
                       }
                       .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(20)
                       .padding(.horizontal)
                   }
                
                    Button(action: {
                        self.classifieds.uploadPhoto(self.image, jwt: self.jwt)
    //                    self.presentationMode.wrappedValue.dismiss()
                        }) {
                                   HStack {
                                       Text("Upload as my photo")
                                           .font(.headline)
                                   }
                                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                   .background(Color.green)
                                   .foregroundColor(.white)
                                   .cornerRadius(20)
                                   .padding(.horizontal)
                               }
               }.sheet(isPresented: $isShowPhotoLibrary) {
                   ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
               }    }
}
