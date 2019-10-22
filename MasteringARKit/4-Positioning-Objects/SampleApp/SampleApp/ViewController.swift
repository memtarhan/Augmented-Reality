//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 16.10.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        showShape()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

//    private func showShape() {
//        let sphere = SCNSphere(radius: 0.05)
//        sphere.firstMaterial?.diffuse.contents = UIColor.orange
//
//        let node = SCNNode()
//        node.geometry = sphere
//        node.position = SCNVector3(0.2, 0.1, -0.1)
//
//        sceneView.scene.rootNode.addChildNode(node)
//    }
    
//    private func showShape() {
//        let sphere = SCNSphere(radius: 0.05)
//        sphere.firstMaterial?.diffuse.contents = UIColor.orange
//
//        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
//        box.firstMaterial?.diffuse.contents = UIColor.green
//
//        let boxNode = SCNNode()
//        boxNode.geometry = box
//        boxNode.position = SCNVector3(-0.4, -0.3, 0.2)
//
//        let node = SCNNode()
//        node.geometry = sphere
//        node.position = SCNVector3(0.2, 0.1, -0.1)
//        sceneView.scene.rootNode.addChildNode(node)
//
//        node.addChildNode(boxNode)
//    }
    
    // MARK: - Showing snowman
    private func showShape() {
        let sphere = SCNSphere(radius: 0.04)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.05, 0.05, -0.05)
        sceneView.scene.rootNode.addChildNode(node)
        
        let middleSphere = SCNSphere(radius: 0.03)
        middleSphere.firstMaterial?.diffuse.contents = UIColor.blue
        
        let middleNode = SCNNode()
        middleNode.geometry = middleSphere
        middleNode.position = SCNVector3(0, 0.06, 0)
        node.addChildNode(middleNode)
        
        let topSphere = SCNSphere(radius: 0.02)
        topSphere.firstMaterial?.diffuse.contents = UIColor.white
        
        let topNode = SCNNode()
        topNode.geometry = topSphere
        topNode.position = SCNVector3(0, 0.04, 0)
        middleNode.addChildNode(topNode)
        
        // Creating hat
        let hatRim = SCNCylinder(radius: 0.03, height: 0.002)
        hatRim.firstMaterial?.diffuse.contents = UIColor.blue
        
        let rimNode = SCNNode()
        rimNode.geometry = hatRim
        rimNode.position = SCNVector3(0, 0.016, 0)
        topNode.addChildNode(rimNode)
        
        let hatTop = SCNCylinder(radius: 0.015, height: 0.025)
        hatTop.firstMaterial?.diffuse.contents = UIColor.black
        
        let hatNode = SCNNode()
        hatNode.geometry = hatTop
        hatNode.position = SCNVector3(0, 0.01, 0)
        rimNode.addChildNode(hatNode)
    }
}
