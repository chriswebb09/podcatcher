//
//  BackingViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/15/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

protocol HomeBackingViewControllerDelegate: class {
    func updatePodcast(with id: String)
}

final class HomeBackingViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: HomeBackingViewControllerDelegate?
    let sliderBarView = UIView()
    private var thumbnailZoomTransitionAnimator: ImageTransitionAnimator?
    private var transitionThumbnail: UIImageView?
    var sliderControl = SliderControl()
    
    var backingView: UIView = UIView()
    
    var homeViewController: HomeViewController!
    
    var playlistsViewController: PlaylistsViewController = PlaylistsViewController()
    var interactor = SearchResultsIteractor()
    var browseViewController: BrowseViewController = BrowseViewController(index: 0)
    let globalDefault = DispatchQueue.global()
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browseViewController.delegate = self
        playlistsViewController.delegate = self
    }
    
    func setupBrowse() {
        concurrent.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getCasterWorkaround { items, error in
                if error != nil {
                    DispatchQueue.main.async {
                        let informationView = InformationView(data: "", icon: #imageLiteral(resourceName: "sad-face"))
                        informationView.setIcon(icon: #imageLiteral(resourceName: "sad-face"))
                        informationView.setLabel(text: "Oops! Unable to connect to iTunes server.")
                        informationView.frame = UIScreen.main.bounds
                        strongSelf.browseViewController.view = informationView
                        strongSelf.browseViewController.view.layoutSubviews()
                        strongSelf.browseViewController.hideLoadingView(loadingPop: strongSelf.browseViewController.loadingPop)
                    }
                } else {
                    if strongSelf.browseViewController.dataSource.items.count > 0 {
                        guard let urlString = strongSelf.browseViewController.dataSource.items[0].podcastArtUrlString else { return }
                        guard let title = strongSelf.browseViewController.dataSource.items[0].podcastTitle else { return }
                        guard let imageUrl = URL(string: urlString) else { return }
                        strongSelf.browseViewController.browseTopView.setTitle(title: title)
                        strongSelf.browseViewController.browseTopView.podcastImageView.downloadImage(url: imageUrl)
                    }
                }
            }
        }
    }
    
    
    func getCasterWorkaround(completion: @escaping ([CasterSearchResult]?, Error?) -> Void) {
        // let backingViewController = navigationController.viewControllers[0] as! BrowserBackingViewController
        // let browseViewController = backingViewController.browseViewController
        var results = [CasterSearchResult]()
        let topPodcastGroup = DispatchGroup()
        var ids: [String] = ["201671138", "1268047665", "1264843400", "1212558767", "1200361736", "1150510297", "1097193327", "1250180134", "523121474", "1119389968", "1222114325", "1074507850", "173001861", "1028908750", "1279361017"]
        for i in 0..<ids.count {
            self.globalDefault.async(group: topPodcastGroup) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.interactor.setLookup(term: ids[i])
                strongSelf.interactor.searchForTracksFromLookup { result, arg  in
                    if let error = arg {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                    guard let resultItem = result else { return }
                    resultItem.forEach { resultingData in
                        guard let resultingData = resultingData else { return }
                        if let caster = CasterSearchResult(json: resultingData) {
                            results.append(caster)
                            DispatchQueue.main.async {
                                
                                strongSelf.browseViewController.dataSource.items.append(caster)
                                strongSelf.browseViewController.collectionView.reloadData()
                                if let artUrl = results[0].podcastArtUrlString, let url = URL(string: artUrl) {
                                    strongSelf.browseViewController.browseTopView.podcastImageView.downloadImage(url: url)
                                }
                            }
                        }
                    }
                }
            }
        }
        print("Waiting for completion...")
        topPodcastGroup.notify(queue: self.globalDefault) {
            print("Notify received, done waiting.")
            DispatchQueue.main.async {
                self.browseViewController.hideLoadingView(loadingPop: self.browseViewController.loadingPop)
                completion(results, nil)
            }
        }
        topPodcastGroup.wait()
        print("Done waiting.")
    }
    
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
                // self.title = "Podcasts"
                self.navigationItem.title = "Podcasts"
                self.navigationItem.rightBarButtonItem = self.homeViewController.rightButtonItem
                self.navigationItem.leftBarButtonItem = nil
            }
            
        case 1:
            currentEmbeddedVC = browseViewController
            DispatchQueue.main.async {
                //self.title = "Podcasts"
                self.navigationItem.title = "Podcasts"
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
            }
        case 2:
            currentEmbeddedVC =  playlistsViewController
            DispatchQueue.main.async {
                // self.title = "Podcasts"
                self.navigationItem.title = "Podcasts"
                self.navigationItem.rightBarButtonItem = self.playlistsViewController.rightButtonItem
                self.navigationItem.leftBarButtonItem = self.playlistsViewController.leftButtonItem
            }
            //  currentEmbeddedVC = tagsViewController
            //        case 1:
            //            currentEmbeddedVC = downloadedViewController
            //
            //            DispatchQueue.main.async {
            //                //self.title = "Downloads"
            //                self.navigationItem.title =  "Downloads"
            //                self.navigationItem.rightBarButtonItem = nil
            //            }
            //
            //        case 2:
            //             currentEmbeddedVC = tagsViewController
            //            DispatchQueue.main.async {
            //                //self.title = "Pocast Tags"
            //                self.navigationItem.title = "Tags"
            //                self.navigationItem.rightBarButtonItem = nil
            //            }
            
        default:
            currentEmbeddedVC = homeViewController
        }
    }
}

