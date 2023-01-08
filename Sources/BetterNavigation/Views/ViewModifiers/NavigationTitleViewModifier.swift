//
//  NavigationTitleViewModifier.swift
//  
//
//  Created by Kamaal M Farah on 31/12/2022.
//

import SwiftUI

extension View {
    public func navigationTitle(title: String, displayMode: DisplayMode) -> some View {
        modifier(NavigationTitleViewModifier(title: title, displayMode: displayMode))
    }
}

public enum DisplayMode {
    case large
    case inline

    #if os(iOS)
    var navigationBarItemDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .large:
            return .large
        case .inline:
            return .inline
        }
    }
    #endif
}

private struct NavigationTitleViewModifier: ViewModifier {
    let title: String
    let displayMode: DisplayMode

    init(title: String, displayMode: DisplayMode) {
        self.title = title
        self.displayMode = displayMode
    }

    func body(content: Content) -> some View {
        content
            .navigationTitle(Text(title))
        #if os(iOS)
            .navigationBarTitleDisplayMode(displayMode.navigationBarItemDisplayMode)
        #endif
    }
}
