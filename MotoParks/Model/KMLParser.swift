//
//  KMLParser.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 3/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

/**
 KML parser to return placemarks.
 */
class KMLParser: NSObject, NSXMLParserDelegate {
    
    var parser: NSXMLParser!
    
    var currentKey: String?
    
    var latitude: Double?
    var longitude: Double?
    var name: String?
    
    var placemarks = [KMLPlacemark]()
    
    init(kml: NSData) {
        super.init()
        parser = NSXMLParser(data: kml)
        parser.delegate = self
    }
    
    func getPlacemarks() -> [KMLPlacemark] {
        placemarks = [KMLPlacemark]()
        parser.parse()
        return placemarks
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentKey = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        guard let currentKey = currentKey else { return }
        
        switch currentKey {
        case "name":
            name = string
        case "coordinates":
            let charSet = NSMutableCharacterSet()
            charSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
            charSet.formUnionWithCharacterSet(NSCharacterSet.newlineCharacterSet())
            let coordinateArray = string.stringByTrimmingCharactersInSet(charSet).componentsSeparatedByString(",")
            guard coordinateArray.count > 2 else { return }
            longitude = Double(coordinateArray[0])
            latitude = Double(coordinateArray[1])
        default:
            break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == "Placemark" else { return }
        guard let latitude = latitude, longitude = longitude else { return }
        placemarks.append(KMLPlacemark(latitude: latitude, longitude: longitude, name: name))
        currentKey = nil
    }
    
}