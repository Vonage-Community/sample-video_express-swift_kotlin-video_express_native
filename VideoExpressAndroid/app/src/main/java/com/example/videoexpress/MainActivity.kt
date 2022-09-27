package com.example.videoexpress

import android.Manifest
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import androidx.core.app.ActivityCompat
import okhttp3.*
import java.io.IOException
import org.json.JSONObject

class MainActivity : AppCompatActivity() {
    companion object {
        const val  baseURL = "BASE_URL_HERE"
    }
    private val client = OkHttpClient()
    lateinit var sessionID: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val label: TextView = findViewById(R.id.sessionLabel)
        val sessionButton: Button = findViewById(R.id.sessionButton)
        val joinButton: Button = findViewById(R.id.joinButton)
        val progressBar: ProgressBar = findViewById(R.id.pBar)

        val callsPermissions = arrayOf(Manifest.permission.RECORD_AUDIO, Manifest.permission.MODIFY_AUDIO_SETTINGS, Manifest.permission.CAMERA)
        ActivityCompat.requestPermissions(this, callsPermissions, 123)

        sessionButton.setOnClickListener {
            val request = Request.Builder()
                .url("${baseURL}/session")
                .build()

            progressBar.visibility = View.VISIBLE
            sessionButton.visibility = View.INVISIBLE

            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    e.printStackTrace()
                }

                override fun onResponse(call: Call, response: Response) {
                    val res = response.body!!.string()
                    val json = JSONObject(res)
                    sessionID = json["session"].toString()
                    runOnUiThread {
                        progressBar.visibility = View.INVISIBLE
                        label.visibility = View.VISIBLE
                        label.text = "Session ID: ${sessionID}"
                        joinButton.visibility = View.VISIBLE
                    }
                }
            })
        }

        joinButton.setOnClickListener {
            val intent = Intent(this, VideoActivity::class.java)
            intent.putExtra("SESSION_ID", sessionID);
            startActivity(intent)
        }


    }
}