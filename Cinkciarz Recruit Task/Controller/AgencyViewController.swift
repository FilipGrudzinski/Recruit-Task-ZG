//
//  MainViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AgencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var agencyArray = [AgencyModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        loadAgency()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainVCTableViewCell
        
        cell.nameLabel.text = "\(agencyArray[indexPath.row].name) (\(agencyArray[indexPath.row].shortName))"
        cell.countryCodeLabel.text = agencyArray[indexPath.row].countryCode
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToRocketLaunchVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRocketLaunchVC" {
            
            let rocketVC = segue.destination as! RocketLaunchViewController
            
            rocketVC.agencyID = self.agencyArray[self.tableView!.indexPathForSelectedRow!.row].id
                
        }
    }
    
    
    
    private func loadAgency() {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        let url = "https://launchlibrary.net/1.4/lsp"
        
        Alamofire.request(url, method: .get ).validate().responseJSON { response in
            
            let responseJSON: JSON = JSON(response.result.value!)
            let agenciesJSON = responseJSON["agencies"]
            
            agenciesJSON.array?.forEach({ (agencies) in
                let agency = AgencyModel(id: agencies["id"].intValue, name: agencies["name"].stringValue, countryCode: agencies["countryCode"].stringValue, shortName: agencies["abbrev"].stringValue)
                self.agencyArray.append(agency)
                
            })
            
            self.agencyArray = self.agencyArray.sorted { $0.name < $1.name }
            SVProgressHUD.dismiss()
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
}
