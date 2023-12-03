package com.krmeiirbek.historyApp

import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.security.ProviderInstaller
import android.content.Intent
import android.util.Log

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        try {
            ProviderInstaller.installIfNeeded(this)
        } catch (e: Exception) {
            Log.e("MainActivity", "Google Play Services ProviderInstaller not found or failed to update.")
        }
    }
}