//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan Personal on 11.12.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GLKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var configuration: ARWorldTrackingConfiguration!
    
    private let ninetyDegrees = GLKMathDegreesToRadians(90)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configuration = ARWorldTrackingConfiguration()
        
        // Set detection type
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func refreshDidTap(_ sender: UIBarButtonItem) {
        // Refreshing world tracking and removing all the nodes
        sceneView.scene.rootNode.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        sceneView.session.run(configuration, options: [.resetTracking])
        addTargets()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        
        guard let scene = sender.view as? ARSCNView else { return }
        guard let pointOfView = scene.pointOfView else { return }
        let transfrom = pointOfView.transform
        let orientation = SCNVector3(-transfrom.m31, -transfrom.m32, -transfrom.m33)
        let location = SCNVector3(transfrom.m41, transfrom.m42, transfrom.m43)
        let position = SCNVector3(orientation.x + location.x,
                                  orientation.y + location.y,
                                  orientation.z + location.z)
        
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.3)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = position
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: node, options: nil))
        let force: Float = 50
        let direction = SCNVector3(orientation.x * force,
                                   orientation.y * force,
                                   orientation.z * force)
        node.physicsBody?.applyForce(direction, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(node)
        //        /*
        //            Hit Result
        //         */
        //        guard let scene = sender.view as? ARSCNView else { return }
        //        let tappedLocation = sender.location(in: scene)
        //        let hitTest = scene.hitTest(tappedLocation, types: .existingPlaneUsingExtent)
        //        guard let result = hitTest.first else { return }
        //        addObject(with: result)
    }
    
    private func addObject(with result: ARHitTestResult) {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(result.worldTransform.columns.3.x,
                                   result.worldTransform.columns.3.y,
                                   result.worldTransform.columns.3.z)
        // IMPL: shape: nil
        // ARKit will treat the sphere’s boundaries as its body when calculating collisions with other virtual objects.
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func displayPlane(on anchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        node.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        return node
    }
    
    private func addTargets() {
        let pyramid = SCNNode(geometry: SCNPyramid(width: 4, height: 4.5, length: 4))
        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.systemIndigo
        pyramid.position = SCNVector3(-3, 1, 15)
        pyramid.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        sceneView.scene.rootNode.addChildNode(pyramid)
        
        let box = SCNNode(geometry: SCNBox(width: 3.5, height: 3.5, length: 3.5, chamferRadius: 0))
        box.geometry?.firstMaterial?.diffuse.contents = UIColor.systemGreen
        box.position = SCNVector3(5, 1, -15)
        box.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        sceneView.scene.rootNode.addChildNode(box)
        
        let torus = SCNNode(geometry: SCNTorus(ringRadius: 2, pipeRadius: 0.5))
        torus.geometry?.firstMaterial?.diffuse.contents = UIColor.systemPurple
        torus.position = SCNVector3(0, -2, -15)
        torus.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        torus.physicsBody = SCNPhysicsBody(type: .static,
                                           shape: SCNPhysicsShape(node: torus,
                                                                  options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        let plane = displayPlane(on: anchor as! ARPlaneAnchor)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let plane = displayPlane(on: anchor as! ARPlaneAnchor)
        node.addChildNode(plane)
    }
    
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
