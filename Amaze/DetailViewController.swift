//
//  DetailViewController.swift
//  Amaze
//
//  Created by Scott Tury on 9/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

extension MazeHelper {
    
    func update(with settings:MazeSettings ) {
        cellSize = settings.cellSize
        strokeSize = settings.strokeSize
        braided = settings.braided
        braidValue = settings.braidValue
        
        //self.mazeSize
    }
}

class DetailViewController: UIViewController, UIScrollViewDelegate, SettingsViewControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var refresh : UIBarButtonItem!
    @IBOutlet weak var action : UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!

    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    var rotationRecognizer : UIRotationGestureRecognizer?
    
    var settings : MazeSettings = MazeSettings() {
        didSet {
            if let helper = helper {
                // update the helper with the info from the Settings!
                helper.update(with: settings)
            }
        }
    }
    
    /// Store a MazeHelper object, which allows us to generate the type of mazes the user selected.
    var helper: MazeHelper? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    /// This is a Grid object for the current Maze. From this we can generate a new maze image!
    private var grid: Grid?
    private var pdfImage : Data? = nil
    
    func showImage(_ image: Image, pdf: Data? = nil) {
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
        // Store the PDF version just in case...
        if let pdf = pdf {
            pdfImage = pdf
        }
        else {
            pdfImage = nil
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
        if let image = helper?.image(for: grid), let pdf = helper?.pdfImage(for: grid) {
            DispatchQueue.main.async { [weak self] in
                if let activityIndicator = self?.activityIndicator {
                    activityIndicator.stopAnimating()
                }
                self?.showImage(image, pdf: pdf)
            }
        }
    }
    
    func configureView() {
        var process = false
        switch (UIDevice.current.userInterfaceIdiom) {
        case .phone:
            process = self.isViewLoaded
        case .pad:
            process = true
        default:
            process = true
        }
        if process {
            if let helper = helper {
                settings.update(with: helper)
                asyncGenerateMaze()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        scrollView.delegate = self
        scrollView.autoresizesSubviews = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(DetailViewController.handleRotate(_:)))
        if let rotationRecognizer = rotationRecognizer {
            rotationRecognizer.delegate = self
            scrollView.addGestureRecognizer(rotationRecognizer)
        }
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onAction(_ sender: UIBarButtonItem) {
        // Open up the Action sheet, with the Image in the list of what you want to share.
        var items = [Any]()
        
        // Should I send the PDF, or the Bitmap image?
        // Looking online I see that if you provide a URL to the image, that will give you a basic
        // filename for the file, and allow you to use the save to Files capabilities.  If you
        // don't, it'll let ou print the image, but not save it to Photos.
        // If I include both, I get the option to save the image, as well as Print.  Printing prints
        // both images.  So you get a PDF printing, and a Raster printing of the image.
//        if let pdfImage = pdfImage {
//            items.append(pdfImage as Any)
//        }
        if let image = imageView.image {
            items.append( image )
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            //On iPad, you must present the view controller in a popover.
            activityVC.modalPresentationStyle = .popover
            // Remember to setup the Popover based on where you're activating it from...
            if let popOver = activityVC.popoverPresentationController {
              //popOver.sourceView = UIView
              //popOver.sourceRect =
              popOver.barButtonItem = sender
            }
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
    
    func asyncGenerateMaze() {
        if let activityIndicator = activityIndicator {
            activityIndicator.startAnimating()
        }
        if let imageView = imageView {
            imageView.image = nil
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let strongSelf = self, let helper = strongSelf.helper  {
                strongSelf.grid = helper.generateMaze(strongSelf.settings.algorithmMaze(), (strongSelf.settings.rows, strongSelf.settings.cols))
                if let grid = strongSelf.grid {
                    strongSelf.showImage(grid)
                }
            }
        }
    }
    
    func updatedSettings(_ settings: MazeSettings) {
        // Need to comparte the settings given to me with what I have already.
        // If they've changed a lot, I need to re-render the image.
        
        print( "updatedSettings(\(settings))" )
        
        if let gridRows = grid?.rows, let gridColumns = grid?.columns {
            if settings.rows != gridRows || settings.cols != gridColumns ||
                settings.algorithm != self.settings.algorithm ||
                settings.braided != self.settings.braided ||
                settings.braidValue != self.settings.braidValue {
                self.settings = settings
                asyncGenerateMaze()
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

    // MARK: Rotation support
    
    @IBAction @objc func handleRotate(_ recognizer : UIRotationGestureRecognizer ) {
        recognizer.view?.transform = CGAffineTransform.init(rotationAngle: recognizer.rotation)
        //recognizer.rotation = 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

