//
//  CloudOptionVC.swift
//  YB-iCloud
//
//  Created by Yogendra Bagoriya on 30/12/17.
//  Copyright © 2017 YB. All rights reserved.
//

import Foundation
import UIKit

class CloudOptionVC : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    let optionArr = ["Key-Value", "iCloud Document", "Cloud Kit"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- TableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = optionArr[indexPath.row]
        return cell
    }
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "KeyValueSegue", sender: nil)
            break
        case 1:
            self.performSegue(withIdentifier: "DocumentSegue", sender: nil)
            break
        case 2:
            self.performSegue(withIdentifier: "CloudSegue", sender: nil)
            break
        default:
            break
        }
    }
    
}
