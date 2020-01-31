//
//  KAudioRecordManager.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/1/31.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation

let PATH_OF_CACHE = NSTemporaryDirectory()

class KAudioRecordManager: NSObject {
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var audioStatus: AudioStatus = AudioStatus.stopped
    let file_path = PATH_OF_CACHE.appending("/record.wav")
    var mp3file_path = PATH_OF_CACHE.appending("/audio.mp3")

    private static var _sharedInstance: KAudioRecordManager?
    private override init() { } // 私有化init方法

    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> KAudioRecordManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = KAudioRecordManager()
            return _sharedInstance!
        }
        return instance
    }

    /// 销毁单例
    class func destroy() {
        _sharedInstance = nil
    }

    //开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let err{
            debugPrint("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            debugPrint("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 44100.0),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            debugPrint("开始录音")
        } catch let err {
            debugPrint("录音失败:\(err.localizedDescription)")
        }
    }

    var stopRecordBlock:((_ audioPath:String,_ audioFormat:String)->())?
    //结束录音
    func stopRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch let err{
            debugPrint("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            debugPrint("初始化动作失败:\(err.localizedDescription)")
        }
        
        if let recorder = self.recorder {
            if recorder.isRecording {
                debugPrint("正在录音，马上结束它，文件保存到了：\(file_path)")
                let manager = FileManager.default
                if manager.fileExists(atPath: mp3file_path) {
                    do {
                        try manager.removeItem(atPath: mp3file_path)
                    } catch let err {
                        debugPrint(err)
                    }
                }
                //AudioWrapper.audioPCMtoMP3(file_path, andPath: mp3file_path)
                debugPrint("正在录音，马上结束它，文件保存到了：\(mp3file_path)")
                if let block = stopRecordBlock {
                    block("/audio.mp3","mp3")
                }
            }else {
                debugPrint("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            debugPrint("没有初始化")
        }
    }

    //取消录制
    func cancelRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                recorder.stop()
                self.recorder = nil
            }
        }
    }

    ///初始化
    func initLocalPlay() {
        do {
            debugPrint(mp3file_path)
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mp3file_path))
            player?.delegate = self
            debugPrint("歌曲长度：\(player!.duration)")
        } catch let err {
            debugPrint("播放失败:\(err.localizedDescription)")
        }
    }

    //播放本地音频文件
    func play() {
        player?.play()
    }
    //暂停本地音频
    func stop() {
        player?.pause()

    }
    var localPlayFinishBlock:(()->())?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let block = KAudioRecordManager.shared().localPlayFinishBlock {
            block()
        }
    }
    //进度条相关
    func progress()->Double{
        
        return (player?.currentTime)!/(player?.duration)!
    }
}

extension KAudioRecordManager: AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        audioStatus = .stopped
    }
    
}
