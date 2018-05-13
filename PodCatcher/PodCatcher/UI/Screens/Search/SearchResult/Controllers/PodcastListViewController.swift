//
//  SearchResultListViewController.swift
//  Podcatch
//
//  Created by Christopher Webb-Orenstein on 2/3/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PodcastResultCell: UICollectionViewCell, BaseDetailCell {
    
    // MARK: - UI Properties
    
    var model: PodcastResultCellViewModel!
    
    private var regularConstraints: [NSLayoutConstraint] = []
    private var regularTitleConstraints: [NSLayoutConstraint] = []
    private var modified: [NSLayoutConstraint] = []
    private var modifiedTitle: [NSLayoutConstraint] = []
    private var buttonConstraints: [NSLayoutConstraint] = []
    private var buttonModified: [NSLayoutConstraint] = []
    private var playtimeModified: [NSLayoutConstraint] = []
    private var playtimeRegularConstraints = [NSLayoutConstraint]()
    
    weak var delegate: PodcastResultCellDelegate?
    
    var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 1
        return view
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return separatorView
    }()
    
    private var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "more-icon").withRenderingMode(.alwaysTemplate), for: .normal)
        //moreButton.setImage(#imageLiteral(resourceName: "more-icon").withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        moreButton.tintColor = .darkGray
        return moreButton
    }()
    
    private var podcastTitleLabel: UILabel = {
        var podcastTitleLabel = UILabel()
        podcastTitleLabel.textAlignment = .left
        podcastTitleLabel.textColor = .darkGray
        podcastTitleLabel.lineBreakMode   = .byClipping
        podcastTitleLabel.clipsToBounds = true
        podcastTitleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        podcastTitleLabel.numberOfLines = 1
        podcastTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return podcastTitleLabel
    }()
    
    private var playTimeLabel: UILabel = {
        var playTimeLabel = UILabel()
        playTimeLabel.sizeToFit()
        playTimeLabel.textAlignment = .left
        playTimeLabel.textColor = .gray
        playTimeLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        //UIFont(name: "AvenirNext-Regular", size: 12)
        return playTimeLabel
    }()
    
    var audioAnimation: AudioIndicatorView!
    // MARK: - Configuration Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        isUserInteractionEnabled = true
        contentView.layer.borderColor = UIColor.clear.cgColor
        setupSeparator()
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        regularConstraints = [
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.01),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(regularTitleConstraints)
        NSLayoutConstraint.activate(regularConstraints)
        NSLayoutConstraint.activate(playtimeRegularConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    func setupAudio() {
        let frame = moreButton.frame
        moreButton.tintColor = .clear
        moreButton.isEnabled = false
        audioAnimation = AudioIndicatorView(frame: frame, animationType: AudioEqualizer2())
        audioAnimation.frame = frame
        contentView.add(audioAnimation)
        audioAnimation.startAnimating()
    }
    
    func removeAudio() {
        audioAnimation.stopAnimating()
        audioAnimation.removeFromSuperview()
        moreButton.tintColor = .darkGray
        moreButton.isEnabled = true
    }
    
    private func setupSeparator() {
        setup(separatorView: separatorView)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let containerLayer = CALayer()
            containerLayer.shadowColor = UIColor.darkText.cgColor
            containerLayer.shadowRadius = 1
            containerLayer.shadowOffset = CGSize(width: 0, height: 0)
            containerLayer.shadowOpacity = 0.7
            strongSelf.layer.addSublayer(containerLayer)
        }
    }
    
    @objc func buttonTap() {
        //delegate?.moreButtonTapped(sender: moreButton, cell: self)
    }
    
    func configureCell(model: PodcastResultCellViewModel) {
        self.model = model
        guard let episode = model.episode else { return }
        configure(with: episode.title, detail: model.playtimeLabel)
    }
    
    func configure(with title: String, detail: String) {
        layoutSubviews()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupConstraints()
        moreButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        layoutIfNeeded()
        colorBackgroundView.frame = contentView.frame
        contentView.addSubview(colorBackgroundView)
        contentView.sendSubview(toBack: colorBackgroundView)
        podcastTitleLabel.text = title
        playTimeLabel.text = detail
    }
    
    private func setupConstraints() {
        self.updateConstraintsIfNeeded()
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        regularTitleConstraints = [
            podcastTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PodcastCellConstants.podcastTitleLabelWidthMultiplier),
            podcastTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PodcastCellConstants.podcastTitleLabelLeftOffset + 20),
            podcastTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentView.frame.height * 0.2)
        ]
        contentView.addSubview(playTimeLabel)
        playTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        playtimeRegularConstraints = [
            playTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: contentView.frame.height * -0.2),
            playTimeLabel.leftAnchor.constraint(equalTo: podcastTitleLabel.leftAnchor),
            playTimeLabel.widthAnchor.constraint(equalTo: podcastTitleLabel.widthAnchor)
        ]
        
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.084),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            case 1334, 2208:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.087),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            default:
                buttonConstraints = [
                    moreButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.084),
                    moreButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
                    moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: PodcastCellConstants.playtimeLabelRightOffset),
                    moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
            }
        }
    }
    
    override func prepareForReuse() {
        if (audioAnimation) != nil {
            removeAudio()
        }
    }
}

