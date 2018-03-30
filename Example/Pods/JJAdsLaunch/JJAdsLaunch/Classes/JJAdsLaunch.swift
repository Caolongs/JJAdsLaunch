//
//  JJLaunchScreenAdTool.swift
//
//
//  Created by cao longjian on 2018/3/26.
//  Copyright © 2018年 ChuangChuang. All rights reserved.
//

import UIKit

public class JJAdsLaunch: NSObject {

    public var view = UIView()
    public var duration: Int = 3
    
    private var defaultView: UIView!
    private let adImageView = UIImageView()
    
    private var disBlock: (() -> ())?
    
    public class func showWithAdFrame(frame: CGRect, configAds: (_ launch: JJAdsLaunch) -> (), dissBlock: (() -> ())? = nil) {
        
        let launchAd = JJAdsLaunch()
        launchAd.view.frame = frame
        launchAd.disBlock = dissBlock
        configAds(launchAd)
    
    }
    
    override init() {
        super.init()
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        
        let startViewController = storyboard.instantiateInitialViewController()
        
        if let startView = startViewController?.view {
            defaultView = startView
        } else {
            return
        }

        UIApplication.shared.keyWindow?.addSubview(defaultView)
        
        defaultView.addSubview(view)
        view.backgroundColor = .clear
        
        UIApplication.shared.keyWindow?.bringSubview(toFront: view)
        
    }
    
    //网络请求加载图片、视频动画或者其他自定义的引导页
    public func addImage(image: UIImage) {
        adImageView.frame = view.bounds
        adImageView.contentMode = .scaleAspectFill
        view.addSubview(adImageView);
        adImageView.image = image
        diss()
    }
    
    
    public func diss() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
        
            UIView.animate(withDuration: 0.4, animations: {
                self.defaultView.alpha = 0.2
            }) { (complete) in
                self.view.removeFromSuperview()
                self.defaultView.removeFromSuperview()
                self.disBlock?()
            }
        }
    }
 
}
