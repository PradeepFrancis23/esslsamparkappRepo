
import 'dart:convert';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/complaint_status/compalint_status_result.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/compaint_status_list.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ComplainStatusList extends StatefulWidget {
  @override
  _ComplainStatusListState createState() => _ComplainStatusListState();
}


class _ComplainStatusListState extends State<ComplainStatusList> with WidgetsBindingObserver{

  TextEditingController txt_complain = new TextEditingController(text: "");

  late SharedPreferences _sharedPreferences;
 late  ArsProgressDialog _progressDialog;

  String complaintID ="", callerNumber="", callerName="", schemeName="", callStatus="";
  final List<ComplaintStatusListResponse> status_list = [];

  late CountdownTimer _countdownTimer;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getTopComplaints();
  }

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addObserver(this);
    getLoginDetails();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500), onDismiss: (){}, loadingWidget: widget);

  }

    @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {


            print('Applifecycle state is $state');

        if (state==AppLifecycleState.paused) {


        //user has paused the application

        _countdownTimer=CountdownTimer(Duration(minutes: 30), Duration(seconds: 1));

        print(_countdownTimer.elapsed);

        } else if (state==AppLifecycleState.resumed) {


          //user has started using the app


          if (_countdownTimer.remaining>Duration(seconds: 0)) {

            print('app life cycle timer is not completed');

            //let the user start using the app

            
          } else {

            print('lifecycle state timedout');
            //log user out

             Fluttertoast.showToast(msg: 'Sorry but you have been logged out due to inactivity...');

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginAsPage()));

          }


          _countdownTimer.cancel();





        }else{

          print('the app lifecycle state of app is different than paused or resume');

          print('${AppLifecycleState}');




        }
 



 
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: Text("Complaint Status",
              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
        ),

        body: SafeArea(

          child: Container(
            color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[

                 SizedBox(height: 15),

                Row(
                  children: [

                    Expanded(
                        flex: 8,
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                            child: TextFormField(
                                controller: txt_complain,
                                textCapitalization: TextCapitalization.characters,
                                maxLength: 12,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z #-_]")),
                                ],
                                decoration: InputDecoration(
                                  enabledBorder:  OutlineInputBorder(
                                    borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                                      borderRadius: BorderRadius.circular(5.0)),
                                    hintText: 'Search', counter: Container(),
                                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
                                    filled: true,
                                    hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                    fillColor: Colors.white,
                                   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                                ),
                                style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)))),

                    Expanded(
                      flex: 2,
                        child:  Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 10),
                          child: Container(
                            height: 45,
                            child: ElevatedButton(

                              child: Icon(Icons.search,size: 28,),
                              onPressed: () {

                                if(txt_complain.text.length >= 10) {
                                  _getAllData();
                                } else {
                                  Fluttertoast.showToast(msg: "Please enter valid Complain ID or Mobile Number");
                                }
                              }, style: ElevatedButton.styleFrom(
                                primary: Color(AppConfig.BLUE_COLOR[0]))
                            ),
                          ),
                        ),)



                  ],
                ),

                 SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Your Complaints ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black))),

                Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: status_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.only(left:5,right: 5, bottom: 10,top: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                color:Colors.white),

                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplainStatus(status_list[index].complaintID)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                   children: [

                                     Expanded(
                                       flex: 8,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             SizedBox(height: 5),

                                             Padding(
                                                 padding: const EdgeInsets.all(4.0),
                                                 child: Text("Complaint Date : ${status_list[index].compDate}",
                                                     style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),
                                                         fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),


                                             Padding(
                                                 padding: const EdgeInsets.all(4.0),
                                                 child: Text("Complaint ID : ${status_list[index].complaintID}",
                                                     style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),
                                                         fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),


                                             Row(
                                               children: [

                                                 Padding(
                                                     padding: const EdgeInsets.all(4.0),
                                                     child: Text("Complaint Status : ",
                                                         style: TextStyle(
                                                             color: Color(AppConfig.BLUE_COLOR[1]),
                                                             fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),

                                                 status_list[index].callStatus.toLowerCase() == "open" ? Padding(
                                                     padding: const EdgeInsets.all(4.0),
                                                     child: Text(status_list[index].callStatus,
                                                         style: TextStyle(color: Colors.red,backgroundColor: Colors.red[100],
                                                             fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14)))


                                                 : status_list[index].callStatus.toLowerCase() == "escalated" ?

                                                 Padding(
                                                     padding: const EdgeInsets.all(4.0),
                                                     child: Text(status_list[index].callStatus,
                                                         style: TextStyle(color: Colors.red,backgroundColor: Colors.red[100],
                                                             fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                 ) :

                                                 status_list[index].callStatus.toLowerCase() == "rectified" ?

                                                 Padding(
                                                     padding: const EdgeInsets.all(4.0),
                                                     child: Text(status_list[index].callStatus,
                                                         style: TextStyle(color: Colors.orange,backgroundColor: Colors.orange[100],
                                                             fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                 ) :

                                                 Padding(
                                                     padding: const EdgeInsets.all(4.0),
                                                     child: Text(status_list[index].callStatus,
                                                         style: TextStyle(color: Colors.green,backgroundColor: Colors.green[100],
                                                             fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                 ),

                                               ],
                                             ),

                                             SizedBox(height: 5),


                                       ],
                                     )),

                                     Expanded(
                                       flex: 2,
                                         child: Container(
                                           height: 50,
                                           decoration: BoxDecoration(
                                             color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                                             shape: BoxShape.circle,),
                                           child: IconButton(icon: Icon(Icons.arrow_forward_ios,size: 23,
                                           color: Color(AppConfig.BLUE_COLOR[1])), 
                                          //  added onpressed 
                                           onPressed: () {  },),
                                         ))

                                   ],
                                ),
                              ),
                            ));
                      },

                ))




              ],
            ),
          ),
        )
    );
  }

  _getTopComplaints() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_TOP_COMPLAINT_STATUS+_sharedPreferences.getString(AppConfig.MOBILE_NUMBER).toString()),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      var jsonData = json.decode(response.body);
      print(jsonData);
      var responseObjlist = jsonData["responseObj"] as List;

      for (var model in responseObjlist) {
        status_list.add(new ComplaintStatusListResponse.fromJson(model));
      }
    });
  }

  _getAllData() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_COMPLAINT_STATUS+txt_complain.text),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    var jsonData = json.decode(response.body);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplainStatus(txt_complain.text)));
    } else {
      Fluttertoast.showToast(msg: "Please Enter Valid Complaint ID or Mobile Number ");
    }
  }
}


