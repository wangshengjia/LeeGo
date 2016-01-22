//
//  View.swift
//  Pods
//
//  Created by Victor WANG on 20/01/16.
//
//

import Foundation

public protocol ComponentViewModelType {

}

public final class ComponentViewModel: ComponentViewModelType {
    var componentView: UIView? = nil
    var configuration: ConfigurationType?

    init() {

    }
}

extension UIView: ComponentType {
    private struct AssociatedKeys {
        static var ComponentViewModelName = "componentViewModel_name"
    }

    var componentViewModel: ComponentViewModel {
        get {
            if let viewModel = objc_getAssociatedObject(self, &AssociatedKeys.ComponentViewModelName) as? ComponentViewModel {
                return viewModel
            } else {
                let viewModel = ComponentViewModel()
                objc_setAssociatedObject(self, &AssociatedKeys.ComponentViewModelName, viewModel as ComponentViewModel?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return viewModel
            }
        }
    }
}
