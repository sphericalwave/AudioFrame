//
//  SegmentedViewController.swift
//  AudioFrame
//
//  Created by Aaron Anthony on 2017-07-16.
//  Copyright © 2017 SphericalWave. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var containerA: UIView!
    @IBOutlet weak var containerB: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var randomBar: UIBarButtonItem!
    @IBOutlet weak var loopButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.7, animations: {
                self.containerA.alpha = 1
                self.containerB.alpha = 0
            })
            //self.showSwitch()
            self.randomBar.isEnabled = true
            self.loopButton.isEnabled = true
            
        case 1:
            UIView.animate(withDuration: 0.7, animations: {
                self.containerA.alpha = 0
                self.containerB.alpha = 1
                
            })
            //self.showCycle()
            self.randomBar.isEnabled = false
            self.loopButton.isEnabled = false
        default:
            print("Default Case")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
