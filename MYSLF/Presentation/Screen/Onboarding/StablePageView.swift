//
//  StablePageView.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct StablePageView<Content: View>: View {
    @Binding var selection: Int
    let count: Int
    let content: Content

    init(selection: Binding<Int>, count: Int, @ViewBuilder content: () -> Content) {
        _selection = selection
        self.count = count
        self.content = content()
    }

    var body: some View {
        TabView(selection: $selection) {
            content
                .animation(.easeInOut, value: selection)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .onChange(of: selection) { _ in
            withAnimation(.easeInOut(duration: 0.25)) { }
        }
    }
}
