//
//  Route.swift
//  MySecureX
//
//  Created by Vitald3 on 16.07.2025.
//

import SwiftUI

struct Route: Identifiable, Hashable {
    let screen: Screen
    var view: AnyView?
    let onPop: ((AnyHashable?) -> Void)?

    var id: String {
        screen.id
    }

    init(screen: Screen, view: AnyView? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        self.screen = screen
        self.view = view
        self.onPop = onPop
    }

    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.screen == rhs.screen
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(screen)
    }
}
