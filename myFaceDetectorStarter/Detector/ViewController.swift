//
//  ViewController.swift
//  Detector
//
//  Created by Mac on 10/21/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

private let eyeScale:CGFloat = 0.2
private let mouthScale = 0.3
private let minIndex = 1
private let maxIndex = 5

class ViewController: UIViewController {
    var index = 1
    
    @IBOutlet weak var personPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        personPic.image = UIImage(named: "face-1")
        personPic.image = UIImage(named: "face-" + "\(index)")
        self.navigationItem.title = "Face Detector"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Prev", style: .plain, target: self, action: #selector(previousButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action:#selector(nextButtonAction))
    }
    
    @objc private func previousButtonAction() {
       index -= 1
        if index < minIndex {
            index = minIndex
        }
        personPic.image = UIImage.init(named: "face-\(index)")
        detect1()
    }
    
    @objc private func nextButtonAction() -> () {
        index += 1
        if index > maxIndex {
            index = maxIndex
        }
        
        personPic.image = UIImage.init(named: "face-" + "\(index)")
        detect1()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detect1()
    }
    
    func detect1() {
        for view in personPic.subviews {
            view.removeFromSuperview()
        }
        
        guard let personCiImage = CIImage.init(image: personPic.image!) else { return  }
        let accuracy = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personCiImage)
        
        
        for face in faces as! [CIFaceFeature] {
            print("Found bounds : \(face.bounds)")
            
            let faceBox = getFaceViewBox(bounds: face.bounds)
            personPic.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds: \(face.leftEyePosition)");
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds: \(face.rightEyePosition)");
            }
            
            if face.hasMouthPosition {
                print("Mouth position: \(face.mouthPosition)")
            }
            
        }
    }
    
//    func setViewStyle(view:UIView) -> () {
//        view.backgroundColor = UIColor.clear
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.red.cgColor
//    }
    
    func getFaceViewBox(bounds:CGRect) -> UIView {
        //坐标系转换
        let ciImageSize = (CIImage.init(image: personPic.image!))!.extent.size  //图片真实大小
        let widthScale = personPic.bounds.size.width / ciImageSize.width
        let heightScale = personPic.bounds.size.height / ciImageSize.height
        let isScaleWidth = widthScale < heightScale //以长，还是以宽为比例
        let scale = isScaleWidth ? widthScale : heightScale //取小值
        
        let size = CGSize.init(width: bounds.size.width * scale, height: bounds.size.height * scale)    //大小是成比例的
        var origin = CGPoint.zero
        if isScaleWidth {   //如果以宽为比例
            origin.x = bounds.origin.x * scale  //x直接是x * scale
            //(personPic.bounds.size.height - ciImageSize.height * scale) * 0.5   图片显示的y（相对于imageView位置，图片的y轴）
            // 人脸区域相对于图片y轴的坐标系转换（ciImageSize.height - bounds.origin.y - bounds.size.height） * scale(乘以比例) = 图片中人脸坐标转换
            origin.y = (personPic.bounds.size.height - ciImageSize.height * scale) * 0.5 + (ciImageSize.height - bounds.origin.y - bounds.size.height) * scale
            
        }else{
            origin.x = (personPic.bounds.size.width - ciImageSize.width * scale) * 0.5 + bounds.origin.x * scale
            origin.y = (ciImageSize.height - bounds.origin.y - bounds.size.height) * scale
        }
        
        print(origin)
        
        let view = UIView.init(frame: CGRect.init(origin: origin, size: size))
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        return view
        
    }
}
