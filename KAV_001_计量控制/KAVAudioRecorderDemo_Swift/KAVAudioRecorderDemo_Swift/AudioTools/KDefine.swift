//
//  KDefine.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/1/31.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

var appHasMicAccess = true

enum AudioStatus: Int, CustomStringConvertible {
    case stopped = 0, playing, recording, interruptionPlaying, interruptionRecording
    
    var audioName: String {
        let audioNames = [
            "Audio:  Stopped",
            "Audio:  Playing",
            "Audio:  Recording",
            "Audio:  interruptionPlaying",
            "Audio:  interruptionRecording"]
        return audioNames[rawValue]
    }
    
    
    //  CustomStringConvertible
    var description: String {
        return audioName
    }
}
