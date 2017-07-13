import Foundation

class NPRParser: RSSParser {
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == recordKey {
            currentDictionary = [String : String]()
        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix(".mp3") {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            print(item)
            currentDictionary["audio"] = item
        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix("f=344098539") {
            if currentDictionary == nil {
                currentDictionary = [String : String]()
            }
            print(item)
            currentDictionary["audioUrlString"] = item
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

//class NPRParser: RSSParser {
//    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        
//        if elementName == recordKey {
//            currentDictionary = [String : String]()
//        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix(".mp3") {
//            if currentDictionary == nil {
//                currentDictionary = [String : String]()
//            }
//            print(item)
//            currentDictionary["audio"] = item
//        } else if elementName == "enclosure", let item = attributeDict["url"], item.hasSuffix("f=510298") {
//            if currentDictionary == nil {
//                currentDictionary = [String : String]()
//            }
//            print(item)
//            currentDictionary["audioUrlString"] = item
//        } else if dictionaryKeys.contains(elementName) {
//            currentValue = ""
//        }
//    }
//    
//    override func parser(_ parser: XMLParser, foundCharacters string: String) {
//        currentValue? += string.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//    
//    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if results.count == 40 {
//            return
//        }
//        if elementName == "enclosure" {
//            currentValue = nil
//            return
//        }
//        if elementName == recordKey {
//            results.append(currentDictionary)
//            currentDictionary = nil
//        } else if dictionaryKeys.contains(elementName) && currentDictionary != nil {
//            currentDictionary[elementName] = currentValue
//            currentValue = nil
//        }
//    }
//}
