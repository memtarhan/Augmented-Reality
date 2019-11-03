# Interacting with Augmented Reality 

### Scaling with the Pinch Touch Gesture 

> The pinch gesture is a common touch gesture for zooming in or out of an image displayed on the screen, such as while looking at a digital photograph. Likewise, this same pinch gesture can be used to scale the virtual plane that appears in the augmented reality view.

Touch gestures consist of three states:

* **.began**: Occurs when the app first detects a specific touch gesture 
* **.changed**: Occurs while the touch gesture is still going on
* **.ended**: Occurs when the app detects that the touch gesture stopped 

```swift
@IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            guard let pinchedView = sender.view as? ARSCNView else { return }
            let pinchedCoordinates = sender.location(in: pinchedView)
            let hitTestResults = sceneView.hitTest(pinchedCoordinates, options: nil)
            
            if let result = hitTestResults.first {
                print("\(#function) pinched a virtual object")
                let plane = result.node
                
                let scaleX = Float(sender.scale) * plane.scale.x
                let scaleY = Float(sender.scale) * plane.scale.y
                let scaleZ = Float(sender.scale) * plane.scale.z
                
                plane.scale = SCNVector3(scaleX, scaleY, scaleZ)
                
                sender.scale = 1
            }
        }
    }
```



### Rotating with the Rotation Touch Gesture 

```swift
private var newAngleZ: Float = 0.0
private var currentAngleZ: Float = 0.0

@IBAction func didRotate(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .changed {
            guard let touchedView = sender.view as? ARSCNView else { return }
            let touchedCoordinates = sender.location(in: touchedView)
            let hitTestResults = sceneView.hitTest(touchedCoordinates, options: nil)
            if let result = hitTestResults.first {
                print("\(#function) rotated a virtual object")
                let plane = result.node
                
                newAngleZ = Float(-sender.rotation)
                newAngleZ += currentAngleZ
                
                plane.eulerAngles.z = newAngleZ
            }
            
        } else if sender.state == .ended {
            currentAngleZ = newAngleZ
        }
    }
```



### Moving Virtual Objects with the Pan Gesture 

```swift
@IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        guard let pannedView = sender.view as? ARSCNView else { return }
        let pannedCoordinates = sender.location(in: pannedView)
        let hitTestResults = sceneView.hitTest(pannedCoordinates, options: nil)
        if let result = hitTestResults.first {
            print("\(#function) panned a virtual object")
            if let plane = result.node.parent {
                if sender.state == .changed {
                    let translation = sender.translation(in: pannedView)
                    plane.localTranslate(by: SCNVector3(translation.x/10000, -translation.y/10000, 0.0))
                }
            }
        }
    }
```

