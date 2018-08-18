//
//  ViewController.swift
//  FirebaseFileStorage
//
//  Created by Chhaileng Peng on 8/18/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit
import FirebaseStorage
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func upload(_ sender: UIButton) {
        SVProgressHUD.show()
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        // Create a reference to the file you want to upload
        let imageName = UUID().uuidString
        let storageReference = Storage.storage().reference().child("images/\(imageName).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = storageReference.putData(imageData!, metadata: nil) { (metadata, error) in
            SVProgressHUD.dismiss()
            // You can also access to download URL after upload.
            storageReference.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                print("Download URL:", downloadURL)
            }
        }
        
        uploadTask.resume()
        
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(browseImage))
        imageView.addGestureRecognizer(tabGesture)
        imageView.isUserInteractionEnabled = true
        
    }
    
    @objc func browseImage() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.browseByCamera()
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.browseByGallery()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func browseByCamera() {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func browseByGallery() {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}











