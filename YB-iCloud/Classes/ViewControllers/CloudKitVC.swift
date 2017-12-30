//
//  CloudKitVC.swift
//  YB-iCloud
//
//  Created by Yogendra Bagoriya on 30/12/17.
//  Copyright © 2017 YB. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var imageIV : UIImageView!
    @IBOutlet weak var recordTV : UITableView!
    @IBOutlet weak var titleTF : UITextField!
    @IBOutlet weak var descriptionTV : UITextView!
    
    var recordArr : Array<CKRecord>!
    
    var imageURL: NSURL!
    var destinationURL : URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTV.layer.borderWidth = 1.0
        descriptionTV.layer.cornerRadius = 4.0
        recordArr = Array<CKRecord>()
    }
    
    //MARK:- Action Method
    @IBAction func picPhotoFromLibrary(sender : UIButton)
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadNote(sender : UIButton)
    {
        self.uploadNote()
    }
    
    @IBAction func getNoteRecord(sender : UIButton)
    {
        let container = CKContainer.default()
        let privateDB = container.privateCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Notes", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (recordArr, error) in
            if error == nil{
                self.recordArr = recordArr
                DispatchQueue.main.async {
                    self.recordTV.reloadData()
                }
            }
            else
            {
                print(error!.localizedDescription)
            }
        }
    }
    
  
    //MARK:- TableView Data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArr.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCellIdentifier")
        let picIV = cell?.viewWithTag(1) as! UIImageView
        let titleL = cell?.viewWithTag(2) as! UILabel
        let subTitleL = cell?.viewWithTag(3) as! UILabel
        
        let record = recordArr[indexPath.row]
        titleL.text = record.value(forKey: "noteTitle") as? String
        subTitleL.text = record.value(forKey: "noteText") as? String
        let imageAsset : CKAsset = record.value(forKey: "noteImage") as! CKAsset
        picIV.image = UIImage(contentsOfFile: imageAsset.fileURL.path)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let recordId : CKRecordID = recordArr[indexPath.row].recordID
        self.deleteRecordFromiCloud(recordId: recordId) { (isSuccess) in
            if isSuccess{
                DispatchQueue.main.async {
                    self.recordArr.remove(at: indexPath.row)
                    self.recordTV.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                }
            }
            else
            {
                
            }
        }
    }
    
    //MARK:- ImagePicker delegat
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print(info)
        imageIV.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.saveImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Other Private method
    
    private func saveImage()
    {
        let tempImageName = "Image.jpg"
        let imageData = UIImageJPEGRepresentation(imageIV.image!, 0.5)
        
        do {
            let manager = Foundation.FileManager.default
            let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            destinationURL = documents.appendingPathComponent(tempImageName)
            try imageData?.write(to: destinationURL)
        }
        catch
        {
            print(error)
        }
    }
    
    func uploadNote() {
        
        let timeStamp = String(format: "%f", NSDate.timeIntervalSinceReferenceDate)
        let identifier = timeStamp.components(separatedBy: ".")
        
        let title = titleTF.text ?? "No Title @ \(identifier)"
        let description = descriptionTV.text ?? "No description provided"
        
        let record = CKRecord(recordType: "Notes", recordID: CKRecordID(recordName: identifier.first!))
        record.setObject(title as CKRecordValue, forKey: "noteTitle")
        record.setObject(description as CKRecordValue, forKey: "noteText")
        record.setObject(Date() as CKRecordValue, forKey: "noteEditedDate")
        let imageAsset = CKAsset(fileURL: destinationURL)
        record.setObject(imageAsset, forKey: "noteImage")
        
        let container = CKContainer.default()
        let privaeDB = container.privateCloudDatabase
        privaeDB.save(record) { (record, error) in
            if error != nil
            {
                print(error?.localizedDescription ?? "Error is exist")
            }
            else{
                print(record?.description ?? "No record description")
            }
        }
    }
    
    func deleteRecordFromiCloud(recordId : CKRecordID, complitionHandler:@escaping (Bool)->())
    {
        let container = CKContainer.default()
        let privateDB : CKDatabase = container.privateCloudDatabase
        
        privateDB.delete(withRecordID: recordId) { (recordID, error) in
            if error == nil
            {
                complitionHandler(true)
            }
            else
            {
                complitionHandler(false)
            }
        }
    }
    
}

