//
//  DevelopersViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 12/29/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class DevelopersViewController: ParentViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            tableView.register(UINib(nibName: String(describing: DevelopersTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DevelopersTableViewCell.self))
        }
    }
    
    var images = ["majd.jpg", "wannous.jpg", "wajeeh.jpg", "kinan.jpg"]
    var names = ["Majd Ajaj", "Mohamed Thulfikar Wannous", "MHD Wajeeh Ajajeh", "Kinan Alsakka"]
    var titles = ["iOS Developer", "Backend/Web Developer", "Android Developer", "UI/UX Designer"]
    var bios = ["""
           iOS Developer
           AI Engineer from DU
           Competitive programmer at ICPC
           """, """
           Software engineer Works at syriatel telecom as Web Developer since 2017
           """, """
           AI Engineer specialized in Image Processing and Machine Learning
           """, """
           Software engineer work at Syriatel and volonter at syrian researchers as graphic design team leader
           """]
    var facebookLinks = ["https://www.facebook.com/majd.ajaj.94", "https://www.facebook.com/eng.mthw", "https://www.facebook.com/mhd.wajeeh.7", "https://www.facebook.com/kinan.alsakka"]
    var linkedinLinks = ["https://www.linkedin.com/in/majd-ajaj-73b120a9/", "https://www.linkedin.com/in/mohamed-thulfikar-wannous-0692ba124/", "https://www.linkedin.com/in/mhdwajeeh95/", "https://www.linkedin.com/in/kinan-alsakka-b398a3104/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cross Developers"
    }

}

extension DevelopersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DevelopersTableViewCell.self)) as! DevelopersTableViewCell
        cell.nameLabel.text = names[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        cell.cellImageView.image = UIImage(named: images[indexPath.row])
        cell.descriptionLabel.text = bios[indexPath.row]
        cell.facebookLink = URL(string: facebookLinks[indexPath.row])!
        cell.linkdinLink = URL(string: linkedinLinks[indexPath.row])!
        return cell
    }
    
}
