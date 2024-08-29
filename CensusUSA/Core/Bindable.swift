//
//  Bindable.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//

import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

class Bindable<T> {

    typealias Listener = ((T) -> Void)

    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bind<Target: AnyObject>(to target: Target, with observer: @escaping (Target, T) -> Void) {
        listener = { [weak target] input in
            guard let target = target else { return }
            observer(target, input)
        }
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func unbind() {
        listener = nil
    }
}

extension Bindable where T == Void {
    convenience init() {
        self.init(())
    }
    
    func send() {
        listener?(())
    }
}


