//
//  CreateGardenVC.swift
//  
//
//  Created by Kareem Dasilva on 2/25/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CreateGardenVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var menuPriceTextField: UITextField!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var menuCategoryTextField: UITextField!
    @IBOutlet weak var previewImage: UIImageView!
    var selectedCategory:Category?
    @IBOutlet weak var menuDescriptionTextField: UITextField!
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
    var locationAddress:String?

   
    
  /*  func displayModifiers(){
        print(modifiers.debugDescription)
        guard let modifier = modifiers.first else {
            return
        }
        var modifiersString = ""
        for mod in modifiers {
            guard let title = mod.title  else {
                return
            }
            modifiersKeys.append(mod.key!)
            modifiersString = title + " " + modifiersString
        }
        modifierLabel.text = (modifiersString)
    }*/
    
    
 
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        }
    
    @IBAction func donePressed(_ sender: Any) {
        let fb = Firestore.firestore()
        var errorMessage = ""


        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
      
        })
        //protect all textfields
        guard let name = self.menuNameTextField.text, let price = self.menuPriceTextField.text, let menuDescription = self.menuDescriptionTextField.text, let category = self.menuCategoryTextField.text else {
            errorMessage = "Please fill out all information"
            let alertController = UIAlertController(
                title: "Error",
                message:errorMessage,
                preferredStyle: .alert
            )
            alertController.addAction(cancel)

            self.present(alertController, animated: true, completion: nil)

            return}
        
        //checks if price is double
        guard let priceDouble = Double(price) else {
            errorMessage = "Please recheck price on your menu item."
            let alertController = UIAlertController(
                title: "Error",
                message:errorMessage,
                preferredStyle: .alert
            )
            alertController.addAction(cancel)

            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        if self.menuPriceTextField.text == "" || menuNameTextField.text == "" {
            errorMessage = "Please fill out menu name and price field"
            let alertController = UIAlertController(
                title: "Error",
                message:errorMessage,
                preferredStyle: .alert
            )
            alertController.addAction(cancel)

            self.present(alertController, animated: true, completion: nil)
        } else {
        
        //Check IF EDITING
        
            
            
        //Starts process of uploading
        let imageName = name + UUID().uuidString
            var imageUrl:String?
            let STORAGE_BASE = Storage.storage().reference().child("Garden-Images")
            let ref = Firestore.firestore().collection("Gardens").document()
            print("kareem")
            print(ref.documentID)
            let gardenId = ref.documentID
            let storageRef = STORAGE_BASE.child(gardenId).child("\(imageName).jpeg")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            guard let image = self.previewImage.image else {return}
            //there is image
            if let uploadData = image.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData) { metaData , error in
                    
                            
                            if error == nil {
                                //save object
                                ref.setData(["name" : name, "yearBuilt": price, "description":menuDescription, "neighborHood":category, "preview":storageRef.fullPath] ) { (error) in
                                            if error != nil {
                                                print("Error Occured \(String(describing: error))")
                                                let alertController = UIAlertController(
                                                    title: "Error",
                                                    message:String(describing: error),
                                                    preferredStyle: .alert
                                                )
                                                alertController.addAction(cancel)
                                                self.present(alertController, animated: true, completion: nil)

                                            } else {
                                                print("No error happened")
                                                self.doneButton.isEnabled = false
                                                self.navigationController?.popViewController(animated: true)

                                                    }
                                                }

                                    
                                
                            } else {
                                print("error")
                                print(error.debugDescription)
                            }

                }
                            
                        
                        
                        
                    
                    

                

            }

                }
            }
        
    
   
    @IBAction func addPreviewPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
           
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
       
    @IBAction func addModiferBtn(_ sender: Any) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
     {
         guard let selectedImage = info[.originalImage] as? UIImage else {
             fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
         }
         previewImage.image = selectedImage
         self.dismiss(animated: true, completion: nil)

     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.navigationController?.navigationBar.isHidden = true
      

        
        //announcementTextView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        //displayModifiers()
    }
}





