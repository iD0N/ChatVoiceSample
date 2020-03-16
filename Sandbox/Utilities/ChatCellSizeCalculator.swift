//
//  ChatCellSizeCalculator.swift
//  Sandbox
//
//  Created by Don on 3/14/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit


struct ChatCellCalculator {
	let maxWidth: CGFloat
	let chatInsets: UIEdgeInsets
	let bubbleInsets: UIEdgeInsets
	
	func getBubbleSize(for message: String, hasReadIcon: Bool = false) -> CGSize {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15)
		label.text = message
		label.numberOfLines = 0
		let maxUsableWidth = maxWidth - (bubbleInsets.left + bubbleInsets.right + chatInsets.left + chatInsets.right) - (!hasReadIcon ? 40 : 0)
		let messageSize = label.sizeThatFits(CGSize(width: maxUsableWidth, height: 10000))
		label.text = "109:59 pm"
		let dateSize = label.sizeThatFits(CGSize(width: 200, height: 200))
		let dateMessageDistance: CGFloat = 8.0
		
		let readStatusDistance: CGFloat = hasReadIcon ? 16 : 0
		
		
		let extraHeight = bubbleInsets.top + bubbleInsets.bottom + chatInsets.top + chatInsets.bottom
		let extraWidth = chatInsets.left + chatInsets.right
		
		let mainBubbleWidth = messageSize.width + dateSize.width + readStatusDistance + dateMessageDistance
		if mainBubbleWidth > maxUsableWidth
		{
			let height = messageSize.height + dateSize.height + dateMessageDistance + extraHeight
			let width = messageSize.width + extraWidth
			print("height \(height)")
			return CGSize(width: width, height: height)
		}
		else
		{
			let height = messageSize.height + extraHeight
			let width = chatInsets.left + mainBubbleWidth
			return CGSize(width: width, height: height)
		}
	}
}
