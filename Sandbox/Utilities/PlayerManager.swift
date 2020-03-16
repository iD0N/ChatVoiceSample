//
//  PlayerManager.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation
import AVKit


class PlayerManager: NSObject
{
    var audioPlayer: AVAudioPlayer?
	var tag: Int = -1
	var pausedTag: Int = -1
	var timer: Timer?
	static var shared = PlayerManager()
	
	func startPlaying(url: URL) {
		
		do {
			let sound = try Data(contentsOf: url)
			try AVAudioSession.sharedInstance().setCategory(.playback)
			try AVAudioSession.sharedInstance().setActive(true)
			
			try audioPlayer = AVAudioPlayer(data: sound)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.play()
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
			print("File data size: \(CGFloat(sound.count)/(1024.0*1024.0))mb for \(audioPlayer?.duration ?? 0) seconds")
		} catch
		{
			print("error initializing AVAudioPlayer")
			print(error)
		}
	}
	func playAudioRequested(tag: Int, url: URL) {
		
		if pausedTag == tag
		{
			audioPlayer?.play()
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
		}
		else
		{
			print(self.tag)
			print("tag")
			print(tag)
			NotificationCenter.default.post(name: .stopAudio, object: nil, userInfo: ["tag": self.tag ?? 0])
			self.tag = tag
			self.pausedTag = tag
			audioPlayer?.stop()
			startPlaying(url: url)
		}
	}
	func pauseAudioRequested() {
		audioPlayer?.pause()
		timer?.invalidate()
		timer = nil
		self.tag = -1
	}
	@objc func updateTime() {
		NotificationCenter.default.post(name: .updateSlider, object: nil, userInfo: ["tag": tag ?? 0, "duration": Float(audioPlayer?.currentTime ?? 0)])
	}
}

extension PlayerManager : AVAudioPlayerDelegate
{
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		NotificationCenter.default.post(name: .stopAudio, object: nil, userInfo: ["tag": tag ?? 0])
		audioPlayer?.stop()
		timer?.invalidate()
		timer = nil
		self.tag = -1
		self.pausedTag = -1
	}
}
