//
//  AppAssembly.swift
//  Shapely
//
//  Created by Andrew on 11.02.2023.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CoreData

private class InternalAppAssembly: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(RootNavigationController.self, initializer: RootNavigationController.init)
            .inObjectScope(.container)

        container.register(AppRouterImp.self) { resolver in
            AppRouterImp(rootController: resolver.resolve(RootNavigationController.self)!)
        }
        .implements(AppRouter.self)

        container.register(CalorieCalculator.self) { _ in
            CalorieCalculator()
        }

        container.register(MLService.self) { _ in
            MLService()
        }

        container.autoregister(StorageService.self, initializer: StorageService.init)
    }
}

class AppAssembly: NSObject {
    let container: Container
    fileprivate let assembler: Assembler
    fileprivate var modules: [AppModule]

    static func findSubmodules(_ module: AppModule) -> [AppModule] {
        var submodules: [AppModule] = [module]

        submodules
            .append(contentsOf: module.submodules
                .flatMap(AppAssembly.findSubmodules))

        return submodules
    }

    init(window: UIWindow) {
        container = Container()

        container.register(UIWindow.self) { _ in
            window
        }.inObjectScope(.container)

        assembler = Assembler(container: container)
        assembler.apply(assembly: InternalAppAssembly())

        // Modules list
        modules = [
            LaunchModule(),
            InitialStartModule(),
            MainBarModule()
        ]

        modules = modules.flatMap(AppAssembly.findSubmodules)

        assembler.apply(assemblies: modules.compactMap { $0.createAssembly() })

        super.init()

        container.register(AppAssembly.self) { [unowned self] _ in
            self
        }

        container.register(UIViewController.self, name: "mainController") { resolver in
            let mainCoordinator = MainCoordinator(resolver: resolver)
            return mainCoordinator.mainViewController()
        }

        container.register(NSManagedObjectContext.self) { _ in
            let persistentContainer = NSPersistentContainer(name: "Shapely")
            persistentContainer.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            let context = persistentContainer.viewContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            return context
        }
        .inObjectScope(.container)
    }

    func initializeModules() {
        for module in modules {
            module.initializeModule(resolver: container)
        }
    }
}
