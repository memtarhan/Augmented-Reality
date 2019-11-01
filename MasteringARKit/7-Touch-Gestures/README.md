# Touch Gestures in ARKit

##### Available Gestures 

- **Tap**: A brief touch on the screen before lifting the finger up
- **Long press**: Press a finger on the screen and hold it for a period of time 
- **Swipe**: Slide a finger left or right across an area 
- **Pan**: Press a finger on the screen and then slide it across the screen 
- **Pinch**: A two-finger gesture that moves the two fingertips closer or farther apart 
- **Rotation**: A two-finger gesture that moves the two finger-tips in circular motion 

### Adding Tap Gesture 

```swift
	override func viewDidLoad() {
        super.viewDidLoad()
        

        registerTapGesture()
    }

		// MARK: - UITapGestureRecognizer
    private func registerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap(_ sender: UIGestureRecognizer) {
        print(#function)
    }
```



### Identifying Touch Gestures on Virtual Objects 

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTapGesture()
        addShapes()
    }

	// MARK: - UITapGestureRecognizer
    private func registerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap(_ sender: UIGestureRecognizer) {
        print(#function)
        
        guard let tappedView = sender.view as? SCNView else { return }
        let tappedCoordinates = sender.location(in: tappedView)
        let hitTestResults = tappedView.hitTest(tappedCoordinates, options: [:])
        
        if let result = hitTestResults.first {
            print("Hit something: \(result.node.name ?? "Something")")
       
        } else {
            print("Hit nothing")
        }
        
    }
    
    private func addShapes() {
        let node = SCNNode(geometry: 
                           SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        node.position = SCNVector3(0.1, 0, -0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        node.name = "box"
        sceneView.scene.rootNode.addChildNode(node)
        
        let node2 = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.06, length: 0.05))
        node2.position = SCNVector3(0.1, 0.1, -0.1)
        node2.name = "pyramid"
        sceneView.scene.rootNode.addChildNode(node2)
    }
    
```

