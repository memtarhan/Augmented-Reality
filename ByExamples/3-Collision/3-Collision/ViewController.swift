//
//  ViewController.swift
//  3-Collision
//
//  Created by Mehmet Tarhan on 28.05.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var lastContactedNode: SCNNode?
    
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
        
        // Set the scene's contact delegate
        sceneView.scene.physicsWorld.contactDelegate = self
        
        setGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        addTargets()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Setting gesture recognizers
    private func setGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapShoot))
        sceneView.addGestureRecognizer(tap)
    }
    
    // MARK: - Adding targets
    private func addTargets() {
        let box1 = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        box1.firstMaterial?.diffuse.contents = UIColor.red
        let boxNode1 = SCNNode(geometry: box1)
        boxNode1.position = SCNVector3(0, 0, -0.5)
        boxNode1.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box1, options: nil))
        boxNode1.physicsBody?.categoryBitMask = BodyType.target.rawValue
        boxNode1.physicsBody?.contactTestBitMask = BodyType.bullet.rawValue
        boxNode1.name = "target"
        
        sceneView.scene.rootNode.addChildNode(boxNode1)
        
        let box2 = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        box2.firstMaterial?.diffuse.contents = UIColor.green
        let boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3(-0.5, 0, -0.5)
        boxNode2.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box2, options: nil))
        boxNode2.physicsBody?.categoryBitMask = BodyType.target.rawValue
        boxNode2.physicsBody?.contactTestBitMask = BodyType.bullet.rawValue
        boxNode2.name = "target"
        
        sceneView.scene.rootNode.addChildNode(boxNode2)
        
        let box3 = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        box3.firstMaterial?.diffuse.contents = UIColor.blue
        let boxNode3 = SCNNode(geometry: box3)
        boxNode3.position = SCNVector3(0.5, 0, -0.5)
        boxNode3.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box3, options: nil))
        boxNode3.physicsBody?.categoryBitMask = BodyType.target.rawValue
        boxNode3.physicsBody?.contactTestBitMask = BodyType.bullet.rawValue
        boxNode3.name = "target"
        
        sceneView.scene.rootNode.addChildNode(boxNode3)
    }
    
    // MARK: - Shooting action
    @objc private func didTapShoot(_ sender: UIGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        var traslation = matrix_identity_float4x4
        traslation.columns.3.z = -0.3
        
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = UIColor.yellow
        
        let node = SCNNode(geometry: sphere)
        
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, traslation)
        node.name = "bullet"
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: sphere, options: nil))
        node.physicsBody?.categoryBitMask = BodyType.bullet.rawValue
        node.physicsBody?.contactTestBitMask = BodyType.target.rawValue
        
        let forceVector = SCNVector3(node.worldFront.x * 2, node.worldFront.y * 2, node.worldFront.z * 2)
        node.physicsBody?.applyForce(forceVector, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    // MARK: - SCNPhysicsContactDelegate
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("physicsWorld-didBegin contact")
        
        if self.lastContactedNode == nil {
            if contact.nodeA.name == "target" {
                self.lastContactedNode = contact.nodeA
                
            } else if contact.nodeB.name == "target" {
                self.lastContactedNode = contact.nodeB
            }
            self.lastContactedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        } else {
            self.lastContactedNode = nil
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

enum BodyType: Int {
    // ATTENTION: - Values should be different than 0
    case target = 1
    case bullet = 2
}
