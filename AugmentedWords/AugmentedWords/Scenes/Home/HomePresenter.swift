//
//  HomePresenter.swift
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

protocol HomePresenter {
    var view: HomeViewController? { get set }

    func presentSpeechRecognition(withState state: SpeechState)
    func presentAnimations(for node: SCNNode)
}

class HomePresenterImpl: HomePresenter {
    var view: HomeViewController?

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?

    func presentSpeechRecognition(withState state: SpeechState) {
        SFSpeechRecognizer.requestAuthorization { _ in }
        switch state {
        case .start:
            startRecording()
        case .finish:
            finishRecording()
        }
    }

    private func present(string: String, color: UIColor) {
        let text = SCNText(string: string, extrusionDepth: 1)
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        text.flatness = 1
        text.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        text.firstMaterial?.diffuse.contents = color
        let node = SCNNode(geometry: text)
        let randomY = Float.random(in: -0.5 ... 0.5)
        node.position = SCNVector3(0, randomY, -0.5)
        node.scale = SCNVector3(0.005, 0.005, 0.005)

        guard let scene = SCNScene(named: "art.scnassets/cloud.scn"),
            let cloudNode = scene.rootNode.childNode(withName: "cloud", recursively: false) else { return }
        cloudNode.scale = SCNVector3(0.1, 0.1, 0.1)
        cloudNode.position.y = -7
        cloudNode.position.x = 5
        node.addChildNode(cloudNode)

        view?.display(node: node)
    }

    func presentAnimations(for node: SCNNode) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 100
        node.position.z = -100
        node.position.y = 10
        node.eulerAngles.x = -30
        SCNTransaction.commit()
    }

    private func startRecording() {
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

        recognizeSpeech()
    }

    private func finishRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    private func recognizeSpeech() {
        var previousFormattedString: String?
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if result != nil {
                if let result = result {
                    let formattedString = result.bestTranscription.formattedString
                    if previousFormattedString != formattedString {
                        previousFormattedString = formattedString
                        if let string = formattedString.tokenized.last {
                            let color = UIColor(name: string) ?? UIColor.black
                            self.present(string: string, color: color)
                        }
                    }

                } else if let error = error {
                    debugPrint("Error on recording: \(error)")
                }
            }
        })
    }
}
