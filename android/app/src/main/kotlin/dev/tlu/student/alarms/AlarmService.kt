/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.tlu.student.alarms

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Binder
import android.os.Build
import android.os.IBinder
import dev.tlu.student.AlarmActivity
import dev.tlu.student.provider.Alarm
import dev.tlu.student.provider.AlarmState
import dev.tlu.student.utils.AlarmAlertWakeLock

/**
 * This service is in charge of starting/stopping the alarm. It will bring up and manage the
 * [AlarmActivity] as well as [AlarmKlaxon].
 *
 * Registers a broadcast receiver to listen for snooze/dismiss intents. The broadcast receiver
 * exits early if AlarmActivity is bound to prevent double-processing of the snooze/dismiss intents.
 */
class AlarmService : Service() {
    /** Binder given to AlarmActivity.  */
    private val mBinder: IBinder = Binder()

    /** Whether the service is currently bound to AlarmActivity  */
    private var mIsBound = false

    /** Listener for changes in phone state.  */
//    private val mPhoneStateListener = PhoneStateChangeListener()

    /** Whether the receiver is currently registered  */
    private var mIsRegistered = false

    override fun onBind(intent: Intent?): IBinder {
        mIsBound = true
        return mBinder
    }

    override fun onUnbind(intent: Intent?): Boolean {
        mIsBound = false
        return super.onUnbind(intent)
    }

//    private lateinit var mTelephonyManager: TelephonyManager
    private var mCurrentAlarm: Alarm? = null

    private fun startAlarm(alarm: Alarm) {
        // println("[Android] AlarmService.start with instance: ${alarm.id}")
        if (mCurrentAlarm != null) {
//            AlarmStateManager.setMissedState(this, mCurrentAlarm!!)
            stopAlarm()
        }

        AlarmAlertWakeLock.acquireCpuWakeLock(this)

        mCurrentAlarm = alarm
        AlarmNotifications.showAlarmNotification(this, alarm)
//        mTelephonyManager.listen(mPhoneStateListener.init(), PhoneStateListener.LISTEN_CALL_STATE)
        AlarmKlaxon.start(this, alarm)
        sendBroadcast(Intent(ALARM_ALERT_ACTION).putExtra(Alarm.NAME,alarm))
    }

    private fun stopAlarm() {
        if (mCurrentAlarm == null) {
//            LogUtils.v("There is no current alarm to stop")
            return
        }

//        val id1 = mCurrentAlarm!!.mId
//        LogUtils.v("AlarmService.stop with instance: %s", instanceId)

        AlarmKlaxon.stop(this)
//        mTelephonyManager.listen(mPhoneStateListener, PhoneStateListener.LISTEN_NONE)
        sendBroadcast(Intent(ALARM_DONE_ACTION))

        stopForeground(STOP_FOREGROUND_REMOVE)

        mCurrentAlarm = null
        AlarmAlertWakeLock.releaseCpuLock()
    }

    private val mActionsReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action: String? = intent.action
            // println("[Android] ServiceReceived!")
//            val id: Int = intent.getIntExtra("id", -1)
//            if (id == -1) {
//                return
//            }
//            LogUtils.i("AlarmService received intent %s", action)
            if (mCurrentAlarm == null/* ||
                    mCurrentAlarm!!.mAlarmState != InstancesColumns.FIRED_STATE*/) {
//                LogUtils.i("No valid firing alarm")
                return
            }
            val alarm = mCurrentAlarm

            if (mIsBound) {
//                LogUtils.i("AlarmActivity bound; AlarmService no-op")
                return
            }

