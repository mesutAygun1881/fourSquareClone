//
//  AddPlaceVC.swift
//  fourSquareClone
//
//  Created by mesutAygun on 20.03.2021.
//

import UIKit

class AddPlaceVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphere: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        
        
        placeImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc   func    selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && placeAtmosphere.text != "" {
            if let chosenImage = placeImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeAtmosphere = placeAtmosphere.text!
                placeModel.placeImage = chosenImage
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            let alert = UIAlertController(title: "Error", message: "please try again", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        
     
        
    }
    
}
