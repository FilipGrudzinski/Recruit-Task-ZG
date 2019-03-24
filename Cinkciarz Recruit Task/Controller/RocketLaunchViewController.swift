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
    
    
    var rocketAgencyArray = [AgencyModel]()
    private let refreshControl = UIRefreshControl()
    private let launchUrl = "https://launchlibrary.net/1.4/launch/"
    private var launchRocketArray = [LaunchRocketModel]()
    private var param = [String : Any]()
    private var noItemLabel = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        refreshControl.addTarget(self, action: #selector(refresData(_:)), for: .valueChanged)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = dateFormatter.string(from: date)
        
        param = ["lsp" : "\(rocketAgencyArray[0].agencyShortName)","enddate":"\(todaysDate)", "limit" : 10]
        loadRocket(param)
        SVProgressHUD.show(withStatus: "In Progress")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if launchRocketArray.count == 0 {

            return 1

        } else {
        
            return launchRocketArray.count
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RocketLaunchVCTableViewCell
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9448125, green: 0.9448125, blue: 0.9448125, alpha: 1)
        
        if launchRocketArray.count == 0 {
          
            cell.rocketNameLabel.text = noItemLabel
            
        } else {
            
            cell.rocketNameLabel.text = launchRocketArray[indexPath.row].launchName
            cell.shortNameLabel.text = rocketAgencyArray[0].agencyShortName
            cell.rocketLaunchDate.text = launchRocketArray[indexPath.row].launchDate
            cell.rocketStatusLabel.text = launchRocketArray[indexPath.row].launchstatus
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if launchRocketArray.count != 0 {
            
            performSegue(withIdentifier: "goToDetailVC", sender: self)
           
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetailVC" {
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.detailAgencyArray = rocketAgencyArray
            detailVC.detailLaunchArray = [launchRocketArray[self.rocketTableView.indexPathForSelectedRow!.row]]
            
        }
    }
    
    
    private func loadRocket(_ parameters:[String : Any]) {
        
        Alamofire.request(self.launchUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
            if response.result.value != nil {

                let responseJSON: JSON = JSON(response.result.value!)
                
                self.savingJson(responseJSON)
                
            } else {
                
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                self.noItemLabel = "No Launch in this Agency"
                self.rocketTableView.reloadData()
            }
           
        }
        
    }
    
    
    private func savingJson(_ json: JSON) {
        
        noItemLabel = ""
        let rocketLaunchJSON = json["launches"]
        //print(responseJSON)
        rocketLaunchJSON.array?.forEach({ (launches) in
            
            let stringStatus = self.getStatus(launches["status"].intValue)
            
            let launch = LaunchRocketModel(launchName: launches["name"].stringValue, launchDate: launches["net"].stringValue, launchstatus: stringStatus,  rocketName: launches["rocket"]["name"].stringValue, rocketImageUrl: launches["rocket"]["imageURL"].stringValue, rocketWideoUrl: launches["vidURLs"][0].stringValue)
            
            self.launchRocketArray.append(launch)
            
        })
        
        self.launchRocketArray = self.launchRocketArray.reversed()
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        self.rocketTableView.reloadData()
        
    }
    
    
    private func getStatus(_ id: Int) -> String {
        
        switch id {
        case 1:
            return "Go";
        case 2:
            return "TBD";
        case 3:
            return "Success";
        case 4:
            return "Failure";
        case 5:
            return "Hold";
        case 6:
            return "In Flight";
        case 7:
            return "Partial Failure";
        default:
            return ""
        }
        
    }
   
    @objc private func refresData(_ sender: Any) {
        
        self.noItemLabel = ""
        self.launchRocketArray.removeAll()
        self.rocketTableView.reloadData()
        
        SVProgressHUD.show(withStatus: "In Progress")
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            
            self.loadRocket(self.param)
            
        }
        
    }
    
    
    
    private func setupTableView() {
        
        if #available(iOS 10.0, *) {
            rocketTableView.refreshControl = refreshControl
        } else {
            rocketTableView.addSubview(refreshControl)
        }
        
    }
    
}
