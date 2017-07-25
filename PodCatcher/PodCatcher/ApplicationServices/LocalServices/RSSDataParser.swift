import Foundation

protocol Parser: class {
    
    var recordKey: String { get set }
    var dictionaryKeys: [String] { get set }
    var currentDictionary: [String: String]! { get set }
    var currentValue: String? { get set }
    var results: [[String: String]] { get set }
    
    func parseResponse(_ data: Data, completion: @escaping ([[String: String]]) -> Void)
}

class RSSParser: NSObject, Parser {
    var recordKey = "item"
    var dictionaryKeys = ["itunes:summary", " itunes:author", "tunes:subtitle", "pubDate", "enclosure", "itunes:duration", "title", "audio/mp3", "audio/mpeg", "itunes:keywords", "itunes:image", "link", "category", "itunes:author", "itunes:summary", "description", "enclosure"]
    
    var results = [[String: String]]()
    var currentDictionary: [String: String]!
    var currentValue: String?
    
    func parseResponse(_ data: Data, completion: @escaping ([[String: String]]) -> Void) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse() {
            DispatchQueue.main.async {
                completion(self.results)
            }
        }
    }
}

extension RSSParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == recordKey {
            currentDictionary = [String : String]()
        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix(".mp3") {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            print(item)
            currentDictionary["audio"] = item
        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix("f=510298") {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            print(item)
            currentDictionary["audioUrlString"] = item
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if results.count == 30 {
            return
        }
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

class NPRParser: RSSParser {
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == recordKey {
            currentDictionary = [String : String]()
        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix(".mp3") {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            currentDictionary["audio"] = item
        } else if elementName == "enclosure", let item = attributeDict["url"] {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            currentDictionary["audio"] = item
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if results.count == 40 {
            return
        } else if elementName == "enclosure" {
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
