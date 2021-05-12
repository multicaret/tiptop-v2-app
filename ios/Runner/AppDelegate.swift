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
        ZohoSalesIQ.initWithAppKey("WYvyGrbC0pCStz42C7GcQgeovx1CR3OPsyGvhE5NeHU%3D", accessKey: "KJcCPJe5tzo%2BrJh3ywsR7vC9D5Sw2Hq6carML4IROSPk14wo2S82JnMf%2BWW0yQvXd69OKZZDpN%2FWhOUZDrDXO2zsz9y6n%2FIlYzTKBHwcrqUexKHZLmyMSVNX0FjYKA2xjYgQGwBVm9eAZzF%2BuCSVww%3D%3D")

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
