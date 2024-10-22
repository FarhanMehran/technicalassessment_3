//
//  ViewController.swift
//  AssessmentNO3
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, RSColourSliderDelegate {
    
    var canvasImageView: UIImageView!
    var textViewTextColor: UIColor = .white
    var textView: UITextView!
    var colourSlider: RSColourSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupImageView()
        setupColourSlider()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(addText))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
    }
    
    func setupImageView() {
        canvasImageView = UIImageView(frame: view.bounds)
        canvasImageView.image = UIImage(named: "image_1") // Load your image here
        canvasImageView.contentMode = .scaleAspectFit
        canvasImageView.isUserInteractionEnabled = true
        view.addSubview(canvasImageView)
    }
    
    @objc func addText() {
        setupTextField()
    }
    
    @objc func saveImage() {
        // Create a graphics context with the size of the canvas image view
        UIGraphicsBeginImageContextWithOptions(canvasImageView.frame.size, false, 0)
        
        // Render only the canvas image view's subviews
        canvasImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // Capture the new image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Save the image to the photo album
        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Image Saved", message: "Your edited image has been saved in high quality.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupTextField() {
        textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y, width: UIScreen.main.bounds.width, height: 30))
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textViewTextColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
        
        // Add toolbar with "Done" button
        addToolbarToTextView()
    }
    
    func addGestures(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(_:)))
        view.addGestureRecognizer(rotationGesture)
    }
    
    // Pan Gesture to move text
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: canvasImageView)
        if let textView = sender.view {
            textView.center = CGPoint(x: textView.center.x + translation.x, y: textView.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: canvasImageView)
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let textView = sender.view as? UITextView else { return }
        
        switch sender.state {
        case .began:
            textView.isUserInteractionEnabled = false
        case .changed:
            textView.transform = textView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        case .ended, .cancelled, .failed:
            textView.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    func addToolbarToTextView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        
        textView.inputAccessoryView = toolbar
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
    }

    @objc func doneButtonTapped() {
        textView.resignFirstResponder()
    }

    @objc func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        if let textView = sender.view {
            textView.transform = textView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    func setupColourSlider() {
        colourSlider = RSColourSlider(frame: CGRect(x: 0, y: 90, width: self.view.bounds.width, height: 30))
        colourSlider.delegate = self
        view.addSubview(colourSlider)
        
        colourSlider.delegate = self
        colourSlider.setCornerRadius(by: colourSlider.bounds.height / 2)
        colourSlider.setSliderValueBy(colour: .green)
    }
    
    func colourGotten(colour: UIColor) {
        if textView != nil {
            textViewTextColor = colour
            textView.textColor = textViewTextColor
        }
    }
}
