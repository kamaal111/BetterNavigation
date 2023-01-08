//
//  NavigationStackView.swift
//  
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import SalmonUI

public struct NavigationStackView<Root: View, SubView: View, Sidebar: View, Screen: NavigatorStackValue>: View {
    @ObservedObject private var navigator: Navigator<Screen>

    let root: (Screen) -> Root
    let subView: (Screen) -> SubView
    let sidebar: () -> Sidebar

    public init(
        stack: [Screen],
        @ViewBuilder root: @escaping (Screen) -> Root,
        @ViewBuilder subView: @escaping (Screen) -> SubView,
        @ViewBuilder sidebar: @escaping () -> Sidebar) {
            self.root = root
            self.subView = subView
            self.sidebar = sidebar
            self._navigator = ObservedObject(wrappedValue: Navigator(stack: stack))
        }

    public var body: some View {
        #if os(macOS)
        NavigationView {
            sidebar()
            KJustStack {
                switch navigator.currentScreen {
                case .none:
                    root(navigator.currentStack)
                case .some(let unwrapped):
                    subView(unwrapped)
                        .id(unwrapped)
                        .transition(.move(edge: .trailing))
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button(action: { navigator.goBack() }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                }
            }
        }
        .environmentObject(navigator)
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationView {
                sidebar()
                root(navigator.currentStack)
            }
            .environmentObject(navigator)
        } else {
            TabView(selection: $navigator.currentStack) {
                ForEach(navigator.screens, id: \.self) { screen in
                    NavigationView {
                        root(screen)
                    }
                    .navigationViewStyle(.stack)
                    .tabItem {
                        Image(systemName: screen.imageSystemName)
                        Text(screen.title)
                    }
                    .tag(screen)
                }
            }
            .environmentObject(navigator)
        }
        #endif
    }
}

#if DEBUG
struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView(
            stack: [] as [PreviewScreenType],
            root: { _ in Text("22") },
            subView: { screen in Text("s") },
            sidebar: { Text("Sidebar") })
    }
}
#endif
