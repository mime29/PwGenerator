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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    generateBtn.layer.cornerRadius = 20
    passwordTxt.isSecureTextEntry = true
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouched))
    view.addGestureRecognizer(gesture)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func longTouched(gesture: UIGestureRecognizer) {
    if gesture.state == .began {
      passwordTxt.isSecureTextEntry = false
    }else if gesture.state == .ended || gesture.state == .cancelled {
      passwordTxt.isSecureTextEntry = true
    }
  }
  
  @IBAction func generateBtnTouched(_ sender: Any) {
    guard checkTextFields() else {
      print("checkTextFields returned false")
      return
    }
    
    let allStrings = "\(masterTxt.text!) \(domainTxt.text!) \(saltTxt.text!)"
    let sha1Data = allStrings.data(using:String.Encoding.utf8)?.sha1()
    let b64Data = sha1Data?.base64EncodedData()
    
    let strFromb64Data = String(data:b64Data!, encoding:String.Encoding.utf8)
    
    var output = strFromb64Data
    
    if strFromb64Data!.characters.count > 32 {
      let index = strFromb64Data?.startIndex
      let endIndex = strFromb64Data?.index(index!, offsetBy: 32)
      output = strFromb64Data?[Range(index! ..< endIndex!)]
    }
    
    passwordTxt.text = output
    let pb = UIPasteboard(name: .general, create: true)
    pb?.string = output
  }

  func checkTextFields() -> Bool {
    guard let str = masterTxt?.text, !str.isEmpty  else {
      return false
    }
    guard let str2 = domainTxt?.text, !str2.isEmpty  else {
      return false
    }
    guard let str3 = saltTxt?.text, !str3.isEmpty  else {
      return false
    }
    
    return true
  }
}

