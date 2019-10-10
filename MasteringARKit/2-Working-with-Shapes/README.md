# Working with Shapes in ARKit

### Showing Feature Points inARKit

#### Debug options 

> - **World Origin**: Showing x-, y- and z-axes based on the iOS device's current location 
> - **Feature Points**: Showing feature points (i.e objects, planes)  



#### Session run options 

> * **removeExistingAnchors**: Removing any invisible anchors defining the position of virtual objects 
> * **resetTracking**: Resetting world tracking 



```swift
@IBOutlet var sceneView: ARSCNView!
    
private var configuration: ARWorldTrackingConfiguration!

 override func viewDidLoad() {
      super.viewDidLoad()
   
      sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
 }
// MARK: - Resetting the World Origin
private func resetWorldOrigin() {
     sceneView.session.pause()
     sceneView.session.run(configuration, options: [.resetTracking])
}
```



### Displaying Different Geometric Shapes 

#### Geometric Shapes 

> * SCNFloor
> * SCNBox
> * SCNCapsule
> * SCNCone
> * SCNCylinder
> * SCNPlane
> * SCNPyramid
> * SCNTorus
> * SCNTube



```swift
 private func createShape(with type: ShapeType) -> SCNNode {
        // Create geometry w/ given type
        var geometry: SCNGeometry!
        switch type {
        case .box:
            geometry = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        default:
            geometry = SCNSphere(radius: 0.3)
        }
        // Set looks of the box
        geometry.firstMaterial?.diffuse.contents = UIColor.purple
        
        // Create a node w/ that box
        let node = SCNNode(geometry: geometry)
        // Set name of the node
        node.name = type.name
        
        return node
    }
```



### Displaying Text 

> Besides displaying geometric shapes, you can display texts in ARKit with defining a string along with text's font, size and color. 

```swift
let text = SCNText(string: "ARKit is Awesome", extrusionDepth: 1)
```

> The extrusion depth defines thickness of the letters. It is in meters. 

```swift
private func createText(with string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.purple
        text.materials = [material]
        
        let node = SCNNode()
        node.geometry = text
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        
        return node
}
```

