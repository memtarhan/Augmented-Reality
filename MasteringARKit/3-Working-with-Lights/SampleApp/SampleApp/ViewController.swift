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
    
    let showLight = SCNNode()
    
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
        
        showShape()
        lightOn()
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    @IBAction func temperatureChanged(_ sender: UISlider) {
        let temperature = CGFloat(sender.value)
        print("temperatureChanged -> \(temperature)")
        showLight.light?.temperature = temperature
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        let intensity = CGFloat(sender.value)
        print("intensityChanged -> \(intensity)")
        showLight.light?.intensity = intensity
    }
    
    @IBAction func colorChanged(_ sender: UIButton) {
        let color = sender.backgroundColor ?? UIColor.black
        print("colorChanged -> \(color)")
        showLight.light?.color = color
    }
    
    private func showShape() {
        let sphere = SCNSphere(radius: 0.03)
        sphere.firstMaterial?.diffuse.contents = UIColor.white
        
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(0.1, 0, 0)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func lightOn() {
        showLight.light = SCNLight()
        // showLight.light?.type = .omni
        // showLight.light?.type = .directional
        showLight.light?.type = .spot
        showLight.light?.color = UIColor(white: 0.6, alpha: 1.0)
        showLight.position = SCNVector3(0, 0, 0)
        
        sceneView.scene.rootNode.addChildNode(showLight)
    }
}
