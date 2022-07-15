package com.logfin.certificate

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.codef.cfcertmanager.CFCertManager
import io.codef.cfcertmanager.CFCertTransfer
import io.codef.cfcertmanager.callback.CFCertAuthNumberInterface
import io.codef.cfcertmanager.callback.CFCertImportInterface
import io.codef.cfcertmanager.callback.CFCertLicenseCheckInterface
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val cMethod = Constants.Method()
    private val EVENTS = Constants.Event().deepLink
    private val transfer by lazy { CFCertTransfer.getInstatnce(this@MainActivity) }
    private val manager by lazy { CFCertManager.getInstatnce(this@MainActivity)}

    private var linksReceiver: BroadcastReceiver? = null
//    iV02ENBpBi6fjwMYvnq6Ig

    private var mAuthNumber: String? = null

    private var uriString: String? = null
    private var uid: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants().BRIDGE).setMethodCallHandler { call, result ->
            Log.e("method", call.method)
            when(call.method) {
                cMethod.TEST -> result.success("Cool")
                cMethod.SET_TOKEN -> {
                    transfer.setToken(call.argument("token")!!)
                    result.success("")
                }
                cMethod.CHECK_LICENSE -> {
                    val isSuccess = transfer.checkLicense(object : CFCertLicenseCheckInterface {
                        override fun onFail(p0: String?, p1: String?) {
                            Log.e("checkLicense onFailed ", p0 + p1)
                            result.success(false)
                        }

                        override fun onLicenseCheck(p0: Boolean, p1: String?, p2: String?) {
                            result.success(true)
                        }
                    })
                    if (!isSuccess) {
                        result.success(isSuccess)
                    }
                }
                cMethod.REQUEST_AUTH_NUMBER -> {
                    val isSuccess = transfer.requestAuthNuber(object : CFCertAuthNumberInterface {
                        override fun onAuthNumber(
                            authNumber: String,
                            code: String,
                            erroMsg: String
                        ) {
                            mAuthNumber = authNumber
                            result.success(hashMapOf(
                                "authNumber" to authNumber,
                                "code" to code,
                                "errMsg" to erroMsg
                            ))
                        }

                        override fun onFail(s: String, s1: String) {
                            Log.e("onAuthNumber onFail  ", s + s1)
                        }
                    })

                    if (!isSuccess) {
                        result.success(hashMapOf(
                            "authNumber" to "",
                            "code" to "",
                            "errMsg" to "Failed to render authNumber"
                        ))
                    }
                }
                cMethod.CERTIFICATE_PASSWORD_CHECK -> {
                    val derBase64 = call.argument("derBase64") as? String
                    val keyBase64 = call.argument("keyBase64") as? String
                    val password =call.argument("password") as? String

                    if (derBase64 != null && keyBase64 != null && password != null) {
                        val pfxBase64 = manager.der2PfxByBase64(derBase64!!, keyBase64!!, password!!,password!!)
                        if (pfxBase64 == null || pfxBase64.isEmpty()) {
                            result.success(hashMapOf(
                                "status" to 0,
                                "pfxBase64" to pfxBase64
                            ))
                        } else {
                            result.success(hashMapOf(
                                "status" to 1,
                                "pfxBase64" to pfxBase64
                            ))
                        }
                    }
                }
                cMethod.GET_CERTIFICATES -> {
                    print("method ${call.method}")
                    val certificates: List<Map<String,String>> = transfer.certifications()
                    Log.e("Certificate", certificates.toString());
                    result.success(certificates)
                }
                cMethod.GET_DEEPLINK_UID -> {
                    print("method ${call.method}")
                    if (uriString != null) {
                        result.success(uid)
                    } else {
                        result.success("")
                    }
                }

                cMethod.REQUEST_IMPORT -> {
                    print("method ${call.method}")
                    if(mAuthNumber != null) {
                        transfer.importCertification(mAuthNumber!!, object : CFCertImportInterface {
                            override fun onFail(s: String, s1: String) {
                                Log.e("ImportCert onFailed", s + s1)
                            }
                            override fun onImport(isSuccess: Boolean, code: String, errorMsg: String) {
                                if (isSuccess) {

                                } else {
                                    Log.e("ImportCert onImport", code + errorMsg)
                                }
                                result.success(isSuccess)
                            }
                        })
                    } else {
                        result.success(false)
                    }

                }

                cMethod.COMPLETE_IMPORT_CERTIFICATION -> {
                    val password = call.argument<String>("password")
                    if (password != null) {
                        when(val rtCode = transfer.completeImportCertification(password!!)) {
                            0 -> {
                                result.success(hashMapOf(
                                    "code" to 0,
                                    "msg" to "성공"
                                ))
                            }
                            -1 -> {
                                result.success(hashMapOf(
                                    "code" to -1,
                                    "msg" to "Password is null"
                                ))
                            }
                            -2 -> {
                                result.success(hashMapOf(
                                    "code" to -2,
                                    "msg" to "pfxbase64 string is null"
                                ))
                            }
                            -3 -> {
                                result.success(hashMapOf(
                                    "code" to -3,
                                    "msg" to "인증서 패스워드가 마지 않음"
                                ))
                            }
                            else -> {
                                result.success(hashMapOf(
                                    "code" to rtCode,
                                    "msg" to "Unknown"
                                ))
                            }
                        }
                    }
                }

                cMethod.DELETE_CERTIFICATION -> {
                    val certName = call.argument<String>("certName")

                    if (certName != null) {
                        when(val rtCode = transfer.deleteCertifications(certName)){
                            0 -> {
                                result.success(hashMapOf(
                                    "code" to 0,
                                    "msg" to "성공"
                                ))
                            }
                            -1 -> {
                                result.success(hashMapOf(
                                    "code" to -1,
                                    "msg" to "Password is null"
                                ))
                            }
                            -2 -> {
                                result.success(hashMapOf(
                                    "code" to -2,
                                    "msg" to "저장된 인증서가 없음"
                                ))
                            }
                            -3 -> {
                                result.success(hashMapOf(
                                    "code" to -3,
                                    "msg" to "지우고자하는 인증서 이름이 저장된 리스트에 없음"
                                ))
                            }
                            -8 -> {
                                result.success(hashMapOf(
                                    "code" to -8,
                                    "msg" to "라이선스 체크 실패"
                                ))
                            }
                            else -> {
                                result.success(hashMapOf(
                                    "code" to rtCode,
                                    "msg" to "Unknown"
                                ))
                            }
                        }
                    } else {
                        result.success(hashMapOf(
                            "code" to 404,
                            "msg" to "No Name"
                        ));
                    }
                }

                else -> {
                    print("method ${call.method}")
                    result.error("${call.method} UNAVAILABLE", "Wrong Method Name", null)
                }
            }
        }

//        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENTS).setStreamHandler(
//            object : EventChannel.StreamHandler {
//                override fun onListen(args: Any?, events: EventChannel.EventSink) {
//                    linksReceiver = createChangeReceiver(events)
//                }
//
//                override fun onCancel(args: Any?) {
//                    linksReceiver = null
//                }
//            }
//        )




    }

//    fun createChangeReceiver(events: EventChannel.EventSink): BroadcastReceiver? {
//        return object : BroadcastReceiver() {
//            override fun onReceive(context: Context, intent: Intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
//                uriString = intent.data?.toString()
//                uid = uriString?.replace("https://open.logfin.com/loan_uid=","")
//                events.success(uid)
//            }
//        }
//    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intent = getIntent()
        uriString = intent.data?.toString()
        uid = uriString?.replace("logfin://open.logfin.kr/loan_uid=","")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action === Intent.ACTION_VIEW) {
            uriString = intent.data?.toString()
            uid = uriString?.replace("logfin://open.logfin.kr/loan_uid=","")
//            linksReceiver?.onReceive(this.applicationContext, intent)
        }
    }

//    iV02ENBpBi6fjwMYvnq6Ig
//    iV02ENBpBi6fjwMYvng6Ig



    
}
