//
//  ViewController.swift
//  2-Physics
//
//  Created by Mehmet Tarhan on 21.05.2019.
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
        
        // Set debug options:
        //      - Show Feature Points: To see detected surfaces
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        setGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Set plane detections
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func setGestureRecognizers() {
        // Default numberOfTapsRequired is already 1(single)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        // Single tap should wait for double tap if double tap is present
        singleTap.require(toFail: doubleTap)
        
        sceneView.addGestureRecognizer(singleTap)
        sceneView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func didSingleTap(_ sender: UIGestureRecognizer) {
        dlog(self, #function)
        
        guard let sceneView = sender.view as? ARSCNView else { return }
        
        let touchedLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchedLocation, types: .existingPlaneUsingExtent)
        
        if let hitTestResult = hitTestResults.first {
            addBox(onHitTest: hitTestResult)
        }
    }
    
    @objc private func didDoubleTap(_ sender: UIGestureRecognizer) {
        
    }
    
    private func addBox(onHitTest test: ARHitTestResult) {
        dlog(self, #function)

        let box = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellow
        
        let node = SCNNode(geometry: box)
        
        let x = test.worldTransform.columns.3.x
        let y = test.worldTransform.columns.3.y + Float(0.2)
        let z = test.worldTransform.columns.3.z
        
        node.position = SCNVector3(x, y, z)
        
        let physics = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: node, options: [:]))
        physics.categoryBitMask = 1 // A mask that defines which categories this physics body belongs to.
        physics.collisionBitMask = 2 // A mask that defines which categories of physics bodies can collide with this physics body.
        node.physicsBody = physics
            
        sceneView.scene.rootNode.addChildNode(node)
    }
    

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        dlog(self, #function)
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            dlog(self, "anchor is ARPlaneAnchor")

//            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.y))
//            plane.firstMaterial?.diffuse.contents = UIColor.red
//
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//            planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi/2.0), 1.0, 0.0, 0.0)
//
//            let physics = SCNPhysicsBody(type: .static, shape: nil)
//            physics.categoryBitMask = 2 // A mask that defines which categories this physics body belongs to.
//            physics.collisionBitMask = 1 // A mask that defines which categories of physics bodies can collide with this physics body.
//            planeNode.physicsBody = physics
//
//            node.addChildNode(planeNode)
        }
    }
}
