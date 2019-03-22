//
//  RocketLaunchViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD



class RocketLaunchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var rocketTableView: UITableView!
    
    private let launchUrl = "https://launchlibrary.net/1.4/launch"
    
    var shortAgencyName:String = ""
    var launchArray = [LaunchModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRocket()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launchArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RocketLaunchVCTableViewCell
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9448125, green: 0.9448125, blue: 0.9448125, alpha: 1)
        cell.rocketNameLabel?.text = launchArray[indexPath.row].name
        cell.shortNameLabel.text = launchArray[indexPath.row].shortName
        cell.rocketLaunchDate.text = launchArray[indexPath.row].launchDate
        
        switch launchArray[indexPath.row].status {
        case 1:
            cell.rocketStatusLabel.text = "Go"
        case 2:
            cell.rocketStatusLabel.text = "TBD"
        case 3:
            cell.rocketStatusLabel.text = "Success"
        case 4:
            cell.rocketStatusLabel.text = "Failure"
        case 5:
            cell.rocketStatusLabel.text = "Hold"
        case 6:
            cell.rocketStatusLabel.text = "In Flight"
        case 7:
            cell.rocketStatusLabel.text = "Partial Failure"
        default:
            cell.rocketStatusLabel.text = ""
        }
        
        return cell
    }
    
    
    private func loadRocket() {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        let params: [String : Any] = ["agency" : "\(shortAgencyName)", "limit" : 20]
        
        Alamofire.request(launchUrl, method: .get, parameters: params).validate().responseJSON { response in
            
            if response.result.value == nil {
                
                let launch = LaunchModel(name: "No Launch in this Agency", shortName: "", launchDate: "", status: nil)
                self.launchArray.append(launch)
                
            } else {
                
                let responseJSON: JSON = JSON(response.result.value!)
                //print(responseJSON)
                let rocketLaunchJSON = responseJSON["launches"]
                
                rocketLaunchJSON.array?.forEach({ (launches) in
                    let launch = LaunchModel(name: launches["name"].stringValue, shortName: "\(self.shortAgencyName)", launchDate: launches["net"].stringValue, status: launches["status"].intValue)
                    self.launchArray.append(launch)
                    
                })
                
            }
            
            //self.agencyArray = self.agencyArray.sorted { $0.name < $1.name }
            SVProgressHUD.dismiss()
            //print(self.launchArray)
            self.rocketTableView.reloadData()
            
        }
        
    }
    
    
}
