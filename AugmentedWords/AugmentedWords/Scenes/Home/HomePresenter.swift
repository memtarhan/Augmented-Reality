//
//  HomePresenter.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 29.02.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import Foundation

protocol HomePresenter {
    var view: HomeViewController? { get set }
}

class HomePresenterImpl: HomePresenter {
    var view: HomeViewController?
}
