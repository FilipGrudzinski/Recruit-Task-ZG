//
//  DetailViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailStatusLabel: UILabel!
    @IBOutlet weak var detailShortNameLabel: UILabel!
    @IBOutlet weak var detailRocketNameLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailWideoButton: UIButton!
    
    
    private let detialRockethUrl = "https://launchlibrary.net/1.4/rocket/"
    var detailAgencyArray = [AgencyModel]()
    var detailLaunchArray = [LaunchRocketModel]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //detailWideoButton.isHidden = true
        setLabelData()
        print(detailLaunchArray[0].rocketWideoUrl)
        
    }
    
    @IBAction func detailWideoButton(_ sender: Any) {
        
        if let requestUrl = NSURL(string: "\(detailLaunchArray[0].rocketWideoUrl)") {
            
            UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    private func setLabelData() {
        
        let rocketName = detailLaunchArray[0].rocketName
        
        self.detailNameLabel.text = detailAgencyArray[0].agencyName
        self.detailDateLabel.text = detailLaunchArray[0].launchDate
        self.detailStatusLabel.text = detailLaunchArray[0].launchstatus
        self.detailShortNameLabel.text = detailAgencyArray[0].agencyShortName
        self.detailRocketNameLabel.text = rocketName.isEmpty ? "Nieznana" : "\(rocketName)"
        
        if detailLaunchArray[0].rocketWideoUrl.isEmpty {
            
            detailWideoButton.isHidden = true
            
        } else {
            
             detailWideoButton.isHidden = false
            
        }
        
        if detailLaunchArray[0].rocketImageUrl.isEmpty {
            
            
        } else {
            
            
        }
        
        
    }
    
    
    
    
}
