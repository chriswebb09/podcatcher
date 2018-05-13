//
//  BackingViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

final class HomeBackingViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: HomeBackingViewControllerDelegate?
    let sliderBarView = UIView()
    private var thumbnailZoomTransitionAnimator: ImageTransitionAnimator?
    private var transitionThumbnail: UIImageView?
    var sliderControl = SliderControl()
    
    var backingView: UIView = UIView()
    var store = SearchResultsDataStore()
    var homeViewController: HomeViewController!
    
    var playlistsViewController: PlaylistsViewController = PlaylistsViewController()
    var interactor = SearchResultsIteractor()
    var browseViewController: BrowseViewController = BrowseViewController(index: 0)
    let globalDefault = DispatchQueue.global()
    
  let concurrentQueue = DispatchQueue( label: "com.main.queue", attributes: .concurrent)
    
    let concurrent = DispatchQueue(label: "concurrentBackground",
                                   qos: .background,
                                   attributes: .concurrent,
                                   autoreleaseFrequency: .inherit,
                                   target: nil)
    
    var currentEmbeddedVC: UIViewController {
        didSet {
            removeChild(controller: oldValue)
            embedChild(controller: currentEmbeddedVC, in: backingView)
        }
    }
    
    var managedContext: NSManagedObjectContext! {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.currentEmbeddedVC = UIViewController()
        super.init(nibName: nil, bundle: nil)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            concurrentQueue.async(flags: .assignCurrentContext) {
                appDelegate.dataStore.fetchBrowse { items, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let items = items else { return }
                    self.browseViewController.featuredItems = items
                    //podcastsStart = items
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            concurrentQueue.async(flags: .assignCurrentContext) {
                appDelegate.dataStore.fetchBrowse { items, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let items = items else { return }
                   // self.browseViewController.dataSource.
                   self.browseViewController.featuredItems = items
                    //browsePageController.topItems = items
                  
                  
                        //.podcastsStart = items
                }
            }
        }
        edgesForExtendedLayout = []
        browseViewController.delegate = self
    }
    
    func setupBrowse() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            concurrentQueue.async(flags: .assignCurrentContext) {
                appDelegate.dataStore.fetchBrowse { items, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let items = items else { return }
                    self.browseViewController.featuredItems = items 
                        //.browsePageController.topItems = items
                }
            }
        }
//        concurrent.async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.getCasterWorkaround { items, error in
//                if error != nil {
//                    DispatchQueue.main.async {
//                        let informationView = InformationView(data: "", icon: #imageLiteral(resourceName: "sad-face"))
//                        informationView.setIcon(icon: #imageLiteral(resourceName: "sad-face"))
//                        informationView.setLabel(text: "Oops! Unable to connect to iTunes server.")
//                        informationView.frame = UIScreen.main.bounds
//                        strongSelf.browseViewController.view = informationView
//                        strongSelf.browseViewController.view.layoutSubviews()
//                        strongSelf.browseViewController.hideLoadingView(loadingPop: strongSelf.browseViewController.loadingPop)
//                    }
//                } else {
//                    if strongSelf.browseViewController.dataSource.items.count > 0 {
//                        guard let urlString = strongSelf.browseViewController.dataSource.items[0].podcastArtUrlString else { return }
//                        guard let title = strongSelf.browseViewController.dataSource.items[0].podcastTitle else { return }
//                        guard let imageUrl = URL(string: urlString) else { return }
//                        strongSelf.browseViewController.browseTopView.setTitle(title: title)
//                        strongSelf.browseViewController.browseTopView.podcastImageView.downloadImage(url: imageUrl)
//                    }
//                }
//            }
//        }
    }
    
    
//    func getCasterWorkaround(completion: @escaping ([PodcastItem]?, Error?) -> Void) {
//        
//        var results = [PodcastItem]()
//        let topPodcastGroup = DispatchGroup()
//        var ids: [String] = ["201671138", "1268047665", "1264843400", "1212558767", "1200361736", "1150510297", "1097193327", "1250180134", "523121474", "1119389968", "1222114325", "1074507850", "173001861", "1028908750", "1279361017"]
//        for i in 0..<ids.count {
//            self.globalDefault.async(group: topPodcastGroup) { [weak self] in
//                guard let strongSelf = self else { return }
//                strongSelf.interactor.setLookup(term: ids[i])
//                strongSelf.interactor.searchForTracksFromLookup { result, arg  in
//                    if let error = arg {
//                        print(error.localizedDescription)
//                        completion(nil, error)
//                    }
//                    guard let resultItem = result else { return }
//                    resultItem.forEach { resultingData in
//                        guard let resultingData = resultingData else { return }
//                        if let caster = PodcastItem(json: resultingData) {
//                            results.append(caster)
//                            DispatchQueue.main.async {
//                                
//                                strongSelf.browseViewController.dataSource.items.append(caster)
//                                strongSelf.browseViewController.collectionView.reloadData()
//                                
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        print("Waiting for completion...")
//        topPodcastGroup.notify(queue: self.globalDefault) {
//            print("Notify received, done waiting.")
//            DispatchQueue.main.async {
//                self.browseViewController.hideLoadingView(loadingPop: self.browseViewController.loadingPop)
//                completion(results, nil)
//            }
//        }
//        topPodcastGroup.wait()
//        print("Done waiting.")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = []
        DispatchQueue.main.async {
            self.view.add(self.backingView)
            self.view.add(self.sliderControl)
            let titles = ["Subscribed", "Browse", "Playlists"]
            self.sliderControl.translatesAutoresizingMaskIntoConstraints = false
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 480:
                    print("iPhone Classic")
                case 960:
                    self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                    print("iPhone 4 or 4S")
                case 1136:
                    self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                    print("1136")
                case 1334:
                    self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                    print("1334")
                case 2208:
                    self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -8).isActive = true
                    print("2208")
                default:
                    self.sliderControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -8).isActive = true
                    print("default")
                }
            }
            
            self.sliderControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            self.sliderControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
            self.sliderControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.sliderBarView.layoutIfNeeded()
            self.sliderControl.layoutIfNeeded()
            self.sliderControl.isUserInteractionEnabled = true
            self.sliderControl.setSegmentItems(titles)
            self.sliderControl.delegate = self
            
            self.backingView.translatesAutoresizingMaskIntoConstraints = false
            self.backingView.topAnchor.constraint(equalTo: self.sliderControl.bottomAnchor, constant: 0).isActive = true
            self.backingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            self.backingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            self.backingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.backingView.layoutIfNeeded()
            
            self.currentEmbeddedVC = self.homeViewController
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = self.homeViewController.rightButtonItem
            }
        }
    }
}

