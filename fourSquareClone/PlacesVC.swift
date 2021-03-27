//
//  PlacesVC.swift
//  fourSquareClone
//
//  Created by mesutAygun on 20.03.2021.
//

import UIKit
import Parse
class PlacesVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceID = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId as? String {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
           
                
            
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceID = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as? DetailsVC
            destinationVC?.chosenPlaceId = selectedPlaceID
        }
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target:self, action: #selector(logoutButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromParse()
    }
    
    @objc func addButtonClicked () {
        self.performSegue(withIdentifier: "toAddPlaceVc", sender: nil)
        
    }
    
    @objc func logoutButtonClicked() {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
            
        }
        
        
        
        
    }

    
    
}
