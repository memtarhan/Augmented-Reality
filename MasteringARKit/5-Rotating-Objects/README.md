# Rotating Objects 

#### Rotating Objects Using Euler Angles 

```swift
let node = SCNNode() 
node.eulerAngles = SCNVector3(x, y , x)
```

> By specifying different values for x, y, and z, eulerAngles can define a virtual object’s rotation around the x-, y-, and z-axes. When specifying SCNVector3 values for the x-, y-, and z-axes, make sure you use Float values and that you specify the amount of rotation in radians. We will use GLKit to convert a degree to radain. 

```swift
import GLKit 

let radian = GLKMathDegreesToRadians(degrees)
```



```swift
import GLKit

 private var node = SCNNode()
    
 private var currentX: Float = 0
 private var currentY: Float = 0
 private var currentZ: Float = 0

 @IBAction func xChanged(_ sender: UISlider) {
        currentX = GLKMathDegreesToRadians(sender.value)
        node.eulerAngles = SCNVector3(currentX, currentY, currentZ)
  }
    
  @IBAction func yChanged(_ sender: UISlider) {
        currentY = GLKMathDegreesToRadians(sender.value)
        node.eulerAngles = SCNVector3(currentX, currentY, currentZ)
  }
    
  @IBAction func zChanged(_ sender: UISlider) {
        currentZ = GLKMathDegreesToRadians(sender.value)
        node.eulerAngles = SCNVector3(currentX, currentY, currentZ)
  }
    
  private func showShape() {
        let pyramid = SCNPyramid(width: 0.05, height: 0.1, length: 0.05)
        pyramid.firstMaterial?.diffuse.contents = UIColor.orange
        
        node.geometry = pyramid
        node.position = SCNVector3(0.05, 0.05, -0.05)
        
        sceneView.scene.rootNode.addChildNode(node)
 }
```

