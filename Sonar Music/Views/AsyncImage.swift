//
//  AsyncImage.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-24.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        placeholder
    }
}
