//
//  JJLaunchScreenAdTool.swift
//
//
//  Created by cao longjian on 2018/3/26.
//  Copyright © 2018年 ChuangChuang. All rights reserved.
//

import UIKit

private let AD_IMAGE_PATH = "adImage"

public class JJAdsLaunch: NSObject {

    public var view = UIView()
    public var duration: Int = 3
    
    private var defaultView: UIView!
    private let adImageView = UIImageView()
    
    private var disBlock: (() -> ())?
    
    public class func showWithAdFrame(frame: CGRect, configAds: (_ launch: JJAdsLaunch) -> (), dissBlock: (() -> ())? = nil) {
        //Info.plist 文件中添加 View controller-based status bar appearance 设置为 NO
        UIApplication.shared.isStatusBarHidden = true
        let launchAd = JJAdsLaunch()
        launchAd.view.frame = frame
        launchAd.disBlock = dissBlock
        launchAd.setCacheImage()
        configAds(launchAd)
    
        // 网络请求过长，直接不加载
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(launchAd.duration)) {
            if let _ = launchAd.adImageView.image {
                launchAd.diss()
            }
        }
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
        if adImageView.superview == nil {
            view.addSubview(adImageView)
        }
        adImageView.image = image
        saveCacheImage(image: image)
        diss()
    }
    
    public func diss() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
        
            UIView.animate(withDuration: 0.6, animations: {
                self.defaultView.alpha = 1.0
                self.defaultView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (complete) in
                self.view.removeFromSuperview()
                self.defaultView.removeFromSuperview()
                self.disBlock?()
                UIApplication.shared.isStatusBarHidden = false
            }
        }
    }
    
    
    //从缓存加载图片
    public func setCacheImage() {
        guard let imageData = JJAdsLaunch.getAdDataFromLocal(AD_IMAGE_PATH) else {
            return
        }
        adImageView.frame = view.bounds
        adImageView.contentMode = .scaleAspectFill
        adImageView.image = UIImage.init(data: imageData)
        if adImageView.superview == nil {
            view.addSubview(adImageView)
        }
    }
    
    //图片缓存
    public func saveCacheImage(image: UIImage) {
        if let adData = UIImagePNGRepresentation(image) {
            JJAdsLaunch.saveDataToLocal(AD_IMAGE_PATH, data: adData)
            return
        }
        if let adData = UIImageJPEGRepresentation(image, 1.0) {
            JJAdsLaunch.saveDataToLocal(AD_IMAGE_PATH, data: adData)
            return
        }
    }
 
}



// MARK: - 本地缓存文件操作
extension JJAdsLaunch {
    /// 保存下载好的资源到本地沙盒
    ///
    /// - Parameters:
    ///   - url: 资源路径
    ///   - data: 广告资源
    /// - Returns: 返回ture表示保存成功，false保存失败
    @discardableResult
    class func saveDataToLocal(_ url: String, data: Data?) -> Bool {
        guard data != nil, let filePath = self.filePath(url) else {
            return false
        }
        let isSuccess = NSKeyedArchiver.archiveRootObject(data!, toFile: filePath)
        return isSuccess
    }
    
    /// 获取本地缓存
    ///
    /// - Parameter url: 资源路径
    /// - Returns: 返回Data资源
    class func getAdDataFromLocal(_ url: String) -> Data? {
        guard let filePath = self.filePath(url) else {
            return nil
        }
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
        return data
    }
    
    /// 删除本地缓存的广告资源
    ///
    /// - Parameter url: 资源路径
    /// - Returns: 返回ture表示删除成功，false删除失败
    @discardableResult
    public class func clearAdDataFromLocal(_ url: String) -> Bool {
        guard let filePath = self.filePath(url) else {
            return false
        }
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(at: URL.init(fileURLWithPath: filePath))
            } catch {
                print(error)
                return false
            }
        }
        return true
    }
    
    /// 删除本地所有缓存
    ///
    /// - Returns: 返回ture表示删除成功，false删除失败
    @discardableResult
    public class func clealAllLocalCache() -> Bool {
        guard let filePath = self.rootFilePath() else {
            return false
        }
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(at: URL.init(fileURLWithPath: filePath))
            } catch {
                print(error)
                return false
            }
        }
        return true
    }
    
    /// 获取本地缓存的文件路径，没有则创建一个
    ///
    /// - Parameter url: 资源路径
    /// - Returns: 返回保存广告资源的文件路径
    class func filePath(_ url: String) -> String? {
        guard let filePath = self.rootFilePath() else {
            return nil
        }
        // 把资源路径通过MD5加密后，作为文件的名称进行保存
        //return (filePath as NSString).appendingPathComponent(url.td.md5 + ".data")
        return (filePath as NSString).appendingPathComponent(url)
    }
    
    class func rootFilePath() -> String? {
        let docDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let filePath = (docDir as NSString).appendingPathComponent("LuanchAdDataSource")
        if !FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return nil
            }
        }
        return filePath
    }
}
