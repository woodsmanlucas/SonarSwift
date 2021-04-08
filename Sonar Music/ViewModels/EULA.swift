//
//  EULA.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2021-04-01.
//  Copyright © 2021 Sonar Music. All rights reserved.
//

import SwiftUI

class Agree: ObservableObject {
    @Published private(set) var agree = false
    
    func Agree() {
        agree = true
    }
}
