//
//  IssuearticleViewController.swift
//  Y-PEER
//
//  Created by Majd Ajaj on 9/22/18.
//  Copyright © 2018 Majd Ajaj. All rights reserved.
//

import UIKit

class IssueArticleViewController: ParentViewController, UIScrollViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
            scrollView.delegate = self
            scrollView.alwaysBounceVertical = true
        }
    }
    
    var imageView: UIImageView!{
        didSet{
            view.addSubview(imageView)
            imageView.backgroundColor = .shadeOrange
            imageView.image = UIImage(named: "a.jpg")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
    }
    var height: CGFloat = 240
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.frame.size.width, height: max(0, -scrollView.contentOffset.y)))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.frame.size.width, height: max(0, -scrollView.contentOffset.y)))
    }
    

}
