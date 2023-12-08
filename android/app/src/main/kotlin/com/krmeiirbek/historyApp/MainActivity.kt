package com.krmeiirbek.historyApp

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.view.WindowManager
import com.google.android.gms.security.ProviderInstaller
import android.util.Log

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

        try {
            ProviderInstaller.installIfNeeded(this)
        } catch (e: Exception) {
            Log.e("MainActivity", "Google Play Services ProviderInstaller not found or failed to update.")
        }
    }
}