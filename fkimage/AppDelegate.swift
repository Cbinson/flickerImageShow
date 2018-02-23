//
//  AppDelegate.swift
//  fkimage
//
//  Created by binsonchang on 2017/12/21.
//  Copyright © 2017年 binsonchang. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let CACHE_SIZE:UInt = 2 * 1000 * 1000
    static let CACHE_AGE = 60 * 60 * 24 * 1
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("didFinish")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("willResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("didEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("willEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("didBecomeActive")
        
        print("[appdelegate]sd_cache_size:\(SDImageCache.shared().getSize())")
        print("[appdelegate]sd_disk_count:\(SDImageCache.shared().getDiskCount())")
        
        //不解壓縮
        SDImageCache.shared().config.shouldDecompressImages = false
        //圖片週期1天
        SDImageCache.shared().config.maxCacheAge = AppDelegate.CACHE_AGE
        //圖片快取2M
//        SDImageCache.shared().config.maxCacheSize = CACHE_SIZE
        
        //clear image cache
        if SDImageCache.shared().getSize() > AppDelegate.CACHE_SIZE {
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk(onCompletion: nil)
            SDImageCache.shared()
            print("[clear]sd_cache_size:\(SDImageCache.shared().getSize())")
            print("[clear]sd_disk_count:\(SDImageCache.shared().getDiskCount())")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("willTerminate")
    }


}

