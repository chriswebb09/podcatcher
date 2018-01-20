import UIKit

protocol ItemCreator {
    func createItems(rssData: [[String: String]]) -> [TopItem]
}

extension ItemCreator {
    func createItems(rssData: [[String: String]]) -> [TopItem] {
        var items = [TopItem]()
        for data in rssData {
            let link = data["link"]
            let pubDate = data["pubDate"]
            let title = data["title"]
            let category = data["category"]
            if let itemLink = link,
                let id = String.extractID(from: itemLink),
                let date = pubDate, let title = title,
                let category = category {
                var itemCategory = "N/A"
                if category != "podcast" {
                    itemCategory = category
                }
                let index = id.index(id.startIndex, offsetBy: 2)
                let item = TopItem(title: title,
                                   id: String(id[index...]),
                                   pubDate: date,
                                   category: itemCategory,
                                   itunesLinkString: itemLink)
                items.append(item)
            }
        }
        return items
    }
}
