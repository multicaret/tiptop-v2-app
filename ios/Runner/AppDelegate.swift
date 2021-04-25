import UIKit
import Flutter
import GoogleMaps
import Mobilisten


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAJZv7luVqour5IPa4eFaKjYgRW0BGEpaw")
        GeneratedPluginRegistrant.register(with: self)
        
        ZohoSalesIQ.initWithAppKey("WYvyGrbC0pATvONdL3c8ilXXeXe3zJF2xJBP5Xix%2F7Qwhw7ix9iNRVSnV2hnR4GB", accessKey:"Llhnjg8S5adEww9ouZy8KMwfnI8ARBihopvgWOT0sQysGovHGKS%2Boc0nJKrA4h5FqOyZhpanlX8lX7nRTlbHIKeS9Tk453wiTbVCOxF%2BTTWPomKTsVtG%2FA6WiwJazCvw0qAedSksBGelycJMNh4AAUBWJL%2FT9Tqj")
        
        let customTheme = ZohoSalesIQ.Theme.baseTheme
        //Customize properties in the customTheme instance as desired
        customTheme.themeColor = UIColor.blue
        customTheme.Navigation.backgroundColor = UIColor.white
        //Set the customized theme using ZohoSalesIQ.Theme.setTheme API
        ZohoSalesIQ.Theme.setTheme(theme: customTheme)
        
        ZohoSalesIQ.showLauncher(false);

        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let salesIqChannel = FlutterMethodChannel(name: "tiptop/salesIQ", binaryMessenger: controller.binaryMessenger)
        salesIqChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
                    print("===============")
                    print("call")
                    print("\(call.method)")
                    print("===============")
            
            if(call.method == "initLiveChat"){
//                if let args = call.arguments as? Dictionary<String, Any>,
//                   let passedLocale = args["locale"] as? String {
//                    result(nil)
//                } else {
//                    result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
//                }
                
                print("========= initializing Zoho SalesIQ:")
                ZohoSalesIQ.Chat.show(new: true)
                
                result(nil)
                
//                result(FlutterMethodNotImplemented)
                
                return
            }
            
            //TODO:
        })
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
