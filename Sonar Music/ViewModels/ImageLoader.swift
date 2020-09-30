//
//  ImageLoader.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-24.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

enum LoadState {
    case loading, success, failure
}

class ImageLoader: ObservableObject {
    @Published var data = Data()
    var state = LoadState.loading

    init(url: String) {
        guard let parsedURL = URL(string: url) else {
            fatalError("Invalid URL: \(url)")
        }

        URLSession.shared.dataTask(with: parsedURL) { data, response, error in
            if let data = data, data.count > 0 {
                DispatchQueue.main.async {
                self.data = data
                self.state = .success
                }
            } else {
                DispatchQueue.main.async {
                self.state = .failure
                }
            }

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }.resume()
    }
}
