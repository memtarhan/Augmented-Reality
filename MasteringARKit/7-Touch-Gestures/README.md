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

