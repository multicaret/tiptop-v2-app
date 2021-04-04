package app.trytiptop.tiptop_v2;

import com.instabug.instabugflutter.InstabugFlutterPlugin;

import java.util.ArrayList;

import io.flutter.app.FlutterApplication;

public class MyFlutterApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        ArrayList<String> invocationEvents =
                new
                        ArrayList<>();
        invocationEvents.add(InstabugFlutterPlugin.INVOCATION_EVENT_SHAKE);
        new InstabugFlutterPlugin().start(MyFlutterApplication.this,
                "82b5d29b0a4494bc9258e2562578037e",
                invocationEvents);
    }
}
