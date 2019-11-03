//
//  ViewController.swift
//  4-Measurement
//
//  Created by Mehmet Tarhan on 15.06.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var plusSign: UILabel!
    
    private var nodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addPlusSign()
        registerGestureRecognizers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Set plane detection
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func addPlusSign() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        label.text = "+"
        label.textAlignment = .center
        label.center = self.view.center
        
        self.view.addSubview(label)
    }
    
    private func registerGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.sceneView.addGestureRecognizer(tap)
    }
    
    @objc private func didTap(_ sender: UIGestureRecognizer) {
        guard let tappedView = sender.view as? ARSCNView else { return }
        let tappedPoint = self.sceneView.center
        let testResults = tappedView.hitTest(tappedPoint, types: .featurePoint)
        guard let testResult = testResults.first else { return }
        
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.gray
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(testResult.worldTransform.columns.3.x,
                                         testResult.worldTransform.columns.3.y,
                                         testResult.worldTransform.columns.3.z)
        
        if self.nodes.count == 2 {
            guard let first = self.nodes.first else { return }
            guard let second = self.nodes.last else { return }
            
            let position = SCNVector3Make(second.position.x - first.position.x,
                                          second.position.y - first.position.y,
                                          second.position.z - first.position.z)
            
            let distance = sqrt(position.x * position.x +
                              position.y * position.y +
                              position.z * position.z)
            
            let displayPosition = SCNVector3((first.position.x + second.position.x) / 2,
                                             (first.position.y + second.position.y) / 2,
                                             (first.position.z + second.position.z) / 2)
            
            self.display(distance: distance, position: displayPosition)
            
        } else {
            self.sceneView.scene.rootNode.addChildNode(sphereNode)
            self.nodes.append(sphereNode)
        }
        
    }
    
    private func display(distance: Float, position: SCNVector3) {
        let text = SCNText(string: "\(distance) m", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.black
        
        let node = SCNNode(geometry: text)
        node.position = position
        node.scale = SCNVector3(0.002, 0.002, 0.002)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        node.constraints = [billboardConstraint]
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}
