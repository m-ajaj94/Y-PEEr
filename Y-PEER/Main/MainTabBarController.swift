//
//  MainTabBarController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SideMenu

class MainTabBarController: UITabBarController {
    
    var sideMenuViewController: SideMenuViewController!{
        didSet{
            if sideMenuViewController != nil{
                let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuViewController)
                SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
                SideMenuManager.default.menuPresentMode = .viewSlideInOut
                SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 0.8
                SideMenuManager.default.menuAnimationTransformScaleFactor = 0.95
                SideMenuManager.default.menuLeftNavigationController!.isNavigationBarHidden = true
                SideMenuManager.default.menuAnimationBackgroundColor = .mainOrange
                SideMenuManager.default.menuFadeStatusBar = false
                SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
                sideMenuViewController.delegate = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuViewController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateInitialViewController() as? SideMenuViewController
    }
    
    func showSideMenu(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

}

extension MainTabBarController: SideMenuViewControllerDelegate{
    
    func didSelectSettings() {
        let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()!
        present(controller, animated: true, completion: nil)
    }
    
    func didSelectSearch() {
    }
    
    func didSelectAboutUs() {
        let controller = UIStoryboard(name: "AboutUs", bundle: nil).instantiateInitialViewController()!
        present(controller, animated: true, completion: nil)
    }
    
    func didSelectUser() {
        if UserCache.isLoggedIn{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
            //let controller = navController.viewControllers[0] as! ProfileViewController
            present(navController, animated: true, completion: nil)
        }
        else{
            let navController = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let controller = navController.viewControllers[0] as! SigninViewController
            controller.isModal = true
            present(navController, animated: true, completion: nil)
        }
    }
    
}
