//
//  DissmissSegue.swift
//  AudioFrame
//
//  Created by Aaron Anthony on 2017-07-16.
//  Copyright © 2017 SphericalWave. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceViewController = self.source
        sourceViewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
