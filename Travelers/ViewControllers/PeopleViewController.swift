//
//  PeopleViewController.swift
//  Travelers
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 IdanOmer. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 81
        
        tableView.rowHeight = UITableView.automaticDimension
        
        loadUsers()
    }
    
    func loadUsers(){
        API.User.observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    //check if a user is following or not
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void){
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    //getting the sender that sent before the segue has began
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue"{
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }

}
extension PeopleViewController: UITableViewDataSource {
    //seting the amount of cells we want to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //set the cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
    
    
}
extension PeopleViewController: PeopleTableViewCellDelegate{
    //performing segue to profileUser view
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
    }
}

extension PeopleViewController: HeaderProfileCollectionReusableViewDelegate{
    func updateFollowButton(forUser user: User) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
