//
//  HomeViewController.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 29.02.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import ARKit
import AVKit
import SceneKit
import Speech
import UIKit

protocol HomeViewController: class {
    var presenter: HomePresenter? { get set }
    
    func display(node: SCNNode)
}

class HomeViewControllerImpl: UIViewController {
    var presenter: HomePresenter?

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var recordButtonView: DesignedView!

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?

    private var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        SFSpeechRecognizer.requestAuthorization { _ in }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        if isRecording {
            cancelRecording()
            isRecording = false

        } else {
            recordAndRecognizeSpeech()
            isRecording = true
        }
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            let cornerRadius: CGFloat = self.isRecording ? 9.0 : 22.5
            self.recordButtonView.layer.cornerRadius = cornerRadius
        }, completion: nil)
    }

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            debugPrint("Error on starting audio engine: \(error)")
        }
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable {
            debugPrint("SFSpeechRecognizer is not available")
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if result != nil {
                if let result = result {
                    let bestString = result.bestTranscription.formattedString

                    var lastString: String = ""
                    for segment in result.bestTranscription.segments {
                        let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                        lastString = String(bestString[indexTo...])
                        print("Recognized: \(lastString)")
                        self.presenter?.present(string: lastString)
                    }

                } else if let error = error {
                    debugPrint("Error on recording: \(error)")
                }
            }

        })
    }

    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil

        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

// MARK: - HomeViewController

extension HomeViewControllerImpl: HomeViewController {
    func display(node: SCNNode) {
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(node)
            self.presenter?.presentAnimations(for: node)
        }
    }
}

// MARK: - ARSCNViewDelegate

extension HomeViewControllerImpl: ARSCNViewDelegate {}
