//
//  KAudioPlayerVC.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/2/2.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation

protocol KAudioPlayerVCDelegate: class {
    func playbackStopped()
    func playbackBegan()
}

class KAudioPlayerVC: NSObject, AVAudioPlayerDelegate {

    var playing = false
    weak var delegate: KAudioPlayerVCDelegate?

    var players: [AVAudioPlayer]!

    override init() {
        super.init()

        let guitarPlayer = playerForFile("guitar")
        let bassPlayer = playerForFile("bass")
        let drumsPlayer = playerForFile("drums")

        guitarPlayer.delegate = self

        let nc = NotificationCenter.default

        nc.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        nc.addObserver(self, selector: #selector(handleRouteChange(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())

        players = [guitarPlayer, bassPlayer, drumsPlayer]
    }

    func playerForFile(_ name: String) -> AVAudioPlayer {
        let fileURL = Bundle.main.url(forResource: name, withExtension: "caf")!
        do {
            let player = try AVAudioPlayer(contentsOf: fileURL)
            player.numberOfLoops = -1
            player.enableRate = true
            player.prepareToPlay()
            return player
        } catch let error as NSError {
            print("Error creating player: \(error.localizedDescription)")
            fatalError()
        }
    }

    func play() {
        if !playing {
            let delayTime = players.first!.deviceCurrentTime + 0.01
            for player in players {
                player.play(atTime: delayTime)
            }
            playing = true
        }
    }

    func stop() {
        if playing {
            for player in players {
                player.stop()
                player.currentTime = 0.0
            }
            playing = false
        }
    }

    func adjustRate(_ rate: Double) {
        for player in players {
            player.rate = Float(rate)
        }
    }

    func adjustPan(_ pan: Double, forPlayerAtIndex idx: Int) {
        if isValidIndex(idx) {
            players[idx].pan = Float(pan)
        }
    }

    func adjustVolume(_ volume: Double, forPlayerAtIndex idx: Int) {
        if isValidIndex(idx) {
            players[idx].volume = Float(volume)
        }
    }

    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < players.count
    }

    @objc func handleInterruption(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            let type = info[AVAudioSessionInterruptionTypeKey] as! AVAudioSession.InterruptionType
            if type == .began {
                stop()
                delegate?.playbackStopped()
            } else {
                let options = info[AVAudioSessionInterruptionOptionKey] as! AVAudioSession.InterruptionOptions
                if options == .shouldResume {
                    play()
                    delegate?.playbackBegan()
                }
            }
        }
    }

    @objc func handleRouteChange(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {

            let reason = info[AVAudioSessionRouteChangeReasonKey] as! AVAudioSession.RouteChangeReason
            if reason == .oldDeviceUnavailable {
                let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription
                let previousOutput = previousRoute.outputs.first!
                if convertFromAVAudioSessionPort(previousOutput.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
                    stop()
                    delegate?.playbackStopped()
                }
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionPort(_ input: AVAudioSession.Port) -> String {
    return input.rawValue
}
