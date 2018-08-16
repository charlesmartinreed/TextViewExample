//
//  ViewController.swift
//  TextViewExample
//
//  Created by Charles Martin Reed on 8/16/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegate for the textView
        self.textView.delegate = self
        
        //start listening for notifications about the Keyboard frame
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //added to facilitate compatibility with hardware keyboards
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //click outside of the text view to dismiss the keyboard
    //this, however, doesn't scale when you have more than one text view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //self.view.endEditing(true)
        
        //alternatively...
        self.textView.resignFirstResponder()
    }
    
    //MARK: - Protocol Methods for UITextViewDelegate
    
    //when the user enters the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.lightGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
    }

    //restrict number of characters in a text view
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        countLabel.text = "\(textView.text.count)"
//
//        //can only add text only if characters are less than 139
//        return textView.text.count + (text.count - range.length) <= 140
//    }
    
    //adjusting the textView
    @objc func updateTextView(notification: Notification) {
        //inside a notification, is a user identification object. We use this
        let userInfo = notification.userInfo!
        
        //extract coordinates from the userInfo dict - originally a NSObject, but we need a cgRect
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //accounting for landscape rotation
        //converting the end frame rect info
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }


}

