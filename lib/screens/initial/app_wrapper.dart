import 'package:flutter/material.dart';

import '../../../utilities/api_manager.dart';
import '../../../utilities/bridge_manager.dart';
import '../../../utilities/common.dart';
import '../../utilities/store.dart';
import 'application.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    iniAPI();
    super.initState();
  }

  iniAPI() {
    if (mounted) setState(() => {});
    initialSetup().then((res) => {if (mounted) {}});
  }

  // ======== 기본 설정 ===========
  Future initialSetup() async {
    await getUID();
    await sdkSetup();
    await getCustomer();
  }

  Future getUID() async {
    var result = await BridgeManager.getDeepLink();
    if (result.isEmpty) {
      Store.uid = CommonConstants.uid;
      // setState(() {
      //   uid = CommonConstants.uid;
      // });
    } else {
      Store.uid = result;
      // setState(() {
      //   uid = result;
      // });
    }
  }

  Future sdkSetup() async {
    try {
      Store.token = await ApiManager.getToken(
          CommonConstants.CLIENT_ID, CommonConstants.SECERET_KEY);
      await BridgeManager.setToken();
      await BridgeManager.checkLicense();
      setState(() {
        isError = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  Future getCustomer() async {
    var result = await ApiManager.getCustomerInfo();
    if (result != null) {
      setState(() {
        isError = false;
      });
      Store.customer = result;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ApplicationPage()));
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            isLoading ? const CircularProgressIndicator() : _customerResult(),
      ),
    );
  }

  Widget _customerResult() {
    if (isError) {
      return Container(
        child: const Center(child: Text("고객정보를 찾을 수 없습니다")),
      );
    } else {
      return Container();
    }
  }
}
