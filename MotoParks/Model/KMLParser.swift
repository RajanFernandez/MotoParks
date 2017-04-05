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
class KMLParser: NSObject, XMLParserDelegate {
    
    private var currentKey: String?
    private var latitude: Double?
    private var longitude: Double?
    private var name: String?
    private var placemarks = [KMLPlacemark]()
    
    func placemarks(fromKML data: Data) -> [KMLPlacemark] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        placemarks = [KMLPlacemark]()
        parser.parse()
        return placemarks
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentKey = elementName
        if elementName == "Placemark" { clearTempData() }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        guard let currentKey = currentKey else { return }
        
        let charSet = NSMutableCharacterSet()
        charSet.formUnion(with: CharacterSet.whitespaces)
        charSet.formUnion(with: CharacterSet.newlines)
        
        switch currentKey {
        case "name":
            let nameString = string.trimmingCharacters(in: charSet as CharacterSet)
            if name != nil {
                name! += nameString
            } else {
                name = nameString
            }
        case "coordinates":
            let coordinateArray = string.trimmingCharacters(in: charSet as CharacterSet).components(separatedBy: ",")
            guard coordinateArray.count > 2 else { return }
            longitude = Double(coordinateArray[0])
            latitude = Double(coordinateArray[1])
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == "Placemark" else { return }
        guard let latitude = latitude, let longitude = longitude else { return }
        placemarks.append(KMLPlacemark(latitude: latitude, longitude: longitude, name: name))
        clearTempData()
    }
    
    func clearTempData() {
        currentKey = nil
        latitude = nil
        longitude = nil
        name = nil
    }
    
}
