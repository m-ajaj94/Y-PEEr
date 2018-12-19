//
//  MainTabBarController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/16/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit
import SideMenu

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var selectedTab: Int = 0
    
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
        delegate = self
        sideMenuViewController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateInitialViewController() as? SideMenuViewController
        tabBar.unselectedItemTintColor = .shadeOrange
    }
    
    func showSideMenu(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == selectedTab{
            switch selectedTab{
            case 0:
                if let navigationController = viewControllers![selectedTab] as? UINavigationController, let controller = navigationController.viewControllers.last! as? PostsViewController{
                    controller.tableView.setContentOffset(CGPoint(x: controller.tableView.contentOffset.x, y: 0), animated: true)
                }
                break
            case 1:
                if let navigationController = viewControllers![selectedTab] as? UINavigationController, let controller = navigationController.viewControllers.last! as? GalleryViewController{
                    controller.collectionView.setContentOffset(CGPoint(x: controller.collectionView.contentOffset.x, y: 0), animated: true)
                }
                break
            case 2:
                if let navigationController = viewControllers![selectedTab] as? UINavigationController, let controller = navigationController.viewControllers.last! as? EventsViewController{
                    controller.tableView.setContentOffset(CGPoint(x: controller.tableView.contentOffset.x, y: 0), animated: true)
                }
                break
            case 3:
                if let navigationController = viewControllers![selectedTab] as? UINavigationController, let controller = navigationController.viewControllers.last! as? IssuesViewController{
                    controller.collectionView.setContentOffset(CGPoint(x: controller.collectionView.contentOffset.x, y: 0), animated: true)
                }
                break
            case 4:
                if let navigationController = viewControllers![selectedTab] as? UINavigationController, let controller = navigationController.viewControllers.last! as? QuizzesViewController{
                    controller.tableView.setContentOffset(CGPoint(x: controller.tableView.contentOffset.x, y: 0), animated: true)
                }
                break
            default:
                break
            }
        }
        selectedTab = selectedIndex
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
