//
//  AppModule.swift
//
//  Created by Anton Selyanin on 3/13/16.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import Swinject

protocol AppModule {
    var submodules: [AppModule] { get }

    func createAssembly() -> Assembly?

    func initializeModule()

    func initializeModule(resolver: Resolver)

    func postInitializeModule(resolver: Resolver)

    func moduleWillRegisterDelegates()
}

extension AppModule where Self: Assembly {
    func createAssembly() -> Assembly? {
        self
    }
}

extension AppModule {
    var submodules: [AppModule] {
        return []
    }

    func createAssembly() -> Assembly? {
        return nil
    }

    func initializeModule() {
        // no-op
    }

    func initializeModule(resolver _: Resolver) {
        initializeModule()
    }

    func postInitializeModule(resolver _: Resolver) {
        // no-op
    }

    func moduleWillRegisterDelegates() {
        // no-op
    }
}
