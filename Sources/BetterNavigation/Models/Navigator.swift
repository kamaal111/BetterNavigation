//
//  Navigator.swift
//  
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import SwiftStructures

public final class Navigator<StackValue: NavigatorStackValue>: ObservableObject {
    @Published private var stacks: [StackValue: Stack<StackValue>]
    @Published var currentStack: StackValue

    init(stack: [StackValue], initialStack: StackValue = .root) {
        let stack = Stack.fromArray(stack)
        self.stacks = [initialStack: stack]
        self.currentStack = initialStack
    }

    var currentScreen: StackValue? {
        stacks[currentStack]?.peek()
    }

    var screens: [StackValue] {
        Array(StackValue.allCases)
    }

    @MainActor
    func changeStack(to stack: StackValue) {
        guard currentStack != stack else { return }

        if stacks[stack] == nil {
            stacks[stack] = Stack()
        }
        currentStack = stack
    }

    /// Navigates to the given destination.
    ///
    /// WARNING: This method only works on macOS.
    /// - Parameter destination: Where to navigate to.
    @MainActor
    public func navigate(to destination: StackValue) {
        #if !os(macOS)
        assertionFailure("This method is only supported on macOS")
        #else
        withAnimation { stacks[currentStack]?.push(destination) }
        #endif
    }

    /// Navigates back.
    ///
    /// WARNING: This method only works on macOS.
    @MainActor
    public func goBack() {
        #if !os(macOS)
        assertionFailure("This method is only supported on macOS")
        #else
        withAnimation { _ = stacks[currentStack]?.pop() }
        #endif
    }
}
