//
//  ImageLoader.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-24.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    deinit {
        cancel()
    }
    
    private var cancellable: AnyCancellable?

        func load() {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.image = $0 }
        }
        
        func cancel() {
            cancellable?.cancel()
        }
}



