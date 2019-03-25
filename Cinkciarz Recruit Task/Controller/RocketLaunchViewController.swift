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



class RocketLaunchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var rocketTableView: UITableView!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    
    private let refreshControl = UIRefreshControl()
    private let datePicker = UIDatePicker()
    
    private let launchUrl = "https://launchlibrary.net/1.4/launch/"
    private var launchRocketArray = [LaunchRocketModel]()
    private var defaultParam = [String : Any]()
    private var currentParam = [String : Any]()
    private var nillaunchesText = ""
    private var todaysDate = ""
    private var fromDate = ""
    private var toDate = ""
    private var totalLaunches = 0
    private var shortName = ""
    
    var rocketAgencyArray = [AgencyModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shortName = rocketAgencyArray[0].agencyShortName
        
        setupView()
        refreshControl.addTarget(self, action: #selector(refresData(_:)), for: .valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        todaysDate = dateFormatter.string(from: Date())
        
        defaultParam = ["lsp" : shortName, "startdate":"\(todaysDate)", "limit" : 20, "sort" : "desc"]
        currentParam = defaultParam
        
        loadRocket(defaultParam)
        
    }
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            
            cell.rocketNameLabel.text = nillaunchesText
            
        } else {
            
            cell.rocketNameLabel.text = launchRocketArray[indexPath.row].launchName
            cell.shortNameLabel.text = rocketAgencyArray[0].agencyShortName
            cell.rocketLaunchDate.text = launchRocketArray[indexPath.row].launchDate
            cell.rocketStatusLabel.text = launchRocketArray[indexPath.row].launchstatus
            
        }
        
        paggingLoadMoreLaunches(indexPath.row)
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func filterButton(_ sender: Any) {
        
        self.launchRocketArray.removeAll()
        self.view.endEditing(true)
        setFilter()
        
    }
    
    
    
    private func setupView() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        title = "Launches " + shortName
        
        dateFromTextField.addTarget(self, action: #selector(myTargetFromFunction), for: UIControl.Event.touchDown)
        dateToTextField.addTarget(self, action: #selector(myTargetToFunction), for: UIControl.Event.touchDown)
        
        datePicker.datePickerMode = .date
        
        if #available(iOS 10.0, *) {
            
            rocketTableView.refreshControl = refreshControl
            
        } else {
            
            rocketTableView.addSubview(refreshControl)
            
        }
        
    }
    
    
}



//MARK: - Extension for Data request and Json save

extension RocketLaunchViewController {
    
    
    
    private func loadRocket(_ parameters:[String : Any]) {
        
        SVProgressHUD.show(withStatus: "In Progress")
        
        Alamofire.request(self.launchUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
            if response.result.value != nil {
                
                let responseJSON: JSON = JSON(response.result.value!)
                //print(responseJSON)
                self.totalLaunches = responseJSON["total"].intValue
                //print(self.totalLaunches)
                self.savingJson(responseJSON)
                
            } else {
                
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                self.nillaunchesText = "No Launch in this Agency from this date (default today)"
                self.rocketTableView.reloadData()
            }
            
        }
        
    }
    
    
    private func savingJson(_ json: JSON) {
        
        nillaunchesText = ""
        let rocketLaunchJSON = json["launches"]
        //print(rocketLaunchJSON)
        rocketLaunchJSON.array?.forEach({ (launches) in
            
            let stringStatus = self.getStatus(launches["status"].intValue)
            
            let launch = LaunchRocketModel(launchName: launches["name"].stringValue, launchDate: launches["net"].stringValue, launchstatus: stringStatus,  rocketName: launches["rocket"]["name"].stringValue, rocketImageUrl: launches["rocket"]["imageURL"].stringValue, rocketWideoUrl: launches["vidURLs"][0].stringValue)
            
            self.launchRocketArray.append(launch)
            
        })
        
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        self.rocketTableView.reloadData()
        
    }
    
    
    @objc private func refresData(_ sender: Any) {
        
        self.nillaunchesText = ""
        self.launchRocketArray.removeAll()
        self.rocketTableView.reloadData()
        
        SVProgressHUD.show(withStatus: "In Progress")
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            
            self.loadRocket(self.currentParam)
            
        }
        
    }
    
    
    private func paggingLoadMoreLaunches(_ lastIndexFromTableWiew: Int) {
        
        if lastIndexFromTableWiew == launchRocketArray.count - 1 {
            
            if totalLaunches > launchRocketArray.count {
                
                let offset = launchRocketArray.count
                self.currentParam["offset"] = offset
                self.loadRocket(currentParam)
                
            }
            
        }
        
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
    
    
    private func setFilter() {
        
        if dateFromTextField.text != "" && dateToTextField.text != "" {
            
            self.fromDate = dateFromTextField.text!
            self.toDate = dateToTextField.text!
            currentParam = ["lsp" : shortName,"startdate": fromDate, "enddate": toDate, "limit" : 20, "sort" : "desc"]
            self.loadRocket(currentParam)
            
            
        } else if dateFromTextField.text != "" {
            
            self.fromDate = dateFromTextField.text!
            currentParam = ["lsp" : shortName, "startdate": self.fromDate, "limit" : 20, "sort" : "asc"]
            loadRocket(currentParam)
            
        } else if dateToTextField.text != "" {
            
            self.toDate = dateToTextField.text!
            currentParam = ["lsp" : shortName, "enddate": self.toDate, "limit" : 20, "sort" : "asc"]
            loadRocket(currentParam)
            
        } else {
            
            currentParam = defaultParam
            loadRocket(currentParam)
            
        }
        
    }
    
    
}



extension RocketLaunchViewController {
    
    
    
    @objc func myTargetFromFunction(textField: UITextField) {
        textField.tag = 1
        self.shwoDataPicker(textField.tag)
    }
    
    @objc func myTargetToFunction(textField: UITextField) {
        textField.tag = 2
        self.shwoDataPicker(textField.tag)
    }
    
    
    private func shwoDataPicker(_ tag: Int) {
        //Formate Date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        if tag == 1 {
            
            let doneButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(dateFromFromDate));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker));
            
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            
            dateFromTextField.inputView = datePicker
            dateFromTextField.inputAccessoryView = toolbar
            
        } else if tag == 2 {
            
            let doneButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(dateFromToDate));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker));
            
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            
            dateToTextField.inputView = datePicker
            dateToTextField.inputAccessoryView = toolbar
            
        }
        
    }
    
    
    @objc func dateFromFromDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFromTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    @objc func dateFromToDate() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
}
