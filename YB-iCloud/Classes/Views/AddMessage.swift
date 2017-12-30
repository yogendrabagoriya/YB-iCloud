//
//  AddMessage.swift
//  YB-iCloud
//
//  Created by Yogendra Bagoriya on 30/12/17.
//  Copyright © 2017 YB. All rights reserved.
//

import Foundation
import UIKit

class AddMessage : UIView {

    @IBOutlet weak var messageTF : UITextField!

    var addBtnActionDelegate : (String)->()={_ in }

    class func instanceFromNib()->(AddMessage)
    {
        let view : AddMessage = Bundle.main.loadNibNamed("AddMessage", owner: self, options: nil)!.first as! AddMessage
        return view
    }

    @IBAction func addBtnAction(sender : UIButton)
    {
        self.addBtnActionDelegate(messageTF.text!)
    }

    @IBAction func cancelBtnAction(sender : UIButton)
    {
        self.removeFromSuperview()
    }

}
