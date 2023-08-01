//
//  BaseNavigationController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/31.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isOpaque = false
        navigationBar.isTranslucent = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
