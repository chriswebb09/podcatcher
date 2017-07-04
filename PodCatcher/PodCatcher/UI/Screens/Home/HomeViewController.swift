import UIKit

class HomeViewController: BaseCollectionViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    let store = HomeDataStore()
    var bottomCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var dataSource: HomeCollectionDataSource! {
        didSet {
            viewShown = dataSource.viewShown
        }
    }
    
    var dataSourceTwo: HomeCollectionDataSourceTwo! {
        didSet {
            print("set")
        }
    }
    
    
    var viewShown: ShowView = .empty {
        didSet {
            switch viewShown {
            case .empty:
                view.addSubview(emptyView)
                changeView(forView: emptyView, withView: collectionView)
            case .collection:
                changeView(forView: collectionView, withView: emptyView)
                emptyView.removeFromSuperview()
            }
        }
    }
    
    init(index: Int, dataSource: BaseMediaControllerDataSource) {
        self.dataSource = HomeCollectionDataSource()
        self.dataSourceTwo = HomeCollectionDataSourceTwo()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.alpha = 0

        view.addSubview(collectionView)
        view.addSubview(bottomCollectionView)
        
        collectionViewConfiguration()
        collectionView.backgroundColor = .lightGray
        bottomViewConfiguration()
        bottomCollectionView.setupBackground(frame: view.bounds)
        bottomCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        collectionView.register(TopPodcastCell.self)
        bottomCollectionView.register(TopPodcastCell.self)
        self.dataSource.items = self.store.politicsItems
        self.dataSourceTwo.items = self.store.historyItems
        bottomCollectionView.dataSource = dataSourceTwo
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .white
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            self.bottomCollectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
            self.view.bringSubview(toFront: self.bottomCollectionView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubview(toFront: self.collectionView)
            self.view.bringSubview(toFront: self.bottomCollectionView)
            self.bottomCollectionView.reloadData()
        }
    }
    
    func bottomViewConfiguration() {
        //setup(view: view, newLayout: HomeItemsFlowLayout())
        bottomCollectionView.backgroundColor = .clear
        bottomCollectionView.frame = CGRect(x: 0, y: view.bounds.midY + 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        bottomCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setup(view: bottomCollectionView, newLayout: HomeItemsFlowLayout())
        bottomCollectionView.delegate = self
        // collectionView.dataSource = dataSource
        bottomCollectionView.isPagingEnabled = true
        bottomCollectionView.isScrollEnabled = true
        var test = HomeItemsFlowLayout()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.bottomCollectionView.reloadData()
        }
        test.setup()
        bottomCollectionView.collectionViewLayout = test
        
    }
    
    func collectionViewConfiguration() {
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        setup(view: collectionView, newLayout: HomeItemsFlowLayout())
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        //  collectionView.backgroundColor = .clear
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func setup(view: UICollectionView, newLayout: HomeItemsFlowLayout) {
        //collectionView.backgroundColor = .white
        //
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setupHome(with: newLayout, and: collectionView)
    }
    
    func setupHome(with newLayout: HomeItemsFlowLayout, and collectionView: UICollectionView) {
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        
    }
}


class HomeDataStore {
    var categories: [String] = []
    var lookup: String = ""
    var response = [TopItem]() {
        didSet {
            for item in response {
                if !categories.contains(item.category) {
                    categories.append(item.category)
                }
                if item.category == "News&Politics" {
                    lookup = item.id
                    self.searchForTracks { result in
                        dump(result)
                        guard let result = result.0 else { return }
                        self.politicsItems.append(contentsOf: result)
                    }
                } else if item.category == "History" {
                    lookup = item.id
                    self.searchForTracks { result in
                        dump(result)
                        guard let result = result.0 else { return }
                        self.historyItems.append(contentsOf: result)
                    }
                }
                print(categories)
            }
        }
    }
    
    var politicsItems = [CasterSearchResult]() {
        didSet {
            
        }
    }
    
    var historyItems = [CasterSearchResult]()
    
    func pullFeedTopPodcasts(competion: @escaping (([TopItem]?, Error?) -> Void)) {
        var items = [TopItem]()
        RSSFeedAPIClient.getTopPodcasts { rssData, error in
            if let error = error {
                competion(nil, error)
            }
            guard let rssData = rssData else { return }
            for data in rssData {
                let link = data["link"]
                let pubDate = data["pubDate"]
                let title = data["title"]
                let category = data["category"]
                if let itemLink = link, let id = self.extractIdFromLink(link: itemLink), let date = pubDate, let title = title, let category = category {
                    var itemCategory = "N/A"
                    if category != "podcast" {
                        itemCategory = category
                    }
                    let index = id.index(id.startIndex, offsetBy: 2)
                    
                    let item = TopItem(title: title, id: id.substring(from: index), pubDate: date, category: itemCategory, itunesLinkString: itemLink)
                    items.append(item)
                }
            }
            DispatchQueue.main.async {
                competion(items, nil)
            }
            
        }
    }
    
    func extractIdFromLink(link: String) -> String? {
        let pattern = "id([0-9]+)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    func searchForTracks(completion: @escaping (_ results: [CasterSearchResult]? , _ error: Error?) -> Void) {
        iTunesAPIClient.search(forLookup: lookup) { response in
            switch response {
            case .success(let data):
                let resultsData = data["results"] as! [[String: Any]]
                let results = ResultsParser.parse(resultsData: resultsData)
                DispatchQueue.main.async {
                    completion(results, nil)
                }
                
            case .failed(let error):
                completion(nil, error)
            }
        }
    }
}
