//
//  KeyValueVC.swift
//  YB-iCloud
//
//  Created by Yogendra Bagoriya on 30/12/17.
//  Copyright © 2017 YB. All rights reserved.
//

import UIKit
import CloudKit

class KeyValueVC : UIViewController, UITableViewDataSource {
    
    var dataArr : Array<String> = Array<String>()
    @IBOutlet weak var tb : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        self.addObservers()
    }
    
    @IBAction func addbtnAction(sender : UIBarButtonItem)
    {
        let view = AddMessage.instanceFromNib()
        view.frame = self.view.frame
        view.addBtnActionDelegate = {message in
            self.dataArr.append(message)
            NSUbiquitousKeyValueStore.default.set(self.dataArr, forKey: "AVAILABLE_NOTES")
            NSUbiquitousKeyValueStore.default.synchronize()
            self.tb.reloadData()
        }
        self.view.addSubview(view)
    }
    //MARK:- Other private method
    private func addObservers()
    {
        let store = NSUbiquitousKeyValueStore.default
        NotificationCenter.default.addObserver(self, selector: #selector(storeModified), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: store)
    }
    
    @objc func storeModified()
    {
        dataArr = NSUbiquitousKeyValueStore.default.array(forKey: "AVAILABLE_NOTES") as! Array<String>
        DispatchQueue.main.async {
            self.tb.reloadData()
        }
    }
    
    
    @IBAction func refreshBtnAction(sender : UIBarButtonItem)
    {
        //        dataArr = CKRecord.value(forKey: "AVAILABLE_NOTES") as? Array<String> ?? Array<String>()
        dataArr = NSUbiquitousKeyValueStore.default.array(forKey: "AVAILABLE_NOTES") as? Array<String> ?? Array<String>()
        self.tb.reloadData()
    }
    
    //MARK:- Table view data source method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
}


