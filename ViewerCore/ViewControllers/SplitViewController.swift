//
//  SplitViewController.swift
//  AnywhereViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

class SplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
