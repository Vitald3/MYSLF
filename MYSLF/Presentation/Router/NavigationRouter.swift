//
//  NavigationRouter.swift
//  SecureX
//
//  Created by Vitald3 on 23.06.2025.
//

import Foundation
import SwiftUI
import Combine

enum Screen: String, Identifiable, Hashable {
    case splash, empty, login, welcome, personal, coach, about, camera, home

    var id: String { self.rawValue }
    
    var isDynamic: Bool {
        switch self {
        case .empty:
            return true
        default:
            return false
        }
    }
}

final class NavigationRouter: ObservableObject {
    @Published var path: [Route] = [] {
        didSet {
            let currentId = path.last?.screen.id
            CustomTextFieldCoordinator.shared.setCurrentScreen(currentId)
        }
    }
    @Published var prevRouter: Screen? = nil
    @Published var presentedSheet: Route?
    @Published var presentedFullScreen: Route?
    @Published var presentedDialog: CustomDialog?
    
    private var cachedViewModels: [String: Any] = [:]
    private var parameters: [String: AnyHashable] = [:]
    
    func getOrCreateViewModel<T>(_ key: String, factory: () -> T) -> T {
        if let existing = cachedViewModels[key] as? T {
            return existing
        }
        let newViewModel = factory()
        cachedViewModels[key] = newViewModel
        return newViewModel
    }
    
    @MainActor
    private func clearViewModels(_ key: String) {
        DispatchQueue.main.async { [self] in
            cachedViewModels.removeValue(forKey: key)
        }
    }
    
