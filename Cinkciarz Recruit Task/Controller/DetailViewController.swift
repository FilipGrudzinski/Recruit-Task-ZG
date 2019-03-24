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
    
    override func viewWillDisappear(_ animated: Bool) {
        detailAgencyArray.removeAll()
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
        
    }
    
    
    private func setImage() {
        
        if detailLaunchArray[0].rocketImageUrl.isEmpty {
            
            detailImageView.image = nil
            
        } else {
            
            detailImageView.kf.setImage(with: URL(string: detailLaunchArray[0].rocketImageUrl))
        }
        
        
    }
    
    
    
    
}
