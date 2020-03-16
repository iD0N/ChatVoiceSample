//
//  PanView.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit
protocol PanViewDelegate {
	func panGestureFinished()
}
class PanView: UIView {
	
	var label: UILabel
	var timeLabel: UILabel
	var delegate: PanViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	override init(frame: CGRect) {
		self.label = UILabel()
		label.text = "< Swipe to cancel"
		self.label.textColor = .white
		self.timeLabel = UILabel()
		timeLabel.text = "00:00"
		self.timeLabel.textColor = .white
		super.init(frame: frame)
		self.addSubview(label)
		self.addSubview(timeLabel)
		self.translatesAutoresizingMaskIntoConstraints = false
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeToCancel(_:)))
		
        label.isUserInteractionEnabled = true
		label.addGestureRecognizer(panGesture)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let size = label.sizeThatFits(CGSize(width: 200, height: 100))
		self.label.frame = CGRect(origin: .zero, size: size)
		self.label.center = CGPoint(x: self.bounds.width - 12 - size.width/2.0, y: self.center.y)
		
		let sizeTime = timeLabel.sizeThatFits(CGSize(width: 200, height: 100))
		self.timeLabel.frame = CGRect(origin: .zero, size: sizeTime)
		self.timeLabel.center = CGPoint(x: 30, y: self.center.y)
	}
	
	@objc func swipeToCancel(_ sender: UIPanGestureRecognizer) {
		
        let translation = sender.translation(in: self)
        
		if translation.x < 0
		{
			sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y)
			
			if sender.view!.center.x <= center.x
			{
				sender.view!.isUserInteractionEnabled = false
				sender.isEnabled = false
				delegate?.panGestureFinished()
				UIView.animate(withDuration: 0.1, animations: {

					sender.view!.center = CGPoint(x: self.bounds.width - 12 - sender.view!.bounds.width/2.0, y: self.center.y)
				})
			}
		}
		if sender.state == .ended
		{
			UIView.animate(withDuration: 0.1, animations: {
				
				sender.view!.center = CGPoint(x: self.bounds.width - 12 - sender.view!.bounds.width/2.0, y: self.center.y)
			})
		}
        sender.setTranslation(CGPoint.zero, in: self)
	}
}
