//
//  StackNavigationBackButton.swift
//  
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI

public struct StackNavigationBackButton<Destination: NavigatorStackValue, Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var navigator: Navigator<Destination>

    let content: () -> Content

    public init(screenType: Destination.Type, content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Button(action: {
            #if os(macOS)
            navigator.goBack()
            #else
            presentationMode.wrappedValue.dismiss()
            #endif
        }) {
            content()
        }
    }
}

#if DEBUG
struct StackNavigationBackButton_Previews: PreviewProvider {
    static var previews: some View {
        StackNavigationBackButton(screenType: PreviewScreenType.self) {
            Text("Go back")
        }
    }
}
#endif