extension HomeBackingViewController: BrowseViewControllerDelegate {
    func didSelect(at index: Int, with cast: PodcastSearchResult, with imageView: UIImageView) {
        let resultsList = SearchResultListViewController(index: index)
        resultsList.delegate = self
        if var dataItem = cast as? CasterSearchResult {
            guard let navigationController = navigationController else { return }
            let browseViewController = navigationController.viewControllers[0] as! BrowseViewController
            guard let feedUrlString = dataItem.feedUrl else { return }
            browseViewController.showLoadingView(loadingPop: browseViewController.loadingPop)
            let store = SearchResultsDataStore()
            // navigationController.delegate = self
            self.transitionThumbnail?.image = imageView.image
            concurrent.async { [weak self] in
                guard let strongSelf = self else { return }
                store.pullFeed(for: feedUrlString) {  response, arg in
                    guard let episodes = response else { return }
                    dataItem.episodes = episodes
                    resultsList.setDataItem(dataItem: dataItem)
                    DispatchQueue.main.async {
                        browseViewController.hideLoadingView(loadingPop: browseViewController.loadingPop)
                        resultsList.navPop = true
                        navigationController.pushViewController(resultsList, animated: true)
                        browseViewController.collectionView.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}

extension HomeBackingViewController: PodcastListViewControllerDelegate {
    func didSelectPodcastAt(at index: Int, podcast: CasterSearchResult, with episodes: [Episode]) {
        
    }
    
    func saveFeed(item: CasterSearchResult, podcastImage: UIImage, episodesCount: Int) {
        
    }
    
    func navigateBack(tapped: Bool) {
        
    }
    
    
}

extension HomeBackingViewController: PlaylistsViewControllerDelegate {
    
    func didAssignPlaylist(with id: String) {
        guard let navigationController = navigationController else { return }
        delegate?.updatePodcast(with: id)
        
        let item = PodcastPlaylistItem(context: managedContext)
        item.playlistId = id
        
        let controller = navigationController.viewControllers.last as! PlaylistsViewController
        navigationController.setNavigationBarHidden(false, animated: false)
        controller.tabBarController?.selectedIndex = 2
    }
    
    func playlistSelected(for caster: PodcastPlaylist) {
        guard let navigationController = navigationController else { return }
        let playlist = PlaylistViewController(index: 0, player: AudioFilePlayer(), playlist: caster)
        
        playlist.playlistId = caster.playlistId!
        playlist.playlistTitle = caster.playlistName!
        
        navigationController.pushViewController(playlist, animated: false)
    }
}

