
class SchemeStatusListGS {
  late int srNo;
  late int id;
  late int mobileUserId;
  late int schemeId;
  late int stateId;
  late int districtId;
  late int b2BCodeId;
  late String mobileNo;
  late String loginPin;
  late int isFirstTimeLogin;
  late String name;
  late String clientName;
  late String address;
  late String email;
  late  String landMark;
  late String deviceId;
  late String deviceType;
  late String createDate;
  late bool isActive;
  late String let;
  late String longi;
  late bool isB2BUser;
  late bool isValidB2BUser;
  late int b2BUserApprovedById;
  late String date;
  late String schemeName;
  late String stateName;
  late String districtName;
  late String uniqueCode;
  late int isValidUser;

  SchemeStatusListGS(
      {required this.srNo,
        required this.id,
        required this.mobileUserId,
        required this.schemeId,
        required this.stateId,
        required this.districtId,
        required this.b2BCodeId,
        required this.mobileNo,
        required this.loginPin,
        required this.isFirstTimeLogin,
        required this.name,
        required this.address,
        required this.email,
        required this.landMark,
        required this.deviceId,
        required this.deviceType,
        required this.createDate,
        required this.isActive,
        required this.let,
        required this.longi,
        required this.isB2BUser,
        required this.isValidB2BUser,
        required this.b2BUserApprovedById,
        required this.date,
        required this.schemeName,
        required this.stateName,
        required this.districtName,
        required this.uniqueCode,
        required this.clientName,
        required this.isValidUser});

  SchemeStatusListGS.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    id = json['id'];
    mobileUserId = json['mobileUserId'];
    schemeId = json['schemeId'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    b2BCodeId = json['b2BCodeId'];
    mobileNo = json['mobileNo'];
    loginPin = json['loginPin'];
    isFirstTimeLogin = json['isFirstTimeLogin'];
    name = json['name'];
    address = json['address'];
    email = json['email'];
    landMark = json['landMark'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    createDate = json['createDate'];
    isActive = json['isActive'];
    let = json['let'];
    longi = json['longi'];
    isB2BUser = json['isB2BUser'];
    isValidB2BUser = json['isValidB2BUser'];
    b2BUserApprovedById = json['b2BUserApprovedById'];
    date = json['date'];
    schemeName = json['schemeName'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    uniqueCode = json['uniqueCode'];
    clientName = json['clientName'];
    isValidUser = json['isValidUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['id'] = this.id;
    data['mobileUserId'] = this.mobileUserId;
    data['schemeId'] = this.schemeId;
    data['stateId'] = this.stateId;
    data['districtId'] = this.districtId;
    data['b2BCodeId'] = this.b2BCodeId;
    data['mobileNo'] = this.mobileNo;
    data['loginPin'] = this.loginPin;
    data['isFirstTimeLogin'] = this.isFirstTimeLogin;
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['landMark'] = this.landMark;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['createDate'] = this.createDate;
    data['isActive'] = this.isActive;
    data['let'] = this.let;
    data['longi'] = this.longi;
    data['isB2BUser'] = this.isB2BUser;
    data['isValidB2BUser'] = this.isValidB2BUser;
    data['b2BUserApprovedById'] = this.b2BUserApprovedById;
    data['date'] = this.date;
    data['schemeName'] = this.schemeName;
    data['stateName'] = this.stateName;
    data['districtName'] = this.districtName;
    data['uniqueCode'] = this.uniqueCode;
    data['clientName'] = this.clientName;
    data['isValidUser'] = this.isValidUser;
    return data;
  }
}