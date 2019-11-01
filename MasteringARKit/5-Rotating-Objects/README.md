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

