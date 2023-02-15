//
//  Command.swift
//
//  Created by Anisov Aleksey on 4/26/18.
//  Copyright © 2018 Anisov Aleksey. All rights reserved.
//

public final class CommandWith<T> {
    private let commandClosure: (T) -> Void

    public init(closure: @escaping (T) -> Void) {
        commandClosure = closure
    }

    public init() {
        commandClosure = { _ in }
    }

    public func execute(with param: T) {
        commandClosure(param)
    }
}

public typealias Command = CommandWith<Void>

public extension CommandWith where T == Void {
    func execute() {
        execute(with: ())
    }

    static func create<Object: AnyObject>(from owner: Object, _ block: @escaping (Object) -> () -> Void) -> Command {
        return CommandWith { [weak owner] _ in
            guard let this = owner else {
                return
            }
            block(this)()
        }
    }
}

public extension CommandWith {
    static func create<Object: AnyObject>(from owner: Object, _ block: @escaping (Object) -> (T) -> Void) -> CommandWith<T> {
        return CommandWith { [weak owner] in
            guard let this = owner else {
                return
            }
            block(this)($0)
        }
    }

    static var empty: CommandWith<T> {
        return CommandWith { _ in }
    }
}
