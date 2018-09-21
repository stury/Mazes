//
//  DetailViewController.swift
//  Amaze
//
//  Created by Scott Tury on 9/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

class DetailViewController: UIViewController {

    @IBOutlet weak var refresh : UIBarButtonItem!
    @IBOutlet weak var action : UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!


    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
        if let helper = helper {
            if let image = helper.generateMaze(20) {
                if let imageView = imageView {
                    imageView.image = image
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var helper: MazeHelper? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    @IBAction func onAction(_ sender: UIBarButtonItem) {
        // Open up the Action sheet, with the Image in the list of what you want to share.
        let activityVC = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            //On iPad, you must present the view controller in a popover.
            activityVC.modalPresentationStyle = .popover
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            // On iPhone and iPod touch, you must present it modally.
            activityVC.modalPresentationStyle = .overCurrentContext //.currentContext
        }
        
        self.present(activityVC, animated: true) {
            print("Presented VC!")
        }
    }
    
    @IBAction func onRefresh(_ sender: UIBarButtonItem) {
        configureView()
    }

}

