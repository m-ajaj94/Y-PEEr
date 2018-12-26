//
//  StoriesViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/26/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class StoriesViewController: ParentViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateStory", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
