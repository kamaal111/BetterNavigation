//
//  NavigatorStackValue.swift
//  
//
//  Created by Kamaal M Farah on 04/01/2023.
//

import Foundation

public protocol NavigatorStackValue: Codable, Hashable, CaseIterable {
    var isTabItem: Bool { get }
    var imageSystemName: String { get }
    var title: String { get }

    static var root: Self { get }
}

#if DEBUG
enum PreviewScreenType: NavigatorStackValue, Equatable {
    case screen
    case sub

    var isTabItem: Bool { true }
    var isSidebarItem: Bool { true }
    var imageSystemName: String { "person" }
    var title: String { "Screen" }

    static let root: Self = .screen
}
#endif