    @MainActor
    func push<T: Hashable>(_ screen: Screen, with data: T? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            
            if let data {
                parameters[screen.id] = data
            }
            clearViewModels(screen.id)
            path.append(Route(screen: screen, onPop: onPop))
        }
    }

    @MainActor
    func push<V: View>(_ screen: Screen, view: V, with data: AnyHashable? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            
            if let data {
                parameters[screen.id] = data
            }
            clearViewModels(screen.id)
            let route = Route(screen: screen, view: AnyView(view), onPop: onPop)
            path.append(route)
        }
    }
    
    @MainActor
    func push(_ screen: Screen, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            
            clearParameter(for: screen)
            clearViewModels(screen.id)
            path.append(Route(screen: screen, onPop: onPop))
        }
    }
    
    @MainActor
    func replace<T: Hashable>(_ screen: Screen, with data: T? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            let pop = path.last?.onPop
            
            if let data {
                parameters[screen.id] = data
            }
            
            clearViewModels(screen.id)
            CustomTextFieldCoordinator.shared.clearScreen(path.last?.id ?? "")
            
            if !path.isEmpty {
                path.removeLast()
            }
            path.append(Route(screen: screen, onPop: onPop ?? pop))
        }
    }
    
    @MainActor
    func replace<V: View, T: Hashable>(_ screen: Screen, view: V? = nil, with data: T? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            let pop = path.last?.onPop
            
            if let data {
                parameters[screen.id] = data
            }
            
            let renderedView = view.map { AnyView($0) }
            let route = Route(screen: screen, view: renderedView, onPop: onPop ?? pop)
            clearViewModels(screen.id)
            CustomTextFieldCoordinator.shared.clearScreen(path.last?.id ?? "")
            if !path.isEmpty {
                path.removeLast()
            }
            path.append(route)
        }
    }
    
    @MainActor
    func replace(_ screen: Screen, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            let pop = path.last?.onPop
            
            clearParameter(for: screen)
            clearViewModels(screen.id)
            CustomTextFieldCoordinator.shared.clearScreen(path.last?.id ?? "")
            if !path.isEmpty {
                path.removeLast()
            }
            path.append(Route(screen: screen, onPop: onPop ?? pop))
        }
    }
    
    @MainActor
    func parameter<T: Hashable>(as type: T.Type) -> T? {
        guard let screen = path.last else { return nil }
        return parameters[screen.id] as? T
    }
    
    @MainActor
    func clearParameter(for screen: Screen) {
        DispatchQueue.main.async { [self] in
            parameters.removeValue(forKey: screen.id)
        }
    }

    @MainActor
    func pop(_ update: Bool? = false, popData: AnyHashable? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = nil
            
            guard path.count > 1 else { return }
            
            let lastRoute = path.last
            
            clearParameter(for: path.last?.screen ?? .splash)
            clearViewModels(path.last?.screen.id ?? "splash")
            
            if let update = update, update {
                clearViewModels(path[path.count - 2].screen.id)
            }
            
            CustomTextFieldCoordinator.shared.clearScreen(path.last?.id ?? "")
            path.removeLast()
            
            if update == false {
                lastRoute?.onPop?(popData)
            }
        }
    }
    
    @MainActor
    func reset<T: Hashable>(_ screen: Screen, with data: T? = nil, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            
            if let data {
                parameters[screen.id] = data
            }
            
            clearViewModels(screen.id)
            CustomTextFieldCoordinator.shared.clearAll()
            path = [Route(screen: screen, onPop: onPop ?? path.last?.onPop)]
        }
    }
    
    @MainActor
    func reset<V: View, T: Hashable>(
        _ screen: Screen,
        view: V? = nil,
        with data: T? = nil,
        onPop: ((AnyHashable?) -> Void)? = nil
    ) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            
            if let data {
                parameters[screen.id] = data
            }
            
            clearViewModels(screen.id)
            
            let renderedView = view.map { AnyView($0) }
            let route = Route(screen: screen, view: renderedView, onPop: onPop ?? path.last?.onPop)
            
            CustomTextFieldCoordinator.shared.clearAll()
            self.path = [route]
        }
    }
    
    @MainActor
    func reset(_ screen: Screen = .splash, onPop: ((AnyHashable?) -> Void)? = nil) {
        DispatchQueue.main.async { [self] in
            prevRouter = path.last?.screen
            parameters[screen.id] = [:] as? AnyHashable
            clearViewModels(screen.id)
            CustomTextFieldCoordinator.shared.clearAll()
            self.path = [Route(screen: screen, onPop: onPop ?? path.last?.onPop)]
        }
    }
    @MainActor
    func showSheet(_ screen: Screen) {
        DispatchQueue.main.async { [self] in
            presentedSheet = Route(screen: screen)
        }
    }
    @MainActor
    func showSheet<V: View>(_ screen: Screen, _ view: V? = nil) {
        let renderedView = view.map { AnyView($0) }
        let route = Route(screen: screen, view: renderedView)
        
        DispatchQueue.main.async { [self] in
            presentedSheet = route
        }
    }
    @MainActor
    func dismissSheet() {
        DispatchQueue.main.async { [self] in
            presentedSheet = nil
        }
    }
    @MainActor
    func showFullScreen(_ screen: Screen) {
        DispatchQueue.main.async { [self] in
            presentedFullScreen = Route(screen: screen)
        }
    }
    @MainActor
    func showFullScreen<V: View>(_ screen: Screen, _ view: V? = nil) {
        let renderedView = view.map { AnyView($0) }
        let route = Route(screen: screen, view: renderedView)
        
        DispatchQueue.main.async { [self] in
            presentedFullScreen = route
        }
    }
    @MainActor
    func dismissFullScreen() {
        DispatchQueue.main.async { [self] in
            presentedFullScreen = nil
        }
    }
    @MainActor
    func showDialog(title: String, message: String, actions: [CustomDialogAction]) {
        DispatchQueue.main.async { [self] in
            presentedDialog = CustomDialog(
                title: title,
                message: message,
                actions: actions
            )
        }
    }
    @MainActor
    func dismissDialog() {
        DispatchQueue.main.async { [self] in
            presentedDialog = nil
        }
    }
}
