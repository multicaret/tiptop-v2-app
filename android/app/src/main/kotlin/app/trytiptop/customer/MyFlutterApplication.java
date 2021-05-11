package app.trytiptop.customer;

import com.instabug.instabugflutter.InstabugFlutterPlugin;
import com.zoho.commons.Fonts;
import com.zoho.commons.InitConfig;
import com.zoho.livechat.android.ZohoLiveChat;
import com.zoho.salesiqembed.ZohoSalesIQ;

import java.util.ArrayList;

import io.flutter.app.FlutterApplication;

public class MyFlutterApplication extends FlutterApplication {

    String appKey = "WYvyGrbC0pCOi8u9GmEbtLj2gk33FVUbRsn%2FNCsQpls%3D";
    String accessKey = "Llhnjg8S5adEww9ouZy8KDR%2BoFVM0FxIuDkDnA4yRjNtIorNsvQO7dK8%2F7EoaMOeSY0S14yH%2FWq2xCaLdyRXp6NNplpIP1k2247v1%2B4OZyPEkoAhyJK7uxPCANC9LnQa";

    @Override
    public void onCreate() {
        super.onCreate();
        ArrayList<String> invocationEvents = new ArrayList<>();
        invocationEvents.add(InstabugFlutterPlugin.INVOCATION_EVENT_SHAKE);
        new InstabugFlutterPlugin().start(MyFlutterApplication.this,
                "d2510301d448f73aa3f96f3cd74d44c6",
                invocationEvents);

        InitConfig initConfig = new InitConfig();
        initConfig.setFont(Fonts.MEDIUM, "fonts/neo_sans_arabic_medium.ttf");
        initConfig.setFont(Fonts.REGULAR, "fonts/neo_sans_arabic_regular.ttf");

        ZohoSalesIQ.init(this, appKey, accessKey, initConfig, null);
        ZohoSalesIQ.syncThemeWithOS(false);
        ZohoLiveChat.Conversation.setVisibility(false);
    }
}
