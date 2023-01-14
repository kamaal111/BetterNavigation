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

    private let notifications: [Notification.Name] = [
        .navigate
    ]

    init(stack: [StackValue], initialStack: StackValue = .root) {
        let stack = Stack.fromArray(stack)
        self.stacks = [initialStack: stack]
        self.currentStack = initialStack
        setupNotifications()
    }

    deinit {
        removeNotifications()
    }

    public enum NavigatorNotifications {
        case navigate(destination: StackValue)

        var name: Notification.Name {
            switch self {
            case .navigate:
                return .navigate
            }
        }
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

    public static func notify(_ event: NavigatorNotifications) {
        NotificationCenter.default.post(name: event.name, object: event)
    }

    private func setupNotifications() {
        for notification in notifications {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification),
                name: notification,
                object: nil)
        }
    }

    private func removeNotifications() {
        for notification in notifications {
            NotificationCenter.default.removeObserver(self, name: notification, object: nil)
        }
    }

    @objc
    private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .navigate:
            guard let event = notification.object as? NavigatorNotifications,
                  case .navigate(destination: let destination) = event else {
                assertionFailure("Incorrect event sent")
                return
            }

            Task { await navigate(to: destination) }
        default:
            assertionFailure("Unhandled notification")
        }
    }
}

extension Notification.Name {
    static let navigate = makeNotificationName(withKey: "navigate")

    private static func makeNotificationName(withKey key: String) -> Notification.Name {
        Notification.Name("io.kamaal.BetterNavigation.notifications.\(key)")
    }
}
