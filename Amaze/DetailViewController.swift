//
//  DetailViewController.swift
//  Amaze
//
//  Created by Scott Tury on 9/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

class DetailViewController: UIViewController, UIScrollViewDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var refresh : UIBarButtonItem!
    @IBOutlet weak var action : UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!

    var settings : MazeSettings = MazeSettings()
    
    /// Store a MazeHelper object, which allows us to generate the type of mazes the user selected.
    var helper: MazeHelper? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    /// This is a Grid object for the current Maze. From this we can generate a new maze image!
    private var grid: Grid?
    
    func showImage(_ image: Image) {
        if let imageView = imageView {
            // reset scrollView and imageView before modifing updating the image.
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            scrollView.contentSize = CGSize(width: 0, height: 0)
            scrollView.zoomScale = 1.0
            
            imageView.image = image
            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            imageView.frame = imageRect
            scrollView.contentSize = CGSize(width: image.size.width, height: image.size.height)
            
            // Ok, how large is the image?  Can we set the scale such that we can show the entire maze when we show it?
            // which is the max?
            let scrollViewSize = scrollView.frame.size
            if max( scrollViewSize.width, scrollViewSize.height ) == scrollViewSize.height {
                // calculate the scale to fit the width!
                let scale = scrollViewSize.width / image.size.width
                scrollView.zoomScale = scale
            }
            else {
                // Calculate the scale to fit the height!
                let scale = scrollViewSize.height / image.size.height
                scrollView.zoomScale = scale
            }
        }
    }
    
    func showImage(_ grid: Grid ) {
        var coloredGrid = grid as? ColoredGrid
        if settings.useColor {
            coloredGrid?.mode = settings.colorMode()
            if settings.showSolution {
                _ = helper?.longestPath(grid)
            }
            else {
                coloredGrid?.distances = helper?.startCell(grid)?.distances()
            }
        }
        else {
            // clear out the distances if the user doesn't want the colors rendered.
            coloredGrid?.distances = nil
        }
        if let image = helper?.image(for: grid) {
            showImage(image)
        }
    }
    
    func configureView() {
        if let helper = helper {
            grid = helper.generateMaze(settings.rows) as Grid?
            if let grid = grid {
                showImage(grid)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        scrollView.delegate = self
        scrollView.autoresizesSubviews = true
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onAction(_ sender: UIBarButtonItem) {
        // Open up the Action sheet, with the Image in the list of what you want to share.
        let activityVC = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
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
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            if let vc = segue.destination as? SettingsViewController {
                vc.setup(with: settings)
                vc.delegate = self
            }
            
            // Based on the Row, we'll want to create different MazeHelper objects for the DetailViewController to use.
            //controller.helper = mazeHelper(for: object.type)
            
//            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK:  UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
////        print( "scrollView = \(scrollView), zoomScale = \(scrollView.zoomScale)" )
////        if let imageView = imageView {
////            if let image = imageView.image {
////                let zoom = scrollView.zoomScale
//////                imageView.frame = CGRect(x: 0, y: 0, width: image.size.width*zoom, height: image.size.height*zoom)
////
////            }
////        }
//
//    }
    
    func updatedSettings(_ settings: MazeSettings) {
        // Need to comparte the settings given to me with what I have already.
        // If they've changed a lot, I need to re-render the image.
        
        print( "updatedSettings(\(settings))" )
        
        if let gridRows = grid?.rows, let helper = helper {
            if settings.rows != gridRows {
                self.settings = settings
                grid = helper.generateMaze(settings.rows) as Grid?
                if let grid = grid {
                    showImage(grid)
                }
            }
            else {
                self.settings = settings
                // otherwise just update the image?
                if let grid = grid {
                    showImage(grid)
                }
            }

        }

    }

}