extension Notification.Name {
    static let dataStorePodcastsChanged = Notification.Name("dataStorePodcastsChanged")
    static let dataStoreEpisodesChanged = Notification.Name("dataStoreEpisodesChanged")
}

import UIKit
import AVFoundation
import CoreData

final class PodcastListViewController: BaseCollectionViewController {
    
    enum parent {
        case unknown, home, browse, search, playlist
    }
    
    var currentParent: parent = .unknown
    
    var beginClosure: LayerAnimationBeginClosure?
    var completionClosure: LayerAnimationCompletionClosure?
    
    enum SegueIdentifvar: String {
        case showObjects
    }
    
    //  var audioPlayer: AudioFilePlayer!
    
    var index: Int!
    
    var persistentContainer: NSPersistentContainer!
    
    weak var delegate: PodcastListViewControllerDelegate?
    var selectedIndex: IndexPath!
    private var item: Podcast!
    
    private var state: PodcasterControlState = .toCollection
    
    var navPop = false
    
    private var confirmationIndicator = ConfirmationIndicatorView()
    
    var miniPlayer = MiniPlayerViewController()
    var topView = PodcastListTopView()
    var dataSource: SearchResultDatasource! = SearchResultDatasource()
    var playerContainer: UIView = UIView()
    
    var topViewHeightConstraint: NSLayoutConstraint!
    var topViewWidthConstraint: NSLayoutConstraint!
    var topViewYConstraint: NSLayoutConstraint!
    var topViewXConstraint: NSLayoutConstraint!
    var topViewTopConstraint: NSLayoutConstraint!
    var topViewBottomConstraint: NSLayoutConstraint!
    
    private var subscription = UserDefaults.loadSubscriptions()
    
    private(set) var viewShown: ShowView {
        didSet {
            switch viewShown {
            case .empty:
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
            }
        }
    }
    
