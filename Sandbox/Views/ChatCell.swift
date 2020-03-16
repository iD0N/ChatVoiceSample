//
//  ChatCell.swift
//  Sandbox
//
//  Created by Don on 3/14/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

	@IBOutlet var tickIcon: UIImageView!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var chatImage: UIImageView!
	@IBOutlet var bubbleView: UIView!
	@IBOutlet var leadingConstraint: NSLayoutConstraint!
	@IBOutlet var messageLabel: UILabel!
	var senderMe: Bool?
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectionStyle = .none
		backgroundColor = .clear
		bubbleView.layer.cornerRadius = 8
		chatImage.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func configure(with message: MessageModel, leading: CGFloat) {
		self.senderMe = message.isSenderMe
		switch message.message {
		case .text(let text):
			
			self.messageLabel.text = text
		default:
			break
		}
		self.leadingConstraint.constant = leading - (!message.isSenderMe ? 50 : 0)
		//self.semanticContentAttribute = message.isSenderMe ? .forceLeftToRight : .forceRightToLeft
		//Doesn't work, workaround:
		if !message.isSenderMe
		{
			contentView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
			contentView.subviews.forEach { view in
				view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
			}
		}
		else
		{
			contentView.transform = .identity
			contentView.subviews.forEach { view in
				view.transform = .identity
			}
		}
		bubbleView.backgroundColor = message.isSenderMe ? #colorLiteral(red: 0.3169547915, green: 0.3038178086, blue: 0.3828184009, alpha: 1) : #colorLiteral(red: 0.1195071712, green: 0.1153659299, blue: 0.2024540007, alpha: 1)
		contentView.removeFromSuperview()
		self.addSubview(contentView)
		chatImage.isHidden = message.isSenderMe
		tickIcon.isHidden = !message.isSenderMe
		dateLabel.text = message.date
		self.bubbleView.setNeedsLayout()
	}
    
}
