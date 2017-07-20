

//
//  CameraViewController.swift
//  Detector
//
//  Created by Mac on 10/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func detect() -> () {
        print("detect")
        
        let imageOptions = NSDictionary.init(object: NSNumber.init(value: 5.0), forKey: CIDetectorImageOrientation as NSString)
        let personCiImage = CIImage.init(cgImage: imageView.image!.cgImage!)
        let accuracy = [CIDetectorAccuracy : CIDetectorAccuracyHigh];
        let faceDetector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personCiImage, options: imageOptions as? [String:AnyObject])
        
        if let face = faces?.first as? CIFaceFeature {
            print("found bounds are \(face.bounds)")
            
            let alert = UIAlertController.init(title: "Tip", message: "Face found", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            if face.hasSmile{
                print("face is smiling")
            }
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }else{
            let alert = UIAlertController.init(title: "Tip", message: "Face not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }        
        
    }
    
}

extension CameraViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        self.detect()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}



// mark: UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;


