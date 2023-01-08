//
//  SwiftUIView.swift
//  
//
//  Created by Kamaal M Farah on 03/01/2023.
//

import SwiftUI

public struct StackNavigationChangeStackButton<Content: View, Destination: NavigatorStackValue>: View {
    @EnvironmentObject private var navigator: Navigator<Destination>

    let destination: Destination
    let content: () -> Content

    public init(
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content) {
            self.destination = destination
            self.content = content
        }

    public var body: some View {
        Button(action: { navigator.changeStack(to: destination) }) {
            content()
        }
    }
}

#if DEBUG
struct StackNavigationChangeStackButton_Previews: PreviewProvider {
    static var previews: some View {
        StackNavigationChangeStackButton(destination: PreviewScreenType.screen) {
            Text("Yes")
        }
    }
}
#endif
