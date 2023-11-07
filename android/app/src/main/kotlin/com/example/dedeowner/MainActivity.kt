package com.smlsoft.dedeowner

import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;

class MainActivity: FlutterActivity() {
      AppCenter.start(getApplication(), "5ff2b340-ec58-4b85-aa90-1f15dffa5d25",
                  Analytics.class, Crashes.class);
}
