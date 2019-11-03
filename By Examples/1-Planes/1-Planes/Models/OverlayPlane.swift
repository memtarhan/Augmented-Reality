//
//  OverlayPlane.swift
//  1-Planes
//
//  Created by Mehmet Tarhan on 19.05.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class OverlayPlane: SCNNode {
    
    var anchor: ARPlaneAnchor
    var plane: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor: ARPlaneAnchor) {
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.y)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    }
    
    func setup() {
        plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.y))
        plane.firstMaterial?.diffuse.contents = UIColor.red
        
        let node = SCNNode(geometry: plane)
        node.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z)
        node.transform = SCNMatrix4MakeRotation(Float(-.pi/2.0), 1.0, 0.0, 0.0)
        
        // Add the node to parent
        addChildNode(node)
    }
}
