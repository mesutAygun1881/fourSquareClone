//
//  DetailsVC.swift
//  fourSquareClone
//
//  Created by mesutAygun on 20.03.2021.
//

import UIKit
import MapKit
import  Parse


class DetailsVC: UIViewController {

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()

getDataFromParse()

}
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { [self] (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "please try again", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            detailsNameLabel.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            detailsTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                            if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                                if let placeLongitudeDouble = Double(placeLongitude) {
                                    self.chosenLongitude = placeLongitudeDouble
                                }
                        }
                            if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                                imageData.getDataInBackground { (data, error) in
                                    if error == nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                        
                                    }
                                }
                            }
                }
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.030, longitudeDelta: 0.030)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                        
            }
        }
    }
    
    }
        
    }
    
    
}
