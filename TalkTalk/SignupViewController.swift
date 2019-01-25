//
//  SignupViewController.swift
//  TalkTalk
//
//  Created by heojowon on 21/01/2019.
//  Copyright © 2019 heojowon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        color = remoteConfig["bi_color"].stringValue
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        signupButton.backgroundColor = UIColor(hex: color!)
        
        signupButton.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    // UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        return true
    }
    
    @objc func imagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.imageView.clipsToBounds = true;
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
            if(error != nil) {
                let alert = UIAlertController(title: "error", message: error.debugDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else {
                let uid = Auth.auth().currentUser!.uid
                let image = self.imageView.image?.jpegData(compressionQuality: 0.1)
                let imageUrl = Storage.storage().reference().child("userImages").child(uid)
                let values = ["userName":self.userNameField.text!, "profileImageUrl":imageUrl, "uid":uid] as [String : Any]
                
                imageUrl.putData(image!, metadata: nil, completion: {(StorageMetadata, Error) in
                    
                    imageUrl.downloadURL(completion: { (url, err) in
                        Database.database().reference().child("users").child(uid).setValue(["userName":self.userNameField.text!, "profileImageUrl":url?.absoluteString, "uid":Auth.auth().currentUser?.uid])
                        
                    })
                })
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispase of any resources that can be recreated.
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
