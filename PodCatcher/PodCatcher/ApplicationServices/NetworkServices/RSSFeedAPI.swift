import Foundation

class RSSFeedAPIClient: NSObject, XMLParserDelegate {
    
    static func requestFeed(for urlString: String, completion: @escaping ([[String: String]]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                let rssParser = RSSParser()
                rssParser.parseResponse(data: data) { parsedRSS in
                    completion(parsedRSS, nil)
                }
                
            }
            }.resume()
    }
}

class RSSParser: NSObject {
    
    
    let recordKey = "item"
    let dictionaryKeys = ["itunes:summary", "tunes:subtitle", "enclosure", "itunes:duration"]
    
    // a few variables to hold the results as we parse the XML
    
    var results = [[String: String]]()       // the whole array of dictionaries
    var currentDictionary: [String: String]! // the current dictionary
    var currentValue: String?
    
    
    func parseResponse(data: Data, completion: @escaping ([[String: String]]) -> Void) {
        var results = [[String]]()
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse() {
            completion(self.results)
        }
    }
}

extension RSSParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "enclosure" {
            print(elementName)
            print(attributeDict["url"])
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            currentDictionary["audio"] = attributeDict["url"]
        }
        if elementName == recordKey {
            currentDictionary = [String : String]()
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "enclosure" {
            print(elementName)
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
