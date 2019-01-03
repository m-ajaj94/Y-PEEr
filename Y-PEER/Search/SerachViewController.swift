//
//  SerachViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 1/3/19.
//  Copyright © 2019 Majd Ajaj. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class SearchViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    let titles = ["Posts".localized, "Events".localized, "Issues".localized, "Articles".localized, "Quizzes".localized]
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let barItem = TMBarItem(title: titles[index])
        return barItem
    }
    

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.setLeftPaddingPoints(44)
            searchTextField.setRightPaddingPoints(16)
            searchTextField.layer.cornerRadius = 0
            searchTextField.layer.borderWidth = 1
            searchTextField.layer.borderColor = UIColor.mainOrange.cgColor
            searchTextField.textColor = .mainOrange
            searchTextField.placeholder = "Search".localized
            searchTextField.keyboardType = .webSearch
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search".localized
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.isUserInteractionEnabled = true
        self.view.insertSubview(backgroundImage, at: 0)
        hidesKeyboardOnTap()
        self.dataSource = self
        self.delegate = self
        let bar = TMBar.TabBar()
        bar.delegate = self
        bar.backgroundView.style = .blur(style: .extraLight)
        bar.buttons.customize { (button) in
            button.backgroundColor = .white
            button.imageViewSize = .zero
            button.tintColor = UIColor.darkGray
            button.selectedTintColor = .mainOrange
        }
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        reloadData()
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return 5
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        let controller = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: String(describing: SearchResultsViewController.self)) as! SearchResultsViewController
        controller.topInset = tabBarView.frame.origin.y + tabBarView.frame.height
        return controller
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