            when (action) {
                ALARM_SNOOZE_ACTION -> {
                    // Set the alarm state to snoozed.
                    // If this broadcast receiver is handling the snooze intent then AlarmActivity
                    // must not be showing, so always show snooze toast.
                    AlarmStateManager.setSnoozeState(context, mCurrentAlarm!!, true /* showToast */)
//                    Events.sendAlarmEvent(R.string.action_snooze, R.string.label_intent)
                }
                ALARM_DISMISS_ACTION -> {
                    // Set the alarm state to dismissed.
                    AlarmStateManager.unregisterInstance(context, alarm!!.id)
//                    Events.sendAlarmEvent(R.string.action_dismiss, R.string.label_intent)
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
//        mTelephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        // Register the broadcast receiver
        val filter = IntentFilter(ALARM_SNOOZE_ACTION)
        filter.addAction(ALARM_DISMISS_ACTION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            registerReceiver(mActionsReceiver, filter, Context.RECEIVER_EXPORTED)
        }
        mIsRegistered = true
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // println("[Android] ServiceCommandReceived!")
//        LogUtils.v("AlarmService.onStartCommand() with %s", intent)
        if (intent == null) {
            return START_NOT_STICKY
        }

//        val id = intent.getIntExtra("id", -1)
//        if (id == -1) {
//            return Service.START_NOT_STICKY
//        }
        when (intent.action) {
            AlarmStateManager.CHANGE_STATE_ACTION -> {
//                AlarmStateManager.handleIntent(this, intent)

                // If state is changed to firing, actually fire the alarm!
                val alarmState: Int = intent.getIntExtra(AlarmStateManager.ALARM_STATE_EXTRA, -1)
                if (alarmState == AlarmState.FIRED_STATE) {
//                    val cr: ContentResolver = this.getContentResolver()
                    val alarm: Alarm? = intent.getParcelableExtra(Alarm.NAME)
                    if (alarm == null) {
//                        LogUtils.e("No instance found to start alarm: %d", instanceId)
                        if (mCurrentAlarm != null) {
                            // Only release lock if we are not firing alarm
                            AlarmAlertWakeLock.releaseCpuLock()
                        }
                    } else if (mCurrentAlarm != null && mCurrentAlarm!!.id == alarm.id) {
//                        LogUtils.e("Alarm already started for instance: %d", instanceId)
                    } else {
                        startAlarm(alarm)
                    }
                } else if (alarmState == AlarmState.DISMISSED_STATE) {
                    stopAlarm()
                    stopSelf()
                }
            }

            STOP_ALARM_ACTION -> {
//                if (mCurrentAlarm != null && mCurrentAlarm!!.mId != id) {
//                    LogUtils.e("Can't stop alarm for instance: %d because current alarm is: %d",
//                            id, mCurrentAlarm!!.mId)
//                } else {
//                }
                stopAlarm()
                stopSelf()
            }
        }

        return START_NOT_STICKY
    }

    override fun onDestroy() {
//        LogUtils.v("AlarmService.onDestroy() called")
        super.onDestroy()
        if (mCurrentAlarm != null) {
            stopAlarm()
        }

        if (mIsRegistered) {
            unregisterReceiver(mActionsReceiver)
            mIsRegistered = false
        }
    }

//    private inner class PhoneStateChangeListener : PhoneStateListener() {
//        private var mPhoneCallState = 0
//
//        fun init(): PhoneStateChangeListener {
//            mPhoneCallState = -1
//            return this
//        }
//
//        override fun onCallStateChanged(state: Int, ignored: String?) {
//            if (mPhoneCallState == -1) {
//                mPhoneCallState = state
//            }
//
////            if (state != TelephonyManager.CALL_STATE_IDLE && state != mPhoneCallState) {
////                startService(AlarmStateManager.createStateChangeIntent(this@AlarmService,
////                        "AlarmService", mCurrentAlarm!!, 99))
////            }
//        }
//    }

    companion object {
        /**
         * AlarmActivity and AlarmService (when unbound) listen for this broadcast intent
         * so that other applications can snooze the alarm (after ALARM_ALERT_ACTION and before
         * ALARM_DONE_ACTION).
         */
        const val ALARM_SNOOZE_ACTION = "dev.tlu.student.ALARM_SNOOZE"

        /**
         * AlarmActivity and AlarmService listen for this broadcast intent so that other
         * applications can dismiss the alarm (after ALARM_ALERT_ACTION and before ALARM_DONE_ACTION).
         */
        const val ALARM_DISMISS_ACTION = "dev.tlu.student.ALARM_DISMISS"

        /** A public action sent by AlarmService when the alarm has started.  */
        const val ALARM_ALERT_ACTION = "dev.tlu.student.ALARM_ALERT"

        /** A public action sent by AlarmService when the alarm has stopped for any reason.  */
        const val ALARM_DONE_ACTION = "dev.tlu.student.ALARM_DONE"

        /** Private action used to stop an alarm with this service.  */
        const val STOP_ALARM_ACTION = "STOP_ALARM"

        /**
         * Utility method to help stop an alarm properly. Nothing will happen, if alarm is not firing
         * or using a different instance.
         *
         * @param context application context
         * @param id you are trying to stop
         */
        @JvmStatic
        fun stopAlarm(context: Context, id: Int) {
            val intent: Intent = Intent(context, AlarmService::class.java)
                    .putExtra("id", id)
                    .setAction(STOP_ALARM_ACTION)

            // We don't need a wake lock here, since we are trying to kill an alarm
            context.startService(intent)
        }
    }
}