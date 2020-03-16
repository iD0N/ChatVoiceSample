//
//  RecordManager.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation
import AVFoundation

class RecordManager: NSObject
{
    var audioRecorder: AVAudioRecorder?
	var recordingFile: URL?
}

extension RecordManager: AVAudioRecorderDelegate
{
	func startRecording() {
		print("here")
		let session = AVAudioSession.sharedInstance()
		session.requestRecordPermission { (success) in
			do {

				print("here?")
				try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
				try session.setActive(true)
				//Set up a high-quality recording session.
				let settings = [
					AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
					AVSampleRateKey: 44100,
					AVNumberOfChannelsKey: 1,
					AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
				]
				self.recordingFile = self.getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".m4a")
				self.audioRecorder = try AVAudioRecorder(url: self.recordingFile!, settings: settings)
				self.audioRecorder?.delegate = self
				self.audioRecorder?.isMeteringEnabled = true
				self.audioRecorder?.record()
				print("recording?")
			} catch {

				print(error)
			}
		}
	}
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	@IBAction func stopRecording()
	{
		audioRecorder?.stop()
		audioRecorder = nil
	}
	@IBAction func sendRecord()
	{
		
	}

}

