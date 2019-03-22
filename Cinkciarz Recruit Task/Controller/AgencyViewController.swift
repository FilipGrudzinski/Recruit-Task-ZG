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
    
    private let agencyUrl = "https://launchlibrary.net/1.4/lsp?limit=100"
    private var agencyArray = [AgencyModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAgency()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agencyArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainVCTableViewCell
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9448125, green: 0.9448125, blue: 0.9448125, alpha: 1)
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
            
            rocketVC.shortAgencyName = self.agencyArray[self.tableView!.indexPathForSelectedRow!.row].shortName
            
        }
    }
    
    
    private func loadAgency() {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        Alamofire.request(agencyUrl, method: .get ).validate().responseJSON { response in
            
            if response.value == nil {
                
                print("No item")
                
            } else {
                
                let responseJSON: JSON = JSON(response.result.value!)
                //print(responseJSON)
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
    
    
}