    init(index: Int) {
        viewShown = .collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.controller = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if #available(iOS 10, *) {
            view.addSubview(playerContainer)
        } else {
            view.add(playerContainer)
        }
        
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        playerContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        playerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480, 960, 1136:
                playerContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
            case 1334, 2208:
                playerContainer.heightAnchor.constraint(equalToConstant: 68).isActive = true
            default:
                playerContainer.heightAnchor.constraint(equalToConstant: 68).isActive = true
            }
        }
        miniPlayer.delegate = self
        setupTopView()
        
        collectionView.register(PodcastListCell.self, forCellWithReuseIdentifier: PodcastListCell.reuseIdentifier)
        embedChild(controller: miniPlayer, in: playerContainer)
        miniPlayer.configure()
        
        emptyView = InformationView(data: "No Data.", icon: #imageLiteral(resourceName: "mic-icon"))
        setup(dataSource: dataSource, delegate: self)
        setupView()
        collectionView.register(PodcastListCell.self, forCellWithReuseIdentifier: PodcastListCell.reuseIdentifier)
        setupNavbar()
        setupBackgroundView()
        let newLayout = SearchItemsFlowLayout()
        newLayout.setup()
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = newLayout
        self.background.backgroundColor = .white
        
        self.view.bringSubview(toFront:playerContainer)
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerWillStartPlaying(_:)), name: .audioPlayerWillStartPlaying, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartLoading(_:)), name: .audioPlayerDidStartLoading, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidStartPlaying(_:)), name: .audioPlayerDidStartPlaying, object: appDelegate.audioPlayer)
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidPause(_:)), name: .audioPlayerDidPause, object: appDelegate.audioPlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerPlaybackTimeChanged(_:)), name: .audioPlayerPlaybackTimeChanged, object: appDelegate.audioPlayer)
        }
        //         let model = PodcastResultCellViewModel(episode: strongSelf.item.episodes[indexPath.row], podcastTitle: strongSelf.item.episodes[indexPath.row].title, isAnimating: false, playtimeLabel: playTime)
    }
    
    @objc private func audioPlayerWillStartPlaying(_ notification: Notification) {
        print(notification)
        // let episode = notification.userInfo![AudioPlayerEpisodeUserInfoKey]! as! Episode
        //        self.audioPlayerView.episodeDataSource = episode
        //        self.audioPlayerView.timeDataSource = nil
    }
    
    @objc private func audioPlayerDidStartLoading(_ notification: Notification) {
        print(notification)
        //self.audioPlayerView.state = .loading
    }
    
    @objc private func audioPlayerDidStartPlaying(_ notification: Notification) {
        print(notification)
        // self.audioPlayerView.state = .playing
    }
    
    @objc private func audioPlayerDidPause(_ notification: Notification) {
        //self.audioPlayerView.state = .paused
    }
    
    @objc private func audioPlayerPlaybackTimeChanged(_ notification: Notification) {
        let secondsElapsed = notification.userInfo![AudioPlayerSecondsElapsedUserInfoKey]! as! Double
        let secondsRemaining = notification.userInfo![AudioPlayerSecondsRemainingUserInfoKey]! as! Double
        print(secondsElapsed)
        print(secondsRemaining)
        // self.audioPlayerView.timeDataSource = (secondsElapsed, secondsRemaining)
    }
    
    func setDataItem(dataItem: Podcast) {
        item = dataItem
        // dataSource.setItem(item: item)
        var models: [PodcastResultCellViewModel] = []
        for episode in item.episodes {
            if let stringDuration = episode.stringDuration {
                let model = PodcastResultCellViewModel(episode: episode, podcastTitle: item.podcastTitle, isAnimating: false, playtimeLabel: stringDuration)
                models.append(model)
            } else {
                let model = PodcastResultCellViewModel(episode: episode, podcastTitle: item.podcastTitle, isAnimating: false, playtimeLabel: "0:00")
                models.append(model)
            }
            dataSource.set(models: models)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if item != nil {
            navigationItem.title = item.podcastTitle
        }
        setupButton()
        setupTopViewImage()
        showViews()
        setupLayout()
        super.viewWillAppear(animated)
        print("override func viewWillAppear(_ animated: Bool) ")
        //self.view.alpha = 0
        //guard let topView = topView else { return }
        DispatchQueue.main.async {
            self.topView.setupTop()
            self.setupTopView()
            self.setupTopViewImage()
            self.showViews()
            self.setupLayout()
        }
        if item != nil {
            navigationItem.title = item.podcastTitle
        }
        let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationItem.backBarButtonItem?.title = ""
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.topView.setupBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //        if let nav = self.parent as? UINavigationController, let browse = nav.viewControllers[0] as? BackingViewController {
        //            DispatchQueue.main.async {
        //
        //                browse.embeddedContainer.backgroundColor = .purple
        //                browse.miniPlayerViewController = self.miniPlayer
        //
        //                browse.embedChild(controller: browse.miniPlayerViewController, in: browse.playerContainer)
        //                browse.miniPlayerViewController.configure()
        //                browse.view.bringSubview(toFront: browse.playerContainer)
        //
        //                switch self.currentParent {
        //                case .unknown:
        //                    print("unknown")
        //                case .browse:
        //                    browse.navigationItem.title = "Browse"
        //                    print("browse")
        //                case .home:
        //                    print("home")
        //                case .playlist:
        //                    print("playlist")
        //                case .search:
        //                    print("search")
        //                }
        //            }
        //        }
    }
    
    private func setupLayout() {
        let newLayout = SearchItemsFlowLayout()
        newLayout.setup()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = newLayout
    }
    
    private func setupButton() {
        
        //        DispatchQueue.main.async {
        //            print(self.subscription)
        //
        //            if self.subscription.contains(self.item.feedUrl) {
        //                return
        //            }
        //            if !self.subscription.contains(self.item.feedUrl) {
        //
        //                DispatchQueue.main.async {
        //                    let button = UIButton()
        //                    button.setImage(#imageLiteral(resourceName: "subscribe").withRenderingMode(.alwaysTemplate), for: .normal)
        //                    button.addTarget(self, action: #selector(self.subscribeToFeed), for: .touchUpInside)
        //                    let barItem = UIBarButtonItem(customView: button)
        //
        //                    let width = barItem.customView?.widthAnchor.constraint(equalToConstant: 22)
        //                    width?.isActive = true
        //                    let height = barItem.customView?.heightAnchor.constraint(equalToConstant: 22)
        //                    height?.isActive = true
        //                    self.rightButtonItem = barItem
        //                    self.navigationItem.rightBarButtonItems = [self.rightButtonItem]
        //                }
        //            }
        //        }
    }
    
    private func setupNavbar() {
        DispatchQueue.main.async {
            let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
            self.navigationController?.navigationBar.backIndicatorImage = backImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            self.navigationController?.navigationBar.backItem?.title = ""
            //self.navigationController?.navigationBar.backItem?.isE
            //   self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(self.navigateBack))
        }
    }
    
    private func setupTopViewImage() {
        DispatchQueue.main.async {
            self.topView.configureTopImage()
        }
    }
    
    private func saveFeed() {
        //  guard let image = topView. else { return }
        let imageView = topView.getImageView()
        delegate?.saveFeed(item: item, podcastImage: imageView.image!, episodesCount: item.episodes.count)
        
    }
    
    private func showViews() {
        collectionView.alpha = 1
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1
    }
    
    @objc func subscribeToFeed() {
        saveFeed()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.2) {
                strongSelf.confirmationIndicator.showActivityIndicator(viewController: strongSelf)
            }
            UIView.animate(withDuration: 1, animations: {
                strongSelf.confirmationIndicator.loadingView.alpha = 0
            }, completion: { finished in
                strongSelf.subscription.append(strongSelf.item.feedUrl)
                UserDefaults.saveSubscriptions(subscriptions: strongSelf.subscription)
                strongSelf.confirmationIndicator.hideActivityIndicator(viewController: strongSelf)
                strongSelf.navigationItem.rightBarButtonItems = nil
                strongSelf.rightButtonItem = nil
                dump(strongSelf.subscription)
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        navPop = false
        switch state {
        case .toCollection:
            dismiss(animated: false, completion: nil)
        case .toPlayer:
            break
        }
    }
}

extension PodcastListViewController: PodcastResultCellDelegate,  UIAdaptivePresentationControllerDelegate {
    func moreButtonTapped(sender: Any, cell: PodcastListCell) {
        let popOverViewController = buildPopover()
        let button = sender as! UIButton
        let titles: [String] = ["Add To Playlist", "Favorite", "Go To Description"]
        let descriptions:Array<String> = ["description1", "description3"]
        popOverViewController.setTitles(titles)
        popOverViewController.setDescriptions(descriptions)
        popOverViewController.popoverPresentationController?.sourceView = button
        popOverViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: button.frame.size.width, height: button.frame.size.height)
        popOverViewController.presentationController?.delegate = self
        
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                guard let episode = cell.model.episode else { return }
                //elf.delegate?.
                //addToPlaylist(episde: episode)
                popOverViewController.dismiss()
                popOverViewController.presentationController?.delegate = nil
            case 1:
                //self.delegate?.goToDescription()
                break
            case 2:
                print("favorite")
                break
            default:
                break
            }
        }
        present(popOverViewController, animated: true, completion: nil)
    }
    
    //    func moreButtonTapped(sender: Any, cell: PodcastListCell) {
    //        print("tap")
    //    }
    //
    ////
    //
    func buildPopover() -> PopOverViewController {
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.popoverPresentationController?.permittedArrowDirections = .right
        popOverViewController.setShowsVerticalScrollIndicator(true)
        popOverViewController.setSeparatorStyle(UITableViewCellSeparatorStyle.singleLine)
        
        popOverViewController.tableView.backgroundColor = .blue
        popOverViewController.preferredContentSize = CGSize(width: 250, height:150)
        popOverViewController.presentationController?.delegate = self
        return popOverViewController
    }
    
    //   @objc func moreButtonTapped(sender: Any, cell: PodcastResultCell) {
    //
    //    }
    
    func buildPlaylistsPopover() -> SelectionViewController {
        let popOverViewController = SelectionViewController.instantiate()
        popOverViewController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        popOverViewController.preferredContentSize = CGSize(width: 500 , height:300)
        popOverViewController.presentationController?.delegate = self
        let button = UIButton()
        button.frame = CGRect(x:popOverViewController.tableView.bounds.minX, y: popOverViewController.tableView.bounds.maxY, width: popOverViewController.tableView.bounds.width, height: popOverViewController.tableView.bounds.height * 0.25)
        popOverViewController.view.add(button)
        return popOverViewController
    }
    
    func buildModal(for playlists: [Playlist], for episode: Episodes) {
        print("here")
        let popOverViewController = buildPlaylistsPopover()
        
        popOverViewController.presentationController?.delegate = self
        var playlistNames: [String] = []
        playlistNames = playlists.flatMap { $0.name }
        
        playlistNames.append("Cancel")
        //   popOverViewController.setItems(playlistNames)
        popOverViewController.popoverPresentationController?.sourceView = self.topView
        popOverViewController.popoverPresentationController?.sourceRect = CGRect(x: topView.frame.origin.x , y: topView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.view.bounds.height)
        
        let episodeEntity = NSEntityDescription.entity(forEntityName: "Episode", in: self.persistentContainer.viewContext)!
        let newEpisode = Episode(entity: episodeEntity, insertInto: self.persistentContainer.viewContext)
        newEpisode.episodeTitle = episode.title
        print(episode.mediaUrlString)
        newEpisode.mediaUrlString = episode.mediaUrlString
        newEpisode.podcastArtUrlString = item.podcastArtUrlString
        newEpisode.episodeDescription = episode.description
        newEpisode.podcastTitle = episode.podcastTitle
        let imageData: NSData = UIImageJPEGRepresentation(topView.getImageView().image!, 0)! as NSData
        newEpisode.podcastArtworkImage = imageData
        popOverViewController.completionHandler = { selectRow in
            if selectRow == playlists.count {
                return
            }
            let playlist = playlists[selectRow]
            playlist.numberOfItems += 1.0
            playlist.image = imageData
            playlist.addToPlaylistEpisodes(newEpisode)
            do {
                try self.persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
            print(playlistNames[selectRow])
        }
        present(popOverViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

// MARK: - PodcastCollectionViewProtocol

extension PodcastListViewController {
    
    func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = PodcastListConstants.backgroundColor
    }
    
    private func setupView() {
        setupTopView()
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func setupBackgroundView() {
        background.frame = view.frame
        view.addSubview(background)
        view.sendSubview(toBack: background)
    }
    
    func setupTopView() {
        view.addSubview(self.topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            topViewTopConstraint = topView.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 0.18)
            topViewTopConstraint.isActive = true
        } else {
            topViewTopConstraint = topView.topAnchor.constraint(equalTo: view.topAnchor)
            topViewTopConstraint.isActive = true
        }
        
        topViewHeightConstraint = topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        topViewHeightConstraint.isActive = true
        topViewWidthConstraint = topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        topViewWidthConstraint.isActive = true
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //
        if let item = item, let url = URL(string: item.podcastArtUrlString) {
            self.topView.setTopImage(from: url)
            //            URL.downloadImageFromUrl(url.absoluteString) { image in
            //                self.topView.setTopImage(from: url)
            //               // self.topView.setTopImage(image: image!)
            //            }
            //url.do
            ///  topView.setTopImage(image: <#T##UIImage#>)
            // topView.podcastImageView.downloadImage(url: url)
        }//
        collectionView.bottomAnchor.constraint(equalTo: playerContainer.topAnchor).isActive = true
        
    }
    
}


// MARK: - UICollectionViewDelegate

extension PodcastListViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PodcastListCell
        
        if dataSource.animateCellAtIndex != nil && indexPath != dataSource.animateCellAtIndex {
            if let previousCell = collectionView.cellForItem(at: dataSource.animateCellAtIndex) as? PodcastListCell {
                previousCell.removeAudio()
                
            }
            DispatchQueue.main.async {
                self.miniPlayer.pauseUI()
            }
        }
        
        dataSource.animateCellAtIndex = indexPath
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        let episode = item.episodes[indexPath.row]
        miniPlayer.thumbImage.image = topView.getImageView().image!
        miniPlayer.playFor(episode: episode)
        miniPlayer.currentPodcast = episode
        miniPlayer.delegate = self
        //        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //            appDelegate.audioPlayer.play(episode: episode)
        //        }
        //  self.audioPlayer.play(episode: episode)
    }
}

