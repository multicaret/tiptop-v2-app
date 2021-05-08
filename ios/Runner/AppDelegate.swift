import UIKit
import Flutter
import GoogleMaps
import Mobilisten

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var salesIqMethodChannel: FlutterMethodChannel?

    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GMSServices.provideAPIKey("AIzaSyAJZv7luVqour5IPa4eFaKjYgRW0BGEpaw")
        ZohoSalesIQ.initWithAppKey("WYvyGrbC0pATvONdL3c8ilXXeXe3zJF2xJBP5Xix%2F7Qwhw7ix9iNRVSnV2hnR4GB", accessKey: "Llhnjg8S5adEww9ouZy8KMwfnI8ARBihopvgWOT0sQysGovHGKS%2Boc0nJKrA4h5FqOyZhpanlX8lX7nRTlbHIKeS9Tk453wiTbVCOxF%2BTTWPomKTsVtG%2FA6WiwJazCvw0qAedSksBGelycJMNh4AAUBWJL%2FT9Tqj")

        let customTheme = ZohoSalesIQ.Theme.baseTheme
        //Customize properties in the customTheme instance as desired
        customTheme.themeColor = UIColor(rgb: 0xffb200)
        //        customTheme.Navigation.backgroundColor = UIColor.white
        //Set the customized theme using ZohoSalesIQ.Theme.setTheme API
        ZohoSalesIQ.Theme.setTheme(theme: customTheme)

        ZohoSalesIQ.showLauncher(false);
        ZohoSalesIQ.Chat.setTitle("TipTop")

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        // SalesIQ Channel
        salesIqMethodChannel = FlutterMethodChannel(name: "tiptop/salesIQ", binaryMessenger: controller.binaryMessenger)
        salesIqMethodChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            print("===============")
            print("call")
            print("\(call.method)")
            print("===============")

            if (call.method == "initLiveChat") {
                if let args = call.arguments as? Dictionary<String, Any> {
                    if let userName = args["userName"] as? String {
                        ZohoSalesIQ.Visitor.setName(userName)
                    }
                    if let userEmail = args["userEmail"] as? String {
                        ZohoSalesIQ.Visitor.setEmail(userEmail)
                    }
                    if let userNumber = args["userNumber"] as? String {
                        ZohoSalesIQ.Visitor.setContactNumber(userNumber)
                    }
                    if var languageCode = args["languageCode"] as? String {
                        if (languageCode == "fa" || languageCode == "ku") {
                            languageCode = "en"
                        }
                        ZohoSalesIQ.Chat.setLanguageWithCode(languageCode)
                    }
                    if let userId = args["userId"] as? String {
                        ZohoSalesIQ.registerVisitor(userId)
                    }
                    let isAuth = args["isAuth"] as? Bool;
                    ZohoSalesIQ.Chat.show(new: true)
                    ZohoSalesIQ.Chat.setVisibility(.preChatForm, visible: !(isAuth ?? false))
                    result(nil)
                } else {
                    result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
                }
                //                result(FlutterMethodNotImplemented)
                return
            }
        })

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
