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
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
    }
    var height: CGFloat = 240
    var article: ArticleModel!
    var lang: Cache.language.Language!{
        didSet{
            if lang == .arabic{
                titleLabel.text = article.titleAr!
                detailsLabel.text = article.descriptionAr!
                title = article.titleAr!
                titleLabel.textAlignment = .right
                detailsLabel.textAlignment = .right
            }
            else{
                titleLabel.text = article.titleEn!
                detailsLabel.text = article.descriptionEn!
                title = article.titleEn!
                titleLabel.textAlignment = .left
                detailsLabel.textAlignment = .left
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = Cache.language.current
        imageView = UIImageView()
        imageView.kf.setImage(with: Networking.getImageURL(article.images![0].imagePath!))
        setLanguageButton()
    }
    
    func setLanguageButton(){
        let button = UIBarButtonItem(image: UIImage(named: "Globe"), style: .done, target: self, action: #selector(changeLanguage))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func changeLanguage(){
        if lang == .english{
            lang = .arabic
        }
        else{
            lang = .english
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.frame.size.width, height: max(0, -scrollView.contentOffset.y)))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.frame.size.width, height: max(0, -scrollView.contentOffset.y)))
    }
    

}
