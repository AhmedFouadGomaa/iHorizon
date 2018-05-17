//
//  InnerVC.swift
//  iHorizon
//
//  Created by ahmed.fouadgomaa on 5/16/18.
//  Copyright © 2018 ahmedfouad. All rights reserved.
//

import Foundation
import UIKit

class InnerVC : UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tvSubscribers: UITableView!
    @IBOutlet weak var lblReboName: UILabel!
    @IBOutlet weak var lblNoSubscribers: UILabel!
    
    var dicItem: NSDictionary = NSDictionary()
    var gitArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvSubscribers.tableFooterView = UIView()
        dataBinding()
        getSubscribers()
    }
    
    func dataBinding() {
        lblReboName.text = dicItem.value(forKey: "full_name") as? String
        lblNoSubscribers.text = String(self.gitArray.count)
    }
    
    func getSubscribers() {
        let myHandler = HTTPHandler()
        myHandler.getWebServiceCall(urlString: (dicItem.value(forKey: "subscribers_url") as? String)!, completion: { (res , successBool, error) in
            if(successBool)!{
                if let data = (res as! String).data(using: String.Encoding.utf8) {
                    do {
                        if let resJSON = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]  {
                            self.gitArray = resJSON as NSArray
                            print(self.gitArray)
                            self.lblNoSubscribers.text = "Number of Subscribers is = "+String(self.gitArray.count)
                            self.tvSubscribers.reloadData()
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }else if let error = error{
                print(error)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gitArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.textAlignment = .center
        if let dic:NSDictionary = self.gitArray.object(at: indexPath.section) as? NSDictionary{
            cell.textLabel?.text = dic.value(forKey: "login") as? String
        }
        
        return cell
    }
}


    

