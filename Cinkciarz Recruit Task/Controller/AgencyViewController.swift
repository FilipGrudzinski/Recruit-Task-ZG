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
    
    private let refreshControl = UIRefreshControl()
    private let agencyUrl = "https://launchlibrary.net/1.4/lsp/"
    private var agencyArray = [AgencyModel]()
    private var noItemLabel = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        refreshControl.addTarget(self, action: #selector(refresData(_:)), for: .valueChanged)
        
        setupTableView()
        loadAgency()
       
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if agencyArray.count == 0 {
            
            return 1
            
        } else {
            
            return agencyArray.count
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainVCTableViewCell
        
        if agencyArray.count == 0 {
            
            cell.nameLabel.text = noItemLabel
            
        } else {
            
            cell.backgroundColor = indexPath.item % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9448125, green: 0.9448125, blue: 0.9448125, alpha: 1)
            cell.nameLabel.text = "\(agencyArray[indexPath.row].agencyName) (\(agencyArray[indexPath.row].agencyShortName))"
            cell.countryCodeLabel.text = agencyArray[indexPath.row].agencyCountryCode
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToRocketLaunchVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRocketLaunchVC" {
            
            let rocketVC = segue.destination as! RocketLaunchViewController
            
            rocketVC.rocketAgencyArray = [self.agencyArray[self.tableView!.indexPathForSelectedRow!.row]]
            
        }
    }
    
    
  
    private func setupTableView() {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
    }
    
}



//MARK: - Extension for Data request and Json save

extension AgencyViewController {
    
    private func loadAgency() {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        Alamofire.request(agencyUrl, method: .get).validate().responseJSON { response in
            
            if response.result.value != nil {
                
                let responseJSON: JSON = JSON(response.result.value!)
                
                self.savingJson(responseJSON)
                
            } else {
                
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                self.noItemLabel = "No Agency"
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    
    private func savingJson(_ json: JSON) {
        
        noItemLabel = ""
        
        let agenciesJSON = json["agencies"]
        
        agenciesJSON.array?.forEach({ (agencies) in
            let agency = AgencyModel(agencyName: agencies["name"].stringValue, agencyCountryCode: agencies["countryCode"].stringValue, agencyShortName: agencies["abbrev"].stringValue)
            
            self.agencyArray.append(agency)
            
        })
        
        self.agencyArray = self.agencyArray.sorted { $0.agencyName < $1.agencyName }
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    
    @objc private func refresData(_ sender: Any) {
        
        self.noItemLabel = ""
        self.agencyArray.removeAll()
        self.tableView.reloadData()
        
        SVProgressHUD.show(withStatus: "In Progress")
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            
            self.loadAgency()
            
        }
        
    }
    
}
