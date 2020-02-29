//
//  HomePresenter.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 29.02.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

protocol HomePresenter {
    var view: HomeViewController? { get set }
    
    func present(string: String)
    func presentAnimations(for node: SCNNode)
}

class HomePresenterImpl: HomePresenter {
    var view: HomeViewController?
    
    func present(string: String) {
        let text = SCNText(string: string, extrusionDepth: 1)
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        text.flatness = 1
        text.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        text.firstMaterial?.diffuse.contents = UIColor.systemRed
        let node = SCNNode(geometry: text)
        node.position = SCNVector3(0, 0 , -0.5)
        node.scale = SCNVector3(0.005, 0.005, 0.005)
        
        view?.display(node: node)
    }
    
    func presentAnimations(for node: SCNNode) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 100
        node.position.z = -100
        SCNTransaction.commit()
        //node.removeFromParentNode()
    }
}
