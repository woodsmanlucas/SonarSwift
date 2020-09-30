//
//  AsyncImage.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-24.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct AsyncImage: View {




    @ObservedObject var loader: ImageLoader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
    }

    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        self.loader = ImageLoader(url: url)
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}



