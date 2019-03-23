//
//  DetailViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD



class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailStatusLabel: UILabel!
    @IBOutlet weak var detailShortNameLabel: UILabel!
    @IBOutlet weak var detailRocketNameLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailWideoButton: UIButton!
    
    
    private let launchUrl = "https://launchlibrary.net/1.4/launch"
    var detailParam = [String : Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    @IBAction func detailWideoButton(_ sender: Any) {
    }
    
    
    
    private func loadDetails() {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        Alamofire.request(launchUrl, method: .get, parameters: detailParam).validate().responseJSON { response in
            
            if response.result.value == nil {
                
                self.detailNameLabel.text = "No details"
                
            } else {
                
                let responseJSON: JSON = JSON(response.result.value!)
                print(responseJSON)
                
                self.detailNameLabel.text = responseJSON["launches"][0]["status"].stringValue
                self.detailDateLabel.text = responseJSON["launches"][0]["net"].stringValue
                self.detailStatusLabel.text = responseJSON["launches"][0]["status"].stringValue
                self.detailShortNameLabel.text = responseJSON["launches"][0]["net"].stringValue
                self.detailRocketNameLabel.text = responseJSON["launches"][0]["net"].stringValue
                //self.detailImageView.text = ""
                //self.detailWideoButton.text = ""
                print(responseJSON["launches"][0]["status"].stringValue)
                print(responseJSON["launches"][0]["net"].stringValue)
                print(responseJSON["launches"][0]["status"].stringValue)
                print(responseJSON["launches"][0]["net"].stringValue)
              print(responseJSON["launches"][0]["net"].stringValue)
                
                
//                let rocketLaunchJSON = responseJSON["launches"]
//                print(responseJSON)
                
//                rocketLaunchJSON.array?.forEach({ (launches) in
//                    let launch = LaunchModel(name: launches["name"].stringValue, shortName: "\(self.shortAgencyName)", launchDate: launches["net"].stringValue, status: launches["status"].intValue)
//                    self.launchArray.append(launch)
//                    
//                })
                
            }
            
            SVProgressHUD.dismiss()
            
        }
        
    }
    
}
