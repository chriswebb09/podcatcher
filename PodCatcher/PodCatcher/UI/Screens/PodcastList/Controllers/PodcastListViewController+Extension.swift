import UIKit

struct PodcastListConstants {
    static let navFont: [String: Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 20)]
    static let edgeInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    static let size = CGSize(width: 50, height: 50)
    static let lineSpace: CGFloat = 0
    static let backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    static let minimumOffset: CGFloat = 500
    static let topFrameHeight = UIScreen.main.bounds.height / 2
    static let topFrameWidth = UIScreen.main.bounds.width
}

// MARK: - UICollectionViewDelegate

extension PodcastListViewController: UICollectionViewDelegate {
    
    // MARK: - Setup navbar UI
    
    func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = PodcastListConstants.navFont
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
}

// MARK: - UICollectionViewDataSource 

extension PodcastListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let caster = caster {
            return caster.assets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastCell
        if let caster = caster, let artwork = caster.artwork {
            let model = PocastCellModel(podcastImage: artwork, podcastTitle: caster.assets[indexPath.row].title, item: caster.assets[indexPath.row])
            cell.configureCell(model: model)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PodcastListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 10, right: 0)
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: - Popvoer view implmented
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectTrackAt(at: indexPath.row, with: caster)
    }
}

// MARK: - TopViewDelegate

extension PodcastListViewController: TopViewDelegate {
    
    func entryPop(pop: Bool) {
        popEntry()
    }
    
    func popBottomMenu(pop: Bool) {
        switch menuActive {
        case .none:
            showMenu()
            menuActive = .active
        case .active:
              menuActive = .hidden
            menuPop.hidePopView(viewController: self)
            menuPop.popView.removeFromSuperview()
        case .hidden:
            showMenu()
            menuActive = .active
        }
    }
    
    func showMenu() {
        menuPop.popView.delegate = self
        menuPop.setupPop()
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.menuPop.showPopView(viewController: strongSelf)
            strongSelf.menuPop.popView.isHidden = false
        }
    }
    
    func popEntry() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.entryPop.showPopView(viewController: strongSelf)
            strongSelf.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        entryPop.hidePopView(viewController: self)
        guard let text = entryPop.popView.entryField.text else { return }
        dataSource.user?.customGenres.append(text)
        collectionView.reloadData()
    }
}

// MARK: - MenuDelegate

extension PodcastListViewController: MenuDelegate {
    
    func optionOneTapped() {
        print("download")
    }
    
    func optionTwoTapped() {
        print("Option two tapped")
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}