extension HomeBackingViewController: SliderControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            currentEmbeddedVC = homeViewController
            DispatchQueue.main.async {
                self.title = "Podcasts"
                self.navigationItem.title = "Podcasts"
                self.navigationItem.rightBarButtonItem = self.homeViewController.rightButtonItem
                self.navigationItem.leftBarButtonItem = nil
                self.tabBarController?.tabBar.items?[0].title = "Home"
                self.tabBarController?.tabBar.items?[1].title = "Search"
                self.tabBarController?.tabBar.items?[2].title = "Setting"
            }
            
        case 1:
            currentEmbeddedVC = browseViewController
            DispatchQueue.main.async {
                //self.title = "Podcasts"
                self.navigationItem.title = "Podcasts"
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                self.tabBarController?.tabBar.items?[0].title = "Home"
                self.tabBarController?.tabBar.items?[1].title = "Search"
                self.tabBarController?.tabBar.items?[2].title = "Setting"
            }
        case 2:
            currentEmbeddedVC =  playlistsViewController
            DispatchQueue.main.async {
                
                self.navigationItem.title = "Podcasts"
                self.navigationItem.rightBarButtonItem = self.playlistsViewController.rightButtonItem
                self.navigationItem.leftBarButtonItem = self.playlistsViewController.leftButtonItem
                self.tabBarController?.tabBar.items?[0].title = "Home"
                self.tabBarController?.tabBar.items?[1].title = "Search"
                self.tabBarController?.tabBar.items?[2].title = "Setting"
            }
        default:
            currentEmbeddedVC = homeViewController
        }
    }
}

extension HomeBackingViewController: BrowseViewControllerDelegate {
    func selectedItem(at: Int, podcast: Podcast, imageView: UIImageView) {
        let feedUrlString = podcast.feedUrl
        let feedPodcast = podcast
        feedPodcast.podcastTitle = podcast.podcastTitle
        feedPodcast.podcastArtUrlString = podcast.podcastArtUrlString
        //  let nav = navigationController?.childViewControllers[0] as! UINavigationController
        //let backingVC = nav.viewControllers[0] as! BackingViewController
        let dispatchGroup = DispatchGroup()
        // backingVC.loadingPop.show(controller: backingVC)
        let resultsList = PodcastListViewController(index: at)
        
        //SearchResultListViewController(index: at)
        //  resultsList.persistentContainer = self.persistentContainer
        resultsList.index = 2
        //   resultsList.delegate = self
        if let tabController = self.tabBarController as? TabBarController {
            resultsList.miniPlayer = tabController.miniPlayer
            //resultsList.miniPlayer.delegate = self
        }
        //  resultsList.miniPlayer = backingVC.miniPlayerViewController
        
        dispatchGroup.enter()
        store.pullFeed(for: feedUrlString) {  response, error  in
            if error != nil {
                print(error?.localizedDescription ?? "unable to get specific error")
                //  backingVC.loadingPop.hideLoadingView(controller: backingVC)
                return
            } else {
                DispatchQueue.main.async {
                    // backingVC.loadingPop.hideLoadingView(controller: backingVC)
                }
            }
            guard let episodes = response else { return }
            feedPodcast.episodes = episodes
            // resultsList.setDataItem(dataItem: feedPodcast)
            // backingVC.loadingPop.hideLoadingView(controller: backingVC)
            resultsList.title = feedPodcast.podcastArtist
            if let url = URL(string: feedPodcast.podcastArtUrlString) {
                resultsList.topView.setTopImage(from: url)
                //topView.podcastImageView.image = imageView.image
            }
            // resultsList.setDataItem(dataItem: feedPodcast)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            // backingVC.loadingPop.hideLoadingView(controller: backingVC)
            DispatchQueue.main.async {
                self.navigationController?.title = podcast.podcastArtist
                //self.navigationController?.delegate = self
                self.navigationController?.pushViewController(resultsList, animated: true)
            }
        }
    }
    
    
    func goToSearch() {
        
    }
    
    func selectedItem(at: Int, podcast: PodcastItem, imageView: UIImageView) {
       
    }
}

