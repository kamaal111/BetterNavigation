//
//  Navigator.swift
//  
//
//  Created by Kamaal M Farah on 26/12/2022.
//

import SwiftUI
import SwiftStructures

final class Navigator<StackValue: NavigatorStackValue>: ObservableObject {
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

    @MainActor
    func navigate(to destination: StackValue) {
        withAnimation { stacks[currentStack]?.push(destination) }
    }

    @MainActor
    func goBack() {
        withAnimation { _ = stacks[currentStack]?.pop() }
    }
}