extension PodcastListViewController: MiniPlayerDelegate {
    func expandPodcast(episode: Episode) {
        //        if let backingVC = navigationController?.childViewControllers[0] as? BackingViewController {
        //            guard let maxiCard = UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") as? CardPlayerViewController else {
        //                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
        //                return
        //            }
        //            maxiCard.delegate = self
        //            maxiCard.sourceView = backingVC.miniPlayerViewController
        //            maxiCard.backingImage = view.makeSnapshot()
        //            navigationController?.present(maxiCard, animated: false)
        //        }
        //        if (navigationController?.childViewControllers[0] as? HomeViewController) != nil {
        //
        //            guard UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") is CardPlayerViewController else {
        //                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
        //                return
        //            }
        //        }
    }
    
    func expandPodcast(episode: Episodes) {
        
        //        if let backingVC = navigationController?.childViewControllers[0] as? BackingViewController {
        //            guard let maxiCard = UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "MaxiSongCardViewController") as? CardPlayerViewController else {
        //                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
        //                return
        //            }
        //            DispatchQueue.main.async {
        //
        //
        //                maxiCard.delegate = self
        //                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //
        //                    maxiCard.sourceView = backingVC.miniPlayerViewController
        //                    maxiCard.audioTimeDuration =  appDelegate.audioPlayer.duration
        //                }
        //                //  maxiCard.primaryDuration = self.audioPlayer.duration
        //                maxiCard.backingImage = self.view.makeSnapshot()
        //                maxiCard.endBackingImage = self.view.makeEndSnapshot()
        //                switch self.miniPlayer.currentState {
        //                case .playing:
        //                    maxiCard.currentState = .playing
        //                case .paused:
        //                    maxiCard.currentState = .paused
        //                case .stopped:
        //                    maxiCard.currentState = .stopped
        //                }
        //                maxiCard.currentPodcast = episode
        //                maxiCard.currentPodcast?.podcastTitle = self.item.podcastTitle
        //                self.navigationController?.present(maxiCard, animated: false)
        //            }
        //        }
    }
}

