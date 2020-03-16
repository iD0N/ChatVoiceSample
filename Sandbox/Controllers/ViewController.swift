//
//  ViewController.swift
//  Sandbox
//
//  Created by Don on 3/13/20.
//  Copyright © 2020 Don. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class ViewController: UIViewController {
	
	@IBOutlet var topIconImage: UIImageView!
	@IBOutlet var topView: ChatTopView!
	//Subviews
	@IBOutlet var tableView: UITableView!
	var inputBar: InputBarAccessoryView = InputBarAccessoryView()
	
	//Message data
	var messages = DataManager.standard.messages
	var messageSizeCache: [Int : CGSize] = [:]
	
	//Managers/Helpers
	var calculator: ChatCellCalculator?
    private var keyboardManager = KeyboardManager()
	
	//Record Manager
	var recordManager = RecordManager()
	//Timer
	var recordTimer: Timer?
	var timerCounterLabel: UILabel?
	//Overlay
	var overlayView: UIView?
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if messages.count == 0
		{
			messages = MessageModel.mockMessages
			DataManager.standard.messages = messages
		}
		navigationItem.titleView = topView
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .done, target: nil, action: nil)
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more").resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .done, target: nil, action: nil)
		// Do any additional setup after loading the view.
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "Cell")
		tableView.register(UINib(nibName: "VoiceCell", bundle: nil), forCellReuseIdentifier: "VoiceCell")
		tableView.sectionHeaderHeight = .leastNormalMagnitude
		calculator = ChatCellCalculator(maxWidth: self.view.bounds.width, chatInsets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12), bubbleInsets: UIEdgeInsets(top: 10, left: 70, bottom: 10, right: 10))
		
        view.addSubview(inputBar)
		createNormalInputBar()
		tableView.backgroundColor = #colorLiteral(red: 0.1450371444, green: 0.130322814, blue: 0.2307013273, alpha: 1)
		self.tableView.contentInset.bottom = 20
		self.tableView.contentInset.top = 50

		tableView.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
		
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableView)
		inputBar.delegate = self
		
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.top = barHeight + notification.endFrame.height
            self?.tableView.scrollIndicatorInsets.top = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableView.contentInset.top = barHeight
                self?.tableView.scrollIndicatorInsets.top = barHeight
        }
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		topIconImage.layoutIfNeeded()
		topIconImage.layer.cornerRadius = topIconImage.bounds.width/2
	}
	//Switch to recording state
	func createRecordingInputBar()
	{
		let view = PanView()
		view.delegate = self
		
		if overlayView == nil
		{
			overlayView = UIView()
			overlayView!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
		}
		overlayView?.frame = self.view.bounds
		self.view.insertSubview(overlayView!, belowSubview: inputBar)
		//view.backgroundColor = .black
		let items = [
			.fixedSpace(10),
            InputBarButtonItem()
				.configure {
					//$0.spacing = .fixed(10)
					$0.image = UIImage(named: "microphone")!.withRenderingMode(.alwaysTemplate)
					$0.tintColor = .systemPink
					$0.setSize(CGSize(width: 28, height: 28), animated: false)
				},
			.fixedSpace(10)
        ]
		
		recordTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
		recordManager.startRecording()
		timerCounterLabel = view.timeLabel
		
		
		inputBar.sendButton.backgroundColor = .systemPink
		inputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
		inputBar.sendButton.imageView?.contentMode = .scaleAspectFit
		inputBar.sendButton.setSize(CGSize(width: 50, height: 50), animated: false)
		inputBar.sendButton.image = #imageLiteral(resourceName: "send")
		inputBar.sendButton.title = nil
		inputBar.sendButton.tintColor = .white
		inputBar.sendButton.imageView?.tintColor = .white
		inputBar.sendButton.layer.cornerRadius = 25
		inputBar.sendButton.isEnabled = true
		inputBar.setRightStackViewWidthConstant(to: 60, animated: false)
		inputBar.setStackViewItems([.fixedSpace(10), inputBar.sendButton], forStack: .right, animated: false)
		inputBar.setStackViewItems(items, forStack: .left, animated: false)
		inputBar.setLeftStackViewWidthConstant(to: 48, animated: false)
        inputBar.setMiddleContentView(view, animated: false)
	}
	
	//Switch to normal state
	func createNormalInputBar() {
		overlayView?.removeFromSuperview()
		inputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.1450371444, green: 0.130322814, blue: 0.2307013273, alpha: 1)
		inputBar.setMiddleContentView(inputBar.inputTextView, animated: false)
		let items = [
			.fixedSpace(10),
            InputBarButtonItem()
				.configure {
					$0.image = UIImage(named: "camera")!.withRenderingMode(.alwaysTemplate)
					$0.tintColor = .white
					$0.setSize(CGSize(width: 25, height: 25), animated: false)
				},
			.fixedSpace(16),
            InputBarButtonItem()
				.configure {
					$0.image = UIImage(named: "microphone-2")!.withRenderingMode(.alwaysTemplate)
					$0.tintColor = .white
					$0.setSize(CGSize(width: 25, height: 25), animated: false)
				}.onTouchUpInside { _ in
					self.createRecordingInputBar()
			},
			.fixedSpace(10)
        ]
        let plus = InputBarButtonItem()
            .configure {
                $0.image = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
                $0.tintColor = .white
                $0.setSize(CGSize(width: 20, height: 20), animated: false)
            }
		inputBar.setStackViewItems([.fixedSpace(10), plus, .fixedSpace(10)], forStack: .left, animated: false)
		inputBar.setRightStackViewWidthConstant(to: 86, animated: false)
		inputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
		inputBar.setStackViewItems(items, forStack: .right, animated: false)
		
		inputBar.inputTextView.layer.cornerRadius = 20.0
		inputBar.inputTextView.placeholderTextColor = UIColor.white.withAlphaComponent(0.3)
		inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
		inputBar.middleContentView?.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
		inputBar.middleContentView?.layer.borderWidth = 1.0
		
		inputBar.inputTextView.placeholder = "Say something."
		inputBar.inputTextView.textColor = UIColor.gray
		inputBar.leftStackView.alignment = .center
		inputBar.rightStackView.alignment = .center
		inputBar.padding.top = 10
		inputBar.separatorLine.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
		
	}
	
	@objc func updateTimer() {
		
		print("Text")
		let length = Int(recordManager.audioRecorder?.currentTime ?? 0)
		self.timerCounterLabel?.text = "\(length/60):\(length % 60 < 10 ? "0\(length % 60)" : "\(length % 60)")"
	}

}
extension ViewController: UITableViewDelegate, UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch messages[indexPath.row].message {
		case .text(let message):
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatCell
			cell.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
			
