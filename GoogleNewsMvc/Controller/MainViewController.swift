//
//  MainViewController.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var news = [News]()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkFirstLogin()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    
    @objc private func didPullToRefresh(_ sender: Any) {
        refreshControl.beginRefreshing()
        RequestNews.getDatas { (check, response,count , err) in
            if let err = err {
                print("error:", err)
                self.refreshControl.endRefreshing()
            } else {
                self.news = response!.articles
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.news), forKey:"songs")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func setupUI(){
        collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }
    
    private func checkFirstLogin(){
        if  !UserDefaults.getFirstLogin() { //check if it is very first login
            UserDefaults.setFirstLogin(login: true)
            if let reachability = Reachability(), !reachability.isReachable{ //if connection available, no data to show, connection error
                present(AlertController.presentAlert(title: "Connection Error", message: "check your connection and try again.", cancelMsg: "Cancel"), animated: true)
            } else { //first login but connection available, data is accessible
                pullDatas(firstLogin: true)
            }

        } else { //not the first login, show datas locally
            pullDatas(firstLogin: false)
        }
    }

       private func retrieveData() {
        do {
            if let data = UserDefaults.standard.value(forKey:"new") as? Data {
                let list = try? PropertyListDecoder().decode(Array<News>.self, from: data)
                self.news = list!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func pullDatas(firstLogin: Bool){
        if !firstLogin{ //not the first login, retrieve datas from local
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.retrieveData()
            })
        } else if firstLogin {
            RequestNews.getDatas { (check, response,count , err) in
                if let err = err {
                    print("error occured:", err)
                } else {
                    self.news = response!.articles
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.news), forKey:"new")
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else{
            fatalError()
        }
        cell.setup(data: self.news[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = mainStoryBoard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        contentVC.selectedUrl = self.news[indexPath.row].url ?? ""
        self.navigationController?.pushViewController(contentVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: Int = 200
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalWidth = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            cellSize = Int((collectionView.bounds.width -  totalWidth))
        case .pad:
            // It's an iPad (or macOS Catalyst)
            cellSize = Int((collectionView.bounds.width / 2 -  totalWidth))
        case .unspecified:
            cellSize = Int((collectionView.bounds.width -  totalWidth))
        case .tv:
            cellSize = Int((collectionView.bounds.width -  totalWidth))
        case .carPlay:
            cellSize = Int((collectionView.bounds.width -  totalWidth))
        @unknown default:
            cellSize = Int((collectionView.bounds.width -  totalWidth))
        }
        
        return CGSize(width: cellSize, height: 330)
    }
}
