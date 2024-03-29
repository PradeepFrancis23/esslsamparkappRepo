import 'dart:convert';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';




class BeepScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, state,district;
  BeepScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.state,this.district);

  @override
  _BeepSchemeState createState() => _BeepSchemeState(scheme_id,state_id,districtid,number,name,address,state,district);
}


class _BeepSchemeState extends State<BeepScheme> {

  late int scheme_id, state_id, districtid;
  late String number, name, address, state,district,powerText,typeText;
  bool showDimension=false,showMounting=true;

  _BeepSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_no_of_faulty = new TextEditingController();
  TextEditingController txt_nature_of_faulty = new TextEditingController();
  final myController = TextEditingController();
  String ?railway_zone;
  int ?railway_zone_id;
  final List<StateResponse> railway_zone_list = [];

  String ?railway_div;
  int ?railway_div_id;
  final List<StateResponse> railway_div_list = [];

  String ?railway_station;
  int ?railway_station_id;
  final List<StateResponse> railway_station_list = [];

  String ?product_category;
  int ?product_category_id;
  final List<StateResponse> product_category_list = [];

  String ?product;
  int ?product_id;
  final List<StateResponse> product_list = [];

  String ?watt;
  int ?watt_id;
  final List<StateResponse> watt_list = [];

  String ?mounting;
  int ?mounting_id;
  final List<StateResponse> mounting_list = [];


  String ?manufacturer;
  int ?manufacturer_id;
  final List<StateResponse> manufacturer_list = [];

  late String dimension;
  final List<String> dimension_list = [];

