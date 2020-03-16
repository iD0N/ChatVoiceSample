//
//  MessageModel.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation

enum MessageType
{
	case text(String)
	case voice(VoiceModel)
}

struct VoiceModel {
	let data: URL
	let length: Int
}

struct MessageModel {
	let message: MessageType
	let isSenderMe: Bool
	let isRead: Bool
	let date: String
	
	static var mockSound: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "sound1", ofType: "m4a")!)
	static var mockMessages = Array([
		MessageModel(message: .text("test"), isSenderMe: true, isRead: true, date: "10:22 am"),
		MessageModel(message: .text("We made it"), isSenderMe: true, isRead: true, date: "10:22 am"),
		MessageModel(message: .text("this is a very very long test"), isSenderMe: false, isRead: true, date: "10:23 am"),
		MessageModel(message: .text("hey there"), isSenderMe: true, isRead: true, date: "1:47 pm"),
		MessageModel(message: .text("hi"), isSenderMe: true, isRead: true, date: "2:22 pm"),
		MessageModel(message: .text("Hey, how are you today my friend? What are your plans for tonight?"), isSenderMe: false, isRead: true, date: "5:00 pm"),
		MessageModel(message: .text("Hey, how are you today my friend? What are your plans for tonight?"), isSenderMe: true, isRead: true, date: "5:01 pm"),
		MessageModel(message: .text("test"), isSenderMe: true, isRead: true, date: "5:55 pm"),
		MessageModel(message: .text("test"), isSenderMe: true, isRead: true, date: "5:56 pm"),
		MessageModel(message: .voice(VoiceModel(data: mockSound, length: 3)), isSenderMe: false, isRead: true, date: "6:32 pm"),
		MessageModel(message: .voice(VoiceModel(data: mockSound, length: 3)), isSenderMe: false, isRead: true, date: "6:33 pm"),
		MessageModel(message: .voice(VoiceModel(data: mockSound, length: 3)), isSenderMe: true, isRead: true, date: "6:40 pm")
		].reversed())
}

