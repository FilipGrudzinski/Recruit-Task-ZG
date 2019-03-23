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


class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailStatusLabel: UILabel!
    @IBOutlet weak var detailShortNameLabel: UILabel!
    @IBOutlet weak var detailRocketNameLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailWideoButton: UIButton!
    
    
    private let launchUrl = "https://launchlibrary.net/1.4/launch"
    var detailAgencyArray = [AgencyModel]()
    var detailLaunchArray = [LaunchModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(detailLaunchArray[0].id)
        let param = ["rocket" : "\(detailLaunchArray[0].id!)"]
        Alamofire.request("https://launchlibrary.net/1.4/rocket", method: .get, parameters: param).validate().responseJSON { response in
            
            
            let responseJSON: JSON = JSON(response.result.value!)
            let rocketLaunchJSON = responseJSON["launches"]
            print(rocketLaunchJSON)
            
            
        }
        
    }
    
    @IBAction func detailWideoButton(_ sender: Any) {
    }
    
    private func loadData() {
        
        self.detailNameLabel.text = detailAgencyArray[0].name
        self.detailDateLabel.text = detailLaunchArray[0].launchDate
        self.detailStatusLabel.text = detailLaunchArray[0].status
        self.detailShortNameLabel.text = detailAgencyArray[0].shortName
        self.detailRocketNameLabel.text = detailLaunchArray[0].rocketName
        //self.detailImageView.text = ""
        //self.detailWideoButton.text = ""
        
    }
    
    
}
