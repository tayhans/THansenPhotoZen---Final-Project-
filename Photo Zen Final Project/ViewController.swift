//
//  SlideshowVC.swift
//  Photo Zen
//
//  Created by Taylor Hansen on 19/05/2017.
//  Copyright © 2017 Taylor Hansen. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageArray = [UIImage]()
    var selectedImageArray = [UIImage]()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var startShow: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray.append(UIImage(named: "image0")!)
        imageArray.append(UIImage(named: "image1")!)
        imageArray.append(UIImage(named: "image2")!)
        self.collectionView?.allowsMultipleSelection = true
        
        imagePicker.delegate = self
        
        func grabPhotos(){
        }
    }
    
    
    func grabPhotos() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 75, height: 75), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                        image, error in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("There are no photos!")
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexpath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout CollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout CollectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.alpha = 0.2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.alpha = 1.0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageArray.append(selectedImage)
        
        self.collectionView?.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //: ACTIONS
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func startSlideshow(_ sender: UIBarButtonItem) {  // changed that from "Slideshow"
        let VC = storyboard!.instantiateViewController(withIdentifier: "SlideshowVC") as! SlideshowVC
        let rows = collectionView?.indexPathsForSelectedItems!.sorted()
        self.selectedImageArray.removeAll()
        for c in rows! {
            self.selectedImageArray.append(self.imageArray[c.item])
        }
        
        VC.imageArray = self.selectedImageArray
        self.show(VC, sender: self)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { }
    
}

