//
//  ViewController.swift
//  iHorizon
//
//  Created by ahmed.fouadgomaa on 5/15/18.
//  Copyright © 2018 ahmedfouad. All rights reserved.
//

import UIKit
import SDWebImage

class CustomHomeListing:UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblNoForks: UILabel!
    
}

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tvRepos: UITableView!
    let cellSpacingHeight: CGFloat = 10
    var gitArray = NSArray()
    var itemToPass:NSDictionary = NSDictionary()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tvRepos.register(UINib(nibName: "CustomHomeListing", bundle: nil), forCellReuseIdentifier: "custom")
        makeCall()
        self.tvRepos.rowHeight = UITableViewAutomaticDimension
        self.tvRepos.estimatedRowHeight = 44
    }
    
    func makeCall(){
        let myHandler = HTTPHandler()
        myHandler.getWebServiceCall(urlString: "https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc", completion: { (res , successBool, error) in
            if(successBool)!{
                if let data = (res as! String).data(using: String.Encoding.utf8) {
                    do {
                        let resJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
//                        print(resJSON!["items"]!)
                        self.gitArray = resJSON!["items"]! as! NSArray
                        
                        for item in self.gitArray{
                            
                            let dic:NSDictionary = item as! NSDictionary
                            print(dic["forks_count"]!)
                        }
                        self.tvRepos.reloadData()
                    } catch {
                        print("Something went wrong")
                    }
                }
            }else if let error = error{
                print(error)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomHomeListing = self.tvRepos.dequeueReusableCell(withIdentifier: "custom") as! CustomHomeListing
        
        if let dic:NSDictionary = self.gitArray.object(at: indexPath.section) as? NSDictionary{
            cell.lblName.text = dic["full_name"]! as? String
            
            let forksCount:Int32 = (dic["forks_count"]! as? Int32)!
            cell.lblNoForks.text = String(forksCount)
            cell.lblDescription.text = dic["description"]! as? String
            
            
            let owner :NSDictionary = dic.value(forKey: "owner") as! NSDictionary
            let avatarURL :String = owner.value(forKey: "avatar_url") as! String
            print(avatarURL)
            cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            cell.imgUser.clipsToBounds = true
            cell.imgUser.sd_setImage(with: URL(string: avatarURL), placeholderImage: UIImage(named: "userDefault"))
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gitArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "InnerVC", sender: indexPath);
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemToPass = (self.gitArray.object(at: indexPath.section) as? NSDictionary)!
        print(itemToPass)
        
        self.performSegue(withIdentifier: "InnerVC", sender: indexPath);
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InnerVC") as! ViewController
//        self.navigationController?.pushViewController(newViewController, animated: true)

        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "InnerVC") as UIViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let innerVC = segue.destination as! InnerVC
        innerVC.dicItem = itemToPass
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.height/5
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

