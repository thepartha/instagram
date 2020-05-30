//
//  UserTableViewController.swift
//  instagram
//
//  Created by Partha Sarathy on 5/28/20.
//  Copyright © 2020 Partha Sarathy. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var userNames: [String] = []
    var objectIDs: [String] = []
    var isFollowing :[String: Bool] = [:]
    
    var refresher: UIRefreshControl = UIRefreshControl()
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    @objc func updateTable() {
        
        let query = PFUser.query()
        if let currnetUserName = PFUser.current()?.username {
            query?.whereKey("username", notEqualTo: currnetUserName)
        }
        
        
        query?.findObjectsInBackground(block: { (users, error) in
            if let safeError = error {
                print(safeError.localizedDescription)
            } else if let users = users {
                
                self.userNames.removeAll()
                self.objectIDs.removeAll()
                self.isFollowing.removeAll()
                
                for object in users {
                    if let user = object as? PFUser {
                        if let username = user.username {
                            
                            let usernameArray = username.components(separatedBy: "@")
                            self.userNames.append(usernameArray[0])
                            if let objectId = user.objectId {
                                self.objectIDs.append(objectId)
                                
                                let query = PFQuery(className: "Following")
                                
                                query.whereKey("Follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("Following", equalTo: objectId)
                                
                                query.findObjectsInBackground { (objects, error) in
                                    
                                    if let objects = objects {
                                        if  objects.count > 0 {
                                            self.isFollowing[objectId] = true
                                        } else {
                                            self.isFollowing[objectId] = false
                                        }
                                        
                                        if self.userNames.count == self.isFollowing.count {
                                            
                                            self.tableView.reloadData()
                                            self.refresher.endRefreshing()
                                        }
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       updateTable()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(updateTable), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refresher)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = userNames[indexPath.row]
        if let followsBollen =  isFollowing[objectIDs[indexPath.row]]  {
            if followsBollen {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let followingBollean = isFollowing[objectIDs[indexPath.row]] {
            
            if followingBollean {
                isFollowing[objectIDs[indexPath.row]] = false
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                
                let query = PFQuery(className: "Following")
                
                query.whereKey("Follower", equalTo: PFUser.current()?.objectId)
                query.whereKey("Following", equalTo: objectIDs[indexPath.row])
                
              
                query.findObjectsInBackground (block: { (objects, error) in

                    if let safeError = error {
                        print(safeError.localizedDescription)
                    } else {
                        if let objects = objects {
                         for object in objects {
      
                                object.deleteInBackground()
                            }
                        }
                    }
                    
                })
                
            } else {
                    isFollowing[objectIDs[indexPath.row]] = true
                
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                      
                      let following = PFObject(className: "Following")
                      
                      following["Follower"] = PFUser.current()?.objectId
                      
                      following["Following"] = objectIDs[indexPath.row]
                      
                      following.saveInBackground()
            }
            
        }
        
      
        
    }
}
