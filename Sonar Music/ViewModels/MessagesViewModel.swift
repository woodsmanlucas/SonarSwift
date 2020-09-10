//
//  MessagesViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-29.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct Conversation {
    var subject: String
    var to: String
}

class InboxViewModel: ObservableObject {
    @Published private(set) var conversations: [Conversation] = []
    
    func getConversations() {
        
    }
}
