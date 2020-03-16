//
//  VoiceCell.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit

extension Notification.Name {
	static let updateSlider = Notification.Name("updateSlider")
	static let stopAudio = Notification.Name("stopAudio")
}
class VoiceCell: UITableViewCell {
	
	var fileURL: URL?
	@IBOutlet var startButton: UIButton!
	@IBOutlet var voiceLengthLabel: UILabel!
	@IBOutlet var slider: UISlider!
	@IBOutlet var tickIcon: UIImageView!
	@IBOutlet var user1Icon: UIImageView!
	@IBOutlet var user2Icon: UIImageView!
	@IBOutlet var bubbleView: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		backgroundColor = .clear
		bubbleView.layer.cornerRadius = 8
		user1Icon.layer.cornerRadius = 20
		user2Icon.layer.cornerRadius = 20
		selectionStyle = .none
		NotificationCenter.default.addObserver(self, selector: #selector(updateSlider(_:)), name: .updateSlider, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(stopRequested(_:)), name: .stopAudio, object: nil)
		startButton.tintColor = #colorLiteral(red: 0.863892138, green: 0.8583733439, blue: 0.8759544492, alpha: 1)
		//slider.thumbTintColor = #colorLiteral(red: 1, green: 0, blue: 0.4971166253, alpha: 1)
		slider.setThumbImage(makeCircleWith(size: CGSize(width: 14, height: 14), backgroundColor: #colorLiteral(red: 1, green: 0, blue: 0.4971166253, alpha: 1)), for: .normal)
    }

	@IBAction func sliderButtonTapped(_ sender: Any) {
		
		if startButton.image(for: .normal) == #imageLiteral(resourceName: "play")
		{
			startButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			PlayerManager.shared.playAudioRequested(tag: self.tag, url: fileURL!)
		}
		else
		{
			startButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			PlayerManager.shared.pauseAudioRequested()
		}
	}
	@objc func updateSlider(_ notification: Notification) {
		guard let tag = notification.userInfo?["tag"] as? Int, let duration = notification.userInfo?["duration"] as? Float, tag == self.tag else { return }
		slider.setValue(duration, animated: true)
		startButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
	}
	@objc func stopRequested(_ notification: Notification) {
		guard let tag = notification.userInfo?["tag"] as? Int, tag == self.tag else { return }
		slider.setValue(0, animated: true)
		startButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func configure(with message: MessageModel, isPlaying: Bool) {
		
		bubbleView.backgroundColor = message.isSenderMe ? #colorLiteral(red: 0.3169547915, green: 0.3038178086, blue: 0.3828184009, alpha: 1) : #colorLiteral(red: 0.1195071712, green: 0.1153659299, blue: 0.2024540007, alpha: 1)
		tickIcon.isHidden = !message.isSenderMe
		tickIcon.tintColor = !message.isRead ? .white : .systemBlue
		user1Icon.image = !message.isSenderMe ? nil : #imageLiteral(resourceName: "user2")
		user2Icon.image = !message.isSenderMe ? #imageLiteral(resourceName: "user1") : nil
		if isPlaying
		{
			startButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
		}
		else
		{
			startButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			slider.value = 0
		}
		switch message.message {
		case .voice(let model):
			voiceLengthLabel.text = "\(model.length/60):\(model.length % 60 < 10 ? "0\(model.length % 60)" : "\(model.length % 60)")"
			self.fileURL = model.data
			slider.maximumValue = Float(model.length)
		default:
			break
		}
	}
	func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(backgroundColor.cgColor)
		context?.setStrokeColor(UIColor.clear.cgColor)
		let bounds = CGRect(origin: .zero, size: size)
		context?.addEllipse(in: bounds)
		context?.drawPath(using: .fill)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}

}
