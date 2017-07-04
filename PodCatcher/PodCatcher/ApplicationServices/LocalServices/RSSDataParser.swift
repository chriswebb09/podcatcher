import Foundation


class TopPodcastRSSParser: NSObject {
    let recordKey = "item"
    let dictionaryKeys = ["itunes:summary", "tunes:subtitle", "pubDate", "enclosure", "itunes:duration", "title", "audio/mp3", "itunes:keywords", "itunes:image", "link"]
}


class RSSParser: NSObject {
    let recordKey = "item"
    let dictionaryKeys = ["itunes:summary", "tunes:subtitle", "pubDate", "enclosure", "itunes:duration", "title", "audio/mp3", "itunes:keywords", "itunes:image", "link", "category"]
    
    var results = [[String: String]]()
    var currentDictionary: [String: String]!
    var currentValue: String?
    
    func parseResponse(data: Data, completion: @escaping ([[String: String]]) -> Void) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse() {
            completion(self.results)
        }
    }
}

extension RSSParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == recordKey {
            currentDictionary = [String : String]()
        } else if elementName == "enclosure" {
            if let item = attributeDict["url"], item.hasSuffix(".mp3") {
                if currentDictionary == nil {
                    currentDictionary = [String : String]()
                }
                currentDictionary["audio"] = item
            }
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "enclosure" {
            currentValue = nil
            return
        }
        if elementName == recordKey {
            results.append(currentDictionary)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) && currentDictionary != nil {
            currentDictionary[elementName] = currentValue
            currentValue = nil
        }
    }
}
