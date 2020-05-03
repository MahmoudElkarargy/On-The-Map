//
//  TableViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientData.ClientsDataLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.setCell(text: ClientData.ClientsDataLocations[indexPath.row].firstName + " " + ClientData.ClientsDataLocations[indexPath.row].lastName)
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to url
        guard let url = URL(string: ClientData.ClientsDataLocations[indexPath.row].mediaURL) else{
            self.showError(title: "Can't Open URL",message: "URL not valid or student did not provide it")
            return
        }
        UIApplication.shared.open(url, options: [:]){ success in
            guard success == true else{
                self.showError(title: "Can't Open URL",message: "URL not valid or student did not provide it")
                return
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
   

}