			if messageSizeCache[indexPath.row] == nil
			{
				messageSizeCache[indexPath.row] = calculator?.getBubbleSize(for: message, hasReadIcon: messages[indexPath.row].isSenderMe)
			}
			let size = messageSizeCache[indexPath.row]!
			cell.configure(with: messages[indexPath.row], leading: self.view.bounds.width - size.width)
		
			return cell
			
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceCell") as! VoiceCell
			cell.configure(with: messages[indexPath.row], isPlaying: PlayerManager.shared.tag == indexPath.row)
			cell.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
			cell.tag = indexPath.row
			return cell
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch messages[indexPath.row].message {
		case .text(let message):
			if messageSizeCache[indexPath.row] == nil
			{
				messageSizeCache[indexPath.row] = calculator?.getBubbleSize(for: message, hasReadIcon: messages[indexPath.row].isSenderMe)
			}
		default:
			messageSizeCache[indexPath.row] = CGSize(width: 0, height: 80.0)
		}
		return messageSizeCache[indexPath.row]!.height
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		40
	}
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40))
		let label = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 20))
		label.textAlignment = .center
		label.textColor = .white
		label.text = "Today"
		label.font = .boldSystemFont(ofSize: 12)
		view.addSubview(label)
		view.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
		return view
	}
}

extension ViewController: PanViewDelegate
{
	func panGestureFinished() {
		createNormalInputBar()
		self.recordManager.stopRecording()
		self.recordTimer?.invalidate()
	}
}

extension ViewController: InputBarAccessoryViewDelegate
{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
		createNormalInputBar()
		let length = Int(recordManager.audioRecorder?.currentTime ?? 0)
		self.recordManager.stopRecording()
		self.recordTimer?.invalidate()
		messageSizeCache = [:]
		
		messages.insert(MessageModel(message: .voice(VoiceModel(data: recordManager.recordingFile ?? URL(fileURLWithPath: ""), length: length)), isSenderMe: true, isRead: false, date: "10:10 pm"), at: 0)
		DataManager.standard.messages = messages
		self.tableView.reloadData()
    }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}
