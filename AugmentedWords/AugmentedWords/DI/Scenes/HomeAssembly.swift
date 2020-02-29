//
//  HomeAssembly.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 29.02.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import Foundation
import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { r in
            let view = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            var presenter = r.resolve(HomePresenter.self)!

            presenter.view = view
            view.presenter = presenter

            return view
        }

        container.register(HomePresenter.self) { _ in
            HomePresenterImpl()
        }
    }
}
