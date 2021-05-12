package app.trytiptop.customer;

import com.instabug.instabugflutter.InstabugFlutterPlugin;
import com.zoho.commons.Fonts;
import com.zoho.commons.InitConfig;
import com.zoho.livechat.android.ZohoLiveChat;
import com.zoho.salesiqembed.ZohoSalesIQ;

import java.util.ArrayList;

import io.flutter.app.FlutterApplication;

public class MyFlutterApplication extends FlutterApplication {

    String appKey = "WYvyGrbC0pCStz42C7GcQgeovx1CR3OPsyGvhE5NeHU%3D";
    String accessKey = "Llhnjg8S5adF2PM7qYwzQK%2BoI%2FoxCyYiQnX%2BV0r10NrCw%2BDJQ6L599ubgT2D43BerJW0%2BlIq%2B9OVr4sUcqpGJj3wkRhweWfVlzwvPSMwvh%2Ft4s26d8OcQQF8ztd7naiyWZj1eCrw9ZvQPETDpfajHNpVOOMTueCM";

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