  late SharedPreferences _sharedPreferences;
  late ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getDepartmentNameList();
  }

  @override
  void initState() {
    super.initState();

    getLoginDetails();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500), loadingWidget: widget, onDismiss: (){});

  }


    @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: Text("Lodge Complaint ",
              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
        ),

        body: SafeArea(

          child: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Department Name'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: railway_zone == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Please Select Devision', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_zone!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_zone_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text),);
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {
                      print('railway_zone is ${response!.text}');
                      print('railway_zone_id is ${response.id}');  
                      setState(() {
                        railway_zone = response.text;
                        railway_zone_id = response.id;

                        _getBuildingNameList(railway_zone_id!);

                      },
                    );
                    },
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Building Name'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  ),),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: railway_div == null ?
                    Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Please Select Building', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_div!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_div_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {
                      print('railway_div is ${response!.text}');
                      print('railway_div_id is ${response.id}');         
                      setState(() {
                        railway_div = response.text;
                        railway_div_id = response.id;
                        _getEquipmentsCategoryList(railway_zone_id!, railway_div_id!);

                         
                      },
                    );
                    },
                  ),
                ),
              ),




              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[

                        TextSpan(text: 'Equipments Category'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                    
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: railway_station == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Equipments Category', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_station!, style: TextStyle(color: Colors.black)),),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_station_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {

                      print('product category id is ${response!.id}');
                      print('product category  is ${response.text}');

                      setState(() {
                        railway_station = response.text;
                       // railway_station_id = response.id;
                        product_category_id=response.id;
                        showDimension=response.text=="LED INDOOR LIGHTS"?true:false;
                        showMounting=response.text=="Energy Efficient Fans "?false:true;
                        powerText=response.text;

                          _getEquipmentNamesList(product_category_id!);

                          // if (response.text=="Energy Efficient Ac's") {

                          //   widget.powerText=response.text;
                            
                          // } else {


                          // }

                        // _getRailwayProductItemList(railway_zone_id, railway_div_id, railway_station_id, railway_station_id);

                      },
                      );
                    },
                  ),
                ),
              ),


              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Equipment Name'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: product_category == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Equipment', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(product_category!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: product_category_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {

                      
                      print('the product id is ${response!.id}');
                      print('the equipment name is ${response.text}');
                      
                      setState(() {
                        product_category = response.text;
                        product_id = response.id;

                        //if the equipment category is LED Indoor lights then show the  dimensions

                        showDimension=railway_station=="LED INDOOR LIGHTS"?response.text.contains('Bulb')?false:true:false;



                        // _getRailwayProductItemList(railway_zone_id, railway_div_id, railway_station_id, product_category_id);

                         _getProductWattList(product_id!);
                        _getProductMountingList(product_id!);

                        _getManufacturerList(railway_zone_id!, railway_div_id!, railway_station_id!, product_category_id!, product_id!);

                        if(response.text == "Tube Light") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } else if(response.text == "Tube lights T5") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } else if(response.text == "Down Lighter") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("4\" Dia Lighter");
                          dimension_list.add("6\" Dia Lighter");
                          dimension_list.add("8\" Dia Lighter");
                        } 

                        else if(response.text == "Led Half Tube Light") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } 

                          else if(response.text == "Led Tube Light T8") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } 
                          else if(response.text == "Led Tube lights T5") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } 

                        else if(response.text == "Led Panel Light") {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("1X1 Panel");
                          dimension_list.add("2X2 Panel");
                          dimension_list.add("1X4 Panel");
                        } else {
                          dimension_list.clear();
                          dimension = null.toString();
                          dimension_list.add("NA");

                        }
                        
                         },
                      );
                    },
                  ),
                ),
              ),


              // Padding(padding: EdgeInsets.only(left: 15,top: 10),
              //     child: RichText(
              //       text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
              //         children: <TextSpan>[
              //           TextSpan(text: 'Product '),
              //           TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
              //         ],
              //       ),
              //     )),

              // Container(
              //   height: 40,
              //   margin: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
              //       borderRadius: BorderRadius.circular(5.0),
              //       border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

              //   child: ButtonTheme(
              //     alignedDropdown: true,
              //     child: DropdownButton(
              //       underline: SizedBox(),
              //       hint: product == null ?
              //       Padding(
              //           padding: EdgeInsets.only(left: 5, right: 10),
              //           child: Text('Select Product ', style: TextStyle(color: Colors.grey, fontSize: 17)))
              //           : Padding(
              //           padding: EdgeInsets.only(left: 5, right: 10),
              //           child: Text(product, style: TextStyle(color: Colors.black))),

              //       isExpanded: true,
              //       iconSize: 30.0,
              //       style: TextStyle(color: Colors.black),

              //       items: product_list.map((
              //           StateResponse response) {
              //         return DropdownMenuItem<StateResponse>(
              //             value: response,
              //             child: Text(response.text));
              //       },
              //       ).toList(),

              //       onChanged: (StateResponse response) {
              //         setState(() {
              //           product = response.text;
              //           product_id = response.id;

              //           _getProductWattList(product_id);
              //           _getProductMountingList(product_id);

              //           _getManufacturerList(railway_zone_id, railway_div_id, railway_station_id, product_category_id, product_id);

                        // if(product == "Tube Light") {
                        //   dimension_list.clear();
                        //   dimension = null;
                        //   dimension_list.add("2feet");
                        //   dimension_list.add("4feet");
                        // } else if(product == "Led Panel Light") {
                        //   dimension_list.clear();
                        //   dimension = null;
                        //   dimension_list.add("1X1 Panel");
                        //   dimension_list.add("2X2 Panel");
                        //   dimension_list.add("1X4 Panel");
                        // } else {
                        //   dimension_list.clear();
                        //   dimension = null;
                        //   dimension_list.add("NA");

                        // }
              //         },
              //         );
              //       },
              //     ),
              //   ),
              // ),

            if (showDimension)  
              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Dimension '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

                   
            if (showDimension)  
              Container(
                
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: dimension == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Dimension ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(dimension, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: dimension_list.map((
                        String response) {
                      return DropdownMenuItem<String>(
                          value: response,
                          child: Text(response));
                    },
                    ).toList(),

                    onChanged: (String? response) {
                      setState(() {
                        dimension = response!;
                      },
                      );
                    },
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                         
                        TextSpan(text:powerText=="Energy Efficient Ac's "?'Ton':'Watt'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: watt == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(powerText=="Energy Efficient Ac's "?'Ton':'Watt', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(watt!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: watt_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {
                      setState(() {
                        watt = response!.text;
                        watt_id = response.id;
                      },
                      );
                    },
                  ),
                ),
              ),
              if (showMounting)  
              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text:powerText=="Energy Efficient Ac's "?'Type':'Mounting'),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),
     
              if (showMounting)  
              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: mounting == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(powerText=="Energy Efficient Ac's "?'Select Type':'Select Mounting', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(mounting!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: mounting_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {
                      setState(() {
                        mounting = response!.text;
                        mounting_id = response.id;
                      },
                      );
                    },
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'No. of Faulty Items  '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(controller: txt_no_of_faulty,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                          hintText: '0  ', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              // Padding(padding: EdgeInsets.only(left: 15,top: 10),
              //     child: RichText(
              //       text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
              //         children: <TextSpan>[
              //           TextSpan(text: 'Nature Of Faulty '),
              //           TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
              //         ],
              //       ),
              //     )),

              // Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              //     child: TextFormField(
              //         controller: txt_nature_of_faulty,
              //         inputFormatters: <TextInputFormatter>[
              //           FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
              //         ],
              //         decoration: InputDecoration(
              //             hintText: 'Nature Of Faulty ', counter: Container(),
              //             contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              //             filled: true,
              //             hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
              //             border: InputBorder.none,
              //             fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
              //         style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Manufacturer '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: manufacturer == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Manufacturer ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(manufacturer!, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: manufacturer_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text),
                          );
                    },
                    ).toList(),

                    onChanged: (StateResponse? response) {
                      setState(() {
                        manufacturer = response!.text;
                        manufacturer_id = response.id;
                      },
                    );
                    },
                  ),
                ),
              ),

 
              SizedBox(height: 10),


              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Remark'),
                      ],
                    ),
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_remark, inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                      maxLines: 5,
                      minLines: 3,
                      decoration: InputDecoration(
                          hintText: 'Remark ',
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black),),),

              SizedBox(height: 20.0),

              Center(
                child: ElevatedButton(
                  child: Text('REGISTER', style : TextStyle(color: Colors.white,
                      fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                  onPressed: () {
              
                    print('the no of faulty items are ${txt_no_of_faulty.text}');
                    print('the no of faulty items are ${myController}');
              
                    if(railway_zone_id == null) {
                      Fluttertoast.showToast(msg: "Please select Department Name");
                    } else if(railway_div_id == null) {
                      Fluttertoast.showToast(msg: "Please select Building Name");
                    } else if(product_category_id == null) {
                      Fluttertoast.showToast(msg: "Please select Equipments Category");
                    }                    
                    else if(product_id == null) {
                      Fluttertoast.showToast(msg: "Please select Equipment Name");
                    } else if(product_id == null) {
                      Fluttertoast.showToast(msg: "Please select product");
                    }
                    else if(watt_id == null) {
                       if (powerText=="Energy Efficient Ac's ") {
                        Fluttertoast.showToast(msg: "Please select Ton");                      
                       } else {
                       Fluttertoast.showToast(msg: "Please select Watt");
                       }
                    }                   
                    //  else if(mounting_id == null) {                
                    //   powerText=="Energy Efficient Ac's "?Fluttertoast.showToast(msg: "Please select Type"):showMounting==true? Fluttertoast.showToast(msg: "Please select Mounting"):" ";

                    //   // if(showMounting){
                    //   //     Fluttertoast.showToast(msg: "Please select Mounting");
                    //   // }else{
                    //   //   return;
                    //   // }
                    // } 
                     
                     else if(txt_no_of_faulty.text.isEmpty) {
                      print(txt_no_of_faulty);
                      Fluttertoast.showToast(msg: "Please fill no of Faulty Items");
                    }
                    
                    else if(manufacturer_id == null) {
                      Fluttertoast.showToast(msg: "Please select Manufacturer");
                    } else {

                      AppConfig.getUserLocation(context).then((currentPostion) {
                        if (currentPostion != null) {
                          String lat = "${currentPostion.latitude}";
                          String long = "${currentPostion.longitude}";
                          _registerComplaint(lat,long);

                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: Text('Grant Location Permission'),
                                content: Text(
                                    'This app needs location permission to register complaints'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('Deny'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('Settings'),
                                    onPressed: () => openAppSettings(),
                                  ),
                                ],
                              ));

                          // Fluttertoast.showToast(msg: "Please give location permission to lodge compliant");
                        }
                    
                      });
                    }

                  },
 
                  style: ElevatedButton.styleFrom(
                      primary: Color(AppConfig.BLUE_COLOR[0]),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
            
              ),

              SizedBox(height: 10)
              ,
            ],
          ),
        )
    );
  }



  _getDepartmentNameList() async {

    print('district id is $districtid');
    print('${AppConfig.GET_BEEP_DIVISION_LIST}$state_id&ZoneId=$districtid');

    _progressDialog.show();

    print('get department name list${AppConfig.GET_BEEP_DIVISION_LIST}$state_id&ZoneId=$districtid ');

    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_DIVISION_LIST}$state_id&ZoneId=$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      railway_zone_list.clear();
      var jsonData = json.decode(response.body);
      print(jsonData);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_zone_list.add(new StateResponse.fromJson(model));
      }
    });
  }
  
  _getBuildingNameList(int id) async {
    _progressDialog.show();

    print('get building list ${AppConfig.GET_BEEP_STATION_LIST}$state_id&ZoneId=$districtid&DivisionId=$id');
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_STATION_LIST}$state_id&ZoneId=$districtid&DivisionId=$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    
    print(response.body);
    
    _progressDialog.dismiss();
    setState(() {

      railway_div_list.clear();
      railway_div_id = null;
      railway_div = null;

      railway_station_list.clear();
      railway_station = null;
      railway_station_id = null;

      product_category_list.clear();
      product_category = null;
      product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_div_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getEquipmentsCategoryList(int zone_id,int div_id) async {

    print("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_LIST}$districtid&Stateid=$state_id&DevisionId=$zone_id&StationId=$div_id");
     
    String url='${AppConfig.GET_BEEP_PRODUCT_CATEGORY_LIST}$districtid&Stateid=$state_id&DevisionId=$zone_id&StationId=$div_id';
  
    print(url);
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {
      railway_station_list.clear();
      railway_station = null;
      railway_station_id = null;

      product_category_list.clear();
      product_category = null;
      product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_station_list.add(new StateResponse.fromJson(model));
      }
    });
  }


  _getEquipmentNamesList(int productcategoryid) async {

    _progressDialog.show();
    print("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST}$state_id&ZoneId=$railway_zone_id&DevisionId=$railway_div_id&StationId=$railway_div_id&ProductCategoryId=$productcategoryid");

    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST}$state_id&ZoneId=$railway_zone_id&DevisionId=$railway_div_id&StationId=$railway_div_id&ProductCategoryId=$productcategoryid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      product_category_list.clear();
      product_category = null;
   //   product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        product_category_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayProductItemList(int id,int division_id,int station_id,int productcategoryid) async {


    print("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST}"
        "$state_id&ZoneId=$id&DevisionId=$division_id&StationId=$station_id&ProductCategoryId=$productcategoryid");


    _progressDialog.show();
    
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST}"
        "$state_id&ZoneId=$id&DevisionId=$division_id&StationId=$station_id&ProductCategoryId=$productcategoryid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        product_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getProductWattList(int id) async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_WATT_LIST}$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        watt_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getProductMountingList(int id) async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_MOUNTING_LIST}$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        mounting_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getManufacturerList(int id,int division_id,int station_id,int productcategoryid,int product_id) async {
 
  print('the maufacturer is ${AppConfig.GET_PRODUCT_MANUFACTURER_LIST}$state_id&ZoneId=$id&DevisionId=$division_id&RailwayStationId=$railway_div_id&ProductCategoryId=$productcategoryid&ProductId=$product_id');
  // print('link is ${AppConfig.GET_PRODUCT_MANUFACTURER_LIST}$state_id&ZoneId=$id&DevisionId=$division_id&RailwayStationId=$railway_div_id&ProductCategoryId=$productcategoryid&ProductId=$product_id');


    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_MANUFACTURER_LIST}$state_id&ZoneId=$id&DevisionId=$division_id&RailwayStationId=$railway_div_id&ProductCategoryId=$productcategoryid&ProductId=$product_id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        manufacturer_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _registerComplaint(String lat, String long) async {
    print('registering complaint');
    _progressDialog.show();

    print('${AppConfig.CONSUMER_ENTRY}');
    String? token = _sharedPreferences.getString(AppConfig.TOKEN);
    print('$railway_zone_id,$railway_div_id,$railway_station_id,$product_id,$product_category_id,$watt_id,$mounting_id,$manufacturer_id,$dimension');

    var response = await http.Client().post(Uri.parse(AppConfig.CONSUMER_ENTRY),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},
        body: {
          "LanguageId": "1" ,
          "CallerNumber":number,
          "CallerName":name,
          "Address": address,
          "Landmark": "",
          "StateId":state_id.toString(),
          "DistrictId":districtid.toString(),
          "SchemeId":scheme_id.toString(),
          "hdn_scheme_Text": "BEEP- Railway",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":"",
          "Remark":txt_remark.text,
          "Longitude":lat,
          "Latitude": long,       
          "Beep_ZoneId":"$railway_zone_id",
          "Beep_DevisionId":"$railway_div_id",
          "Beep_Devision_Other":"",
          "Beep_StationId":"$railway_div_id",
          "Beep_Station_Other":"",
          "Beep_ProductCategoryId":"$product_category_id",
          "Beep_ProductId":"$product_id",
          "Beep_WattTonsId":"$watt_id",
          "Beep_MountingId":"$mounting_id",
          "Beep_NoOfFaultyItem":txt_no_of_faulty.text,
          "Beep_ManufaturerId":"$manufacturer_id",
          "Beep_NatureOfFaulty":txt_nature_of_faulty.text,
          "Beep_Dimension_Led":"0",
          "Beep_Dimension_Down":"0",
          "Beep_Dimension_Tube": ""
    });

    _progressDialog.dismiss();

    print(response.body);
    var jsonData = json.decode(response.body);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }

}