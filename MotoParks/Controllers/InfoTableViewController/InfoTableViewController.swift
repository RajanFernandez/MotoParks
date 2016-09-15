//
//  InfoTableViewController.swift
//  MotoParks
//
//  Created by Rajan Fernandez on 27/06/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

import UIKit

class InfoTableViewController: UITableViewController {
    
    @IBAction func doneButtonTapped(_ sender: AnyObject?) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
