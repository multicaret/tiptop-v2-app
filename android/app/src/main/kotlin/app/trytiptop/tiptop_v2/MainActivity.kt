package app.trytiptop.tiptop_v2

import com.zoho.commons.ChatComponent
import com.zoho.livechat.android.ZohoLiveChat
import com.zoho.salesiqembed.ZohoSalesIQ
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val channel = "tiptop/salesIQ"

        MethodChannel(getFlutterView(), channel).setMethodCallHandler { call, result ->
            if (call.method == "initLiveChat") {
                val languageCode: String? = call.argument("languageCode")
                val userName: String? = call.argument("userName")
                val userEmail: String? = call.argument("userEmail")
                val isAuth: Boolean? = call.argument("isAuth")

                ZohoLiveChat.Chat.show()
                ZohoLiveChat.Chat.setVisibility(ChatComponent.prechatForm, !isAuth!!)
                ZohoLiveChat.Chat.setLanguage(languageCode);

                ZohoSalesIQ.Visitor.setName(userName)
                ZohoSalesIQ.Visitor.setEmail(userEmail)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun provideSplashScreen(): SplashScreen? = SplashView()

    //setting up Flutter Engine View
    private fun getFlutterView(): BinaryMessenger? {
        return flutterEngine?.dartExecutor?.binaryMessenger
    }
}