extension PodcastListViewController: CardPlayerViewControllerDelegate {
    
    func playButton(tapped: Bool) {
        print("play")
        DispatchQueue.main.async {
            self.miniPlayer.playUI()
            //self.miniPlayer.
        }
        
        if selectedIndex != nil && dataSource.animateCellAtIndex == nil {
            dataSource.animateCellAtIndex = selectedIndex
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [self.dataSource.animateCellAtIndex])
        }
        
        selectedIndex = nil
        //        if selectedIndex != nil {
        //            let previousCell = collectionView.cellForItem(at: selectedIndex) as! PodcastResultCell
        //            previousCell.setupAudio()
        //            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //                //guard let status = audioPlayer.player?.status else { return }
        //                if !appDelegate.audioPlayer.isPlaying {
        //                    previousCell.removeAudio()
        //                }
        //            }
        //        }
        //        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //            appDelegate.play()
        //        }
        // self.audioPlayer.play()
    }
    
    func pauseButton(tapped: Bool) {
        if dataSource.animateCellAtIndex != nil {
            if let previousCell = collectionView.cellForItem(at: dataSource.animateCellAtIndex) as? PodcastListCell {
                previousCell.removeAudio()
            }
            
            selectedIndex = dataSource.animateCellAtIndex
            dataSource.animateCellAtIndex = nil
            
            DispatchQueue.main.async {
                self.miniPlayer.pauseUI()
                //self.miniPlayer.
            }
            
            //previousCell.buttonTap()
        }
        
        //        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //            appDelegate.audioPlayer.pause()
        //        }
    }
    
    func skipButton(tapped: Bool) {
        //        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        //            appDelegate.audioPlayer.skip(by: 15)
        //        }
    }
    
    func backButton(tapped: Bool) {
        
    }
    
    func dismiss(tapped: Bool) {
        
    }
}

extension PodcastListViewController: CAAnimationDelegate {
    
    func animationDidStart(_ animation: CAAnimation) {
        print("start")
        guard let beginClosure = beginClosure else { return }
        beginClosure(animation)
    }
    
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        print("finished")
        guard let completionClosure = completionClosure else { return }
        completionClosure(animation, finished)
    }
}



extension URL {
    static func downloadImageFromUrl(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            return
        }
        DispatchQueue.global().async {
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data , error == nil,
                    let image = UIImage(data: data) else {
                        
                        DispatchQueue.main.async {
                            completionHandler(nil)
                        }
                        return
                }
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            })
            task.resume()
        }
    }
}
