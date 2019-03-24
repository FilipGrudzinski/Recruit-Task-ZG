//
//  DetailViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailStatusLabel: UILabel!
    @IBOutlet weak var detailShortNameLabel: UILabel!
    @IBOutlet weak var detailRocketNameLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailWideoButton: UIButton!
    
    
    var detailAgencyArray = [AgencyModel]()
    var detailLaunchArray = [LaunchRocketModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelData()
        //setImage()

    }
    
    
    @IBAction func detailWideoButton(_ sender: Any) {
        
        if let requestUrl = NSURL(string: "\(detailLaunchArray[0].rocketWideoUrl)") {
            
            UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    private func setLabelData() {
        
        let rocketName = detailLaunchArray[0].rocketName
        
        detailNameLabel.text = detailAgencyArray[0].agencyName
        detailDateLabel.text = detailLaunchArray[0].launchDate
        detailStatusLabel.text = detailLaunchArray[0].launchstatus
        detailShortNameLabel.text = detailAgencyArray[0].agencyShortName
        detailRocketNameLabel.text = rocketName.isEmpty ? "Nieznana" : "\(rocketName)"
        //detailImageView.kf.setImage(with: URL(string: detailLaunchArray[0].rocketImageUrl))
        
        if detailLaunchArray[0].rocketWideoUrl.isEmpty {
            
            detailWideoButton.isHidden = true
            
        } else {
            
            detailWideoButton.isHidden = false
            
        }
        
    }
    
    
    private func setImage() {
        
        if detailLaunchArray[0].rocketImageUrl.isEmpty {
            
            detailImageView.image = nil
            
        } else {
            
            
        }
        
        
    }
    
    
    
    
}
