//
//  ViewController.swift
//  Generator
//
//  Created by Mikael on 11/14/16.
//  Copyright © 2016 generator. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
  @IBOutlet weak var domainTxt: UITextField!
  @IBOutlet weak var masterTxt: UITextField!
  @IBOutlet weak var saltTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var generateBtn: UIButton!
  @IBOutlet weak var passwordCopiedTxt: UILabel!
  
  let userDefaultMaster = "master"
  let userDefaultDomain = "domain"
  let userDefaultSalt = "salt"
  
  var timer:Timer?

  override func viewDidLoad() {
    super.viewDidLoad()
    //Change button style
    generateBtn.layer.cornerRadius = 25
    generateBtn.layer.borderWidth = 1.0
    generateBtn.layer.borderColor = UIColor.black.cgColor
    
    passwordTxt.isSecureTextEntry = true
    masterTxt.isSecureTextEntry = true
    saltTxt.isSecureTextEntry = true
    
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouched))
    view.addGestureRecognizer(gesture)
    
    //init the view
    let usrDefault = UserDefaults.standard
    domainTxt.text = usrDefault.string(forKey: userDefaultDomain)
    masterTxt.text = usrDefault.string(forKey: userDefaultMaster)
    saltTxt.text = usrDefault.string(forKey: userDefaultSalt)
    passwordCopiedTxt.alpha = 0.0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func longTouched(gesture: UIGestureRecognizer) {
    if gesture.state == .began {
      passwordTxt.isSecureTextEntry = false
      masterTxt.isSecureTextEntry = false
      saltTxt.isSecureTextEntry = false
      view.alpha = 0.6
    }else if gesture.state == .ended || gesture.state == .cancelled {
      passwordTxt.isSecureTextEntry = true
      masterTxt.isSecureTextEntry = true
      saltTxt.isSecureTextEntry = true
      view.alpha = 1.0
    }
  }
  @IBAction func generateBtnTouchedDown(_ sender: Any) {
    UIView.animate(withDuration: 0.2, animations: {
      self.generateBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    })
  }
  @IBAction func generateBtnTouchCancel(_ sender: Any) {
    UIView.animate(withDuration: 0.2, animations: {
      self.generateBtn.transform = CGAffineTransform.identity
    })
  }
  
  @IBAction func generateBtnTouched(_ sender: Any) {
    UIView.animate(withDuration: 0.2, animations: {
      self.generateBtn.transform = CGAffineTransform.identity
    })

    //Error check
    guard checkTextFields() else {
      print("checkTextFields returned false")
      return
    }
    if saltTxt.text == nil {
      saltTxt.text = ""
    }
    
    //Saving the fields
    let usrDefault = UserDefaults.standard
    usrDefault.set(masterTxt.text!, forKey: userDefaultMaster)
    usrDefault.set(domainTxt.text!, forKey: userDefaultDomain)
    usrDefault.set(saltTxt.text!, forKey: userDefaultSalt)
    
    let allStrings = "\(masterTxt.text!) \(domainTxt.text!) \(saltTxt.text!)"
    let sha1String = allStrings.sha1()
    let b64String = Data(sha1String.utf8).base64EncodedString()
    
    var output = b64String
    
    if b64String.characters.count > 32 {
      let index = b64String.startIndex
      let endIndex = b64String.index(index, offsetBy: 32)
      output = b64String[Range(index ..< endIndex)]
    }
    
    passwordTxt.text = output
    let pb = UIPasteboard(name: .general, create: true)
    pb?.string = output
    
    //display information
    passwordCopiedTxt.alpha = 1.0
    
    //We cancel the timer if it's still running
    if let timR = timer, timR.isValid {
      timR.invalidate()
    }
    timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { (theTimer) in
      UIView.animate(withDuration: 0.5, animations: {
        self.passwordCopiedTxt.alpha = 0.0
      })
    })
  }

  func checkTextFields() -> Bool {
    guard let str = masterTxt?.text, !str.isEmpty  else {
      return false
    }
    guard let str2 = domainTxt?.text, !str2.isEmpty  else {
      return false
    }
    //salt is optional
    /*guard let str3 = saltTxt?.text, !str3.isEmpty  else {
      return false
    }*/
    
    return true
  }
}

