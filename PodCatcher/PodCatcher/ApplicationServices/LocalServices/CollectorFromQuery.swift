import MediaPlayer

protocol CollectorFromQuery {
    func getItemCollectionFrom(query: MPMediaQuery) -> [MPMediaItemCollection]?
}

extension CollectorFromQuery {
    func getItemCollectionFrom(query: MPMediaQuery) -> [MPMediaItemCollection]? {
        guard let collection = query.collections else { return nil }
        guard let podcasts = collection.last else { return nil }
        return [podcasts]
    }
}
