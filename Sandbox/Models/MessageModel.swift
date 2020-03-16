//
//  MessageModel.swift
//  Sandbox
//
//  Created by Don on 3/15/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation

enum MessageType: Codable
{
	
    enum CodingKeys: String, CodingKey {
        case type
        case voiceModel
        case message
    }
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		let message = try container.decodeIfPresent(String.self, forKey: .message)
		let voiceModel = try container.decodeIfPresent(VoiceModel.self, forKey: .voiceModel)
		if type == "text"
		{
			self = .text(message!)
		}
		else
		{
			self = .voice(voiceModel!)
		}
	}
	
	func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .text(let message):
			
			try container.encode("text", forKey: .type)
			try container.encode(message, forKey: .message)
		case .voice(let voice):
			try container.encode("voice", forKey: .type)
			try container.encode(voice, forKey: .voiceModel)
		}
	}
	
	
	
	case text(String)
	case voice(VoiceModel)
	
}

struct VoiceModel: Codable {
	let data: URL
	let length: Int
	
    enum CodingKeys: String, CodingKey {
        case data
        case length
    }
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.data = try container.decode(URL.self, forKey: .data)
		self.length = try container.decode(Int.self, forKey: .length)
		print(data)
		
	}
	init(data: URL, length: Int) {
		self.data = data
		self.length = length
	}
	
	func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(length, forKey: .length)
		try container.encode(data, forKey: .data)
		print(data)
	}
	
}

struct MessageModel: Codable {
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

