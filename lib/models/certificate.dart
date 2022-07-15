class Certificate {
  final String certName;
  final String derBase64;
  final String expireTime;
  final String keyBase64;
  final String policyId;
  final String serialNumber;

  Certificate(
      {required this.certName,
      required this.derBase64,
      required this.expireTime,
      required this.keyBase64,
      required this.policyId,
      required this.serialNumber});
  void getValue() {
    print("certName : $certName");
    print("derBase64 : $derBase64");
    print("expireTime : $expireTime");
    print("keyBase64 : $keyBase64");
    print("policyId : $policyId");
    print("serialNumber $serialNumber");
  }
}
