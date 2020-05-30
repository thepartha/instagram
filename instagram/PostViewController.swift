//
//  PostViewController.swift
//  instagram
//
//  Created by Partha Sarathy on 5/30/20.
//  Copyright © 2020 Partha Sarathy. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var comment: UITextField!
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func postImage(_ sender: Any) {
       
        
        if let image = imageToPost.image
        {
            let post = PFObject(className: "Post")
            
            post["message"] = comment.text
            
            post["userid"] = PFUser.current()?.objectId
            
            if let imageData = image.pngData() {
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                           
                activityIndicator.center = CGPoint(x: 178, y: 476)
                           
                           activityIndicator.hidesWhenStopped = true
                           
                           activityIndicator.style = UIActivityIndicatorView.Style.medium
                           
                           view.addSubview(activityIndicator)
                           
                           activityIndicator.startAnimating()
                           
                           view.isUserInteractionEnabled = false
                
                let imageFile = PFFileObject(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                
                post.saveInBackground { (success, error) in
                    self.view.isUserInteractionEnabled = true
                    activityIndicator.stopAnimating()
                    
                    if success {
                        print("Saved Successfully")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                    } else {
                        if let safeError = error {
                                print(safeError.localizedDescription)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let pickerViewController = UIImagePickerController()
        
        pickerViewController.sourceType = .photoLibrary
        
        pickerViewController.delegate = self
        
        pickerViewController.allowsEditing = true
        
        self.present(pickerViewController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        imageToPost.image = image
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
