//
//  KAVSessionManager.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/1/31.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation

class KAVSessionManager: NSObject {
    class func setupAVSession() {
        let session = AVAudioSession.sharedInstance()
               do {
                   try session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                   try session.setActive(true)
                   session.requestRecordPermission({ (isGranted: Bool) in
                       if isGranted {
                           appHasMicAccess = true
                       }
                       else{
                           appHasMicAccess = false
                       }
                   })
               } catch let error as NSError {
                   print("AVAudioSession configuration error: \(error.localizedDescription)")
               }
    }
}
