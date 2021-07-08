//
//  RssParse.swift
//  VNExpress
//
//  Created by Tuyen on 05/07/2021.
//

import Foundation
class RssParse: NSObject, XMLParserDelegate {
    var parser = XMLParser()
    var news = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var title = NSMutableString()
    var fdescription = NSMutableString()
    var pubDate = NSMutableString()
    var link = NSMutableString()
    var guid = NSMutableString()
    var comments = NSMutableString()
    
    func initWithUrl(_ url : URL)-> AnyObject{
        startParse(url)
        return self
    }
    func startParse ( _ url : URL){
        news = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    func allNews() -> NSMutableArray{
        return news
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if( element as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title = NSMutableString()
            title = ""
            fdescription = NSMutableString()
            fdescription = ""
            pubDate = NSMutableString()
            pubDate = ""
            link = NSMutableString()
            link = ""
            guid = NSMutableString()
            guid = ""
            comments = NSMutableString()
            comments = ""
            
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item"){
            if title != "" {
                elements.setObject(title, forKey: "title" as NSCopying)
            }
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            if pubDate != "" {
                elements.setObject(pubDate, forKey: "pubDate" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            if guid != "" {
                elements.setObject(guid, forKey: "guid" as NSCopying)
            }
            if comments != "" {
                elements.setObject(comments, forKey: "slash:comments" as NSCopying)
            }
            news.add(elements)
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let strings = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if element.isEqual(to: "title"){
            title.append(strings)
        }
        else if element.isEqual(to: "description"){
            fdescription.append(strings)
        }
        else if element.isEqual(to: "pubDate"){
            pubDate.append(strings)
        }
        else if element.isEqual(to: "link"){
            link.append(strings)
        }
        else if element.isEqual(to: "guid"){
            guid.append(strings)
        }
        else if element.isEqual(to: "slash:comments"){
            comments.append(strings)
        }
    }
}
