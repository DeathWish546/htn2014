//
//  ViewController.swift
//  Camera
//
//  Created by Jean-Luc David on 2014-08-12.
//  Copyright (c) 2014 com.brainstation. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        println("You've got an image");
    }
    
    @IBAction func launchCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            // imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes  = [kUTTypeImage!]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

