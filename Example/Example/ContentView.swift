//
//  ContentView.swift
//  Example
//
//  Created by Kamaal M Farah on 14/01/2023.
//

import SwiftUI
import SalmonUI
import BetterNavigation

struct ContentView: View {
    var body: some View {
        NavigationStackView(
            stack: [] as [Screens],
            root: { screen in MainView(screen: screen) },
            subView: { screen in MainView(screen: screen, displayMode: .inline) },
            sidebar: { Sidebar() })
    }
}

struct HomeScreen: View {
    var body: some View {
        Text("Home")
    }
}

struct MainView: View {
    let screen: Screens
    let displayMode: DisplayMode

    init(screen: Screens, displayMode: DisplayMode = .large) {
        self.screen = screen
        self.displayMode = displayMode
    }


    var body: some View {
        KJustStack {
            switch screen {
            case .home:
                HomeScreen()
            }
        }
        .navigationTitle(title: screen.title, displayMode: displayMode)
    }
}

struct Sidebar: View {
    var body: some View {
        List {
            Section("Scenes") {
                ForEach(Screens.allCases.filter(\.isSidebarItem), id: \.self) { screen in
                    StackNavigationChangeStackButton(destination: screen) {
                        Label(screen.title, systemImage: screen.imageSystemName)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        #if os(macOS)
        .toolbar(content: {
            Button(action: toggleSidebar) {
                Label("Toggle sidebar", systemImage: "sidebar.left")
                    .foregroundColor(.accentColor)
            }
        })
        #endif
    }

    #if os(macOS)
    private func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        firstResponder.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

enum Screens: Hashable, Codable, CaseIterable, NavigatorStackValue {
    case home

    var title: String {
        switch self {
        case .home:
            return "Home"
        }
    }

    var imageSystemName: String {
        switch self {
        case .home:
            return "house.fill"
        }
    }

    var isTabItem: Bool {
        switch self {
        case .home:
            return true
        }
    }

    var isSidebarItem: Bool {
        switch self {
        case .home:
            return true
        }
    }

    static let root: Screens = .home
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
