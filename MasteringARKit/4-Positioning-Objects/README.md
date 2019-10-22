# Positioning Object 

> Virtual objects appear in an augmented reality view when x, y and z coordinates are specified. Such virtual objects remain fixed in place unless world origin is reset so they appear based on the new world origin's location.



#### Showing a shape at a specific coordinate

```swift
private func showShape() {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.2, 0.1, -0.1)
        
        sceneView.scene.rootNode.addChildNode(node)
}
```



#### Showing shapes with relative positions 

```swift
private func showShape() {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        box.firstMaterial?.diffuse.contents = UIColor.green
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(-0.4, -0.3, 0.2)
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.2, 0.1, -0.1)
        sceneView.scene.rootNode.addChildNode(node)
        
        node.addChildNode(boxNode)
}
```

