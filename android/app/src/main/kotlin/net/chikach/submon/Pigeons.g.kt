// Copyright 2023 chika All Rights Reserved.
// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError(
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Whether the notification permission has been granted or denied. */
enum class NotificationPermissionState(val raw: Int) {
  GRANTED(0),
  DENIED(1);

  companion object {
    fun ofRaw(raw: Int): NotificationPermissionState? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * Wraps a NotificationPermissionState enum.
 * (Pigeon cannot handle enums as primitive return values)
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class NotificationPermissionStateWrapper(
  val value: NotificationPermissionState

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): NotificationPermissionStateWrapper {
      val value = NotificationPermissionState.ofRaw(list[0] as Int)!!
      return NotificationPermissionStateWrapper(value)
    }
  }

  fun toList(): List<Any?> {
    return listOf<Any?>(
      value.raw,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object MessagingApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          NotificationPermissionStateWrapper.fromList(it)
        }
      }

      else -> super.readValueOfType(type, buffer)
    }
  }

  override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
    when (value) {
      is NotificationPermissionStateWrapper -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }

      else -> super.writeValue(stream, value)
    }
  }
}

/**
 * A set of APIs to handle Firebase Cloud Messaging.
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface MessagingApi {
  /**
   * Returns true if the Google Play Services are available on the device.
   * Only available on Android.
   */
  fun isGoogleApiAvailable(): Boolean

  /** Gets the FCM token for this device. Returns null if failed. */
  fun getToken(callback: (Result<String?>) -> Unit)

  /** Requests notification permission from the user. */
  fun requestNotificationPermission(callback: (Result<NotificationPermissionStateWrapper?>) -> Unit)

  companion object {
    /** The codec used by MessagingApi. */
    val codec: MessageCodec<Any?> by lazy {
      MessagingApiCodec
    }

    /** Sets up an instance of `MessagingApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: MessagingApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(
          binaryMessenger,
          "dev.flutter.pigeon.submon.MessagingApi.isGoogleApiAvailable",
          codec
        )
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.isGoogleApiAvailable())
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.MessagingApi.getToken", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getToken() { result: Result<String?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(
          binaryMessenger,
          "dev.flutter.pigeon.submon.MessagingApi.requestNotificationPermission",
          codec
        )
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.requestNotificationPermission() { result: Result<NotificationPermissionStateWrapper?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}

/**
 * Browser-related APIs.
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface BrowserApi {
  /**
   * Opens a custom tab which returns the callback URL.
   * Returns null if cancelled.
   *
   * This method is only available on Android.
   */
  fun openAuthCustomTab(url: String, callback: (Result<String?>) -> Unit)

  /**
   * Opens a web page in WebView activity (on Android) or
   * [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
   * (on iOS).
   *
   * `title` is used as the title of the activity on Android.
   * (unused on iOS)
   */
  fun openWebPage(title: String, url: String)

  companion object {
    /** The codec used by BrowserApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }

    /** Sets up an instance of `BrowserApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: BrowserApi?) {
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.BrowserApi.openAuthCustomTab", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val urlArg = args[0] as String
            api.openAuthCustomTab(urlArg) { result: Result<String?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.BrowserApi.openWebPage", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val titleArg = args[0] as String
            val urlArg = args[1] as String
            var wrapped: List<Any?>
            try {
              api.openWebPage(titleArg, urlArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}

/**
 * General APIs.
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface GeneralApi {
  /** Updates the widgets on the home screen. */
  fun updateWidgets()

  /** Requests the IDFA (Identifier for Advertisers) from the user on iOS. */
  fun requestIDFA(callback: (Result<Boolean>) -> Unit)

  /** Sets the wake lock (`isIdleTimerDisabled` on iOS, `` on Android) state. */
  fun setWakeLock(enabled: Boolean)

  /**
   * Sets the fullscreen state.
   *
   * This method is only available on Android.
   */
  fun setFullscreen(isFullscreen: Boolean)

  companion object {
    /** The codec used by GeneralApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }

    /** Sets up an instance of `GeneralApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: GeneralApi?) {
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.GeneralApi.updateWidgets", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.updateWidgets()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.GeneralApi.requestIDFA", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.requestIDFA() { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.GeneralApi.setWakeLock", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val enabledArg = args[0] as Boolean
            var wrapped: List<Any?>
            try {
              api.setWakeLock(enabledArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel =
          BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.submon.GeneralApi.setFullscreen", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val isFullscreenArg = args[0] as Boolean
            var wrapped: List<Any?>
            try {
              api.setFullscreen(isFullscreenArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
