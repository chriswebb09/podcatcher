import MediaPlayer

protocol MediaItemGetter {
    func getItemListsFrom(collection: [MPMediaItemCollection]?) -> [[MPMediaItem]]?
}

extension MediaItemGetter {
    func getItemListsFrom(collection: [MPMediaItemCollection]?) -> [[MPMediaItem]]? {
        var items: [[MPMediaItem]] = []
        guard let collection = collection else {
            return nil
        }
        for item in collection {
            items.append(item.items)
        }
        return items
    }
}
