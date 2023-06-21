import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tech_blog/model/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa', ''), // farsi
      ],
      theme: ThemeData(
          fontFamily: 'Dana',
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: 'Dana',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),

        headline2: TextStyle(
          fontFamily: 'Dana',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: Colors.white
        ),

        bodyText1: TextStyle(
          fontFamily: 'Dana',
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        headline3: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.red
        ),
        headline4: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.green
        ),
      )),
      debugShowCheckedModeBanner: false,
      home:Home(),
    );
  }
}




class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext context) async{
   var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

  var value = await http.get(Uri.parse(url));
  developer.log(value.body,name: "main");
  developer.log("getResponse",name: "wlifeCycle");

if(currency.isEmpty){
  if(value.statusCode==200){
    List jsonList = convert.jsonDecode(value.body);
    _SnackBar(context, "به روز رسانی اطلاعات با موفقیت انجام شد");

    if (jsonList.length>0){
      for(int i=0;i<jsonList.length;i++){


        setState(() {
          currency.add(Currency(
              id: jsonList[i]["id"],
              title: jsonList[i]["title"],
              price: jsonList[i]["price"],
              changes: jsonList[i]["changes"],
              status: jsonList[i]["status"]));
        });
      }

    }
  }
}
return value;


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    getResponse(context);


    return Scaffold(
     backgroundColor: Color.fromARGB(255, 243, 243, 243),
     appBar: AppBar(
       elevation: 0,
         backgroundColor: Colors.white, actions: [
       SizedBox(
         width: 16,
       ),
       Align(
           alignment: Alignment.centerRight,
           child: Image.asset(
             "assets/images/icon.png",
           )),
       Align(
           alignment: Alignment.centerRight,
           child: Text(" قیمت به روز ارز و سکه",
             style: Theme.of(context).textTheme.headline1,)),
       Expanded(child: SizedBox()),
       Image.asset("assets/images/menu.png"),
     ]),
     body: SingleChildScrollView(
       child: Padding(
           padding: EdgeInsets.all(28),
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Image.asset("assets/images/q.png"),
                   SizedBox(
                     width: 8,
                   ),
                   Text("نرخ ارز آزاد چیست؟",
                   style: Theme.of(context).textTheme.headline1,),
                 ],
               ),
               SizedBox(height: 12,),
               Text(
                 "نوع ارزها در معاملات نقدی و رایج روزانه است. معاملاتی نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                 style: Theme.of(context).textTheme.bodyText1,
                 textDirection: TextDirection.rtl,
               ),

               Padding(
                 padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                 child: Container(
                   height: 35,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     color: Color.fromARGB(255, 130, 130, 130),
                     borderRadius: BorderRadius.all(Radius.circular(1000),),
                   ),
                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                     Text("نام ارز آزاد",style: Theme.of(context).textTheme.headline2,),
                     Text("قیمت",style: Theme.of(context).textTheme.headline2,),
                     Text("تغییر",style: Theme.of(context).textTheme.headline2,),
                   ]),
                 ),
               ),

               Container(
                 width: double.infinity,
                 height: 350,
                 child: FutureBuilder(
                   builder: (context, snapshot) {
                     return snapshot.hasData ?
                     ListView.separated(
                       itemCount: currency.length,
                       physics: BouncingScrollPhysics(),
                       itemBuilder: (BuildContext context, int position){
                         return Padding(
                           padding:  EdgeInsets.fromLTRB(0, 8, 0, 8),
                           child:MyItem(position,currency),
                         );
                       },
                       separatorBuilder: (BuildContext context,int index){
                         if(index%9==0) {
                           return Padding(
                             padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                             child: Add(),
                           );
                         } else{
                           return SizedBox.shrink();
                         }

                       },) :
                         Center(child: CircularProgressIndicator(),);
                   },
                   future: getResponse(context),
                 ),
               ),


               Padding(
                 padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                 child: Container(
                   width: double.infinity,
                   height: 50,
                   decoration: BoxDecoration(
                     color: Color.fromARGB(255, 232, 232, 232),
                     borderRadius: BorderRadius.circular(1000),
                   ),
                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       SizedBox(height: 50,
                         child: TextButton.icon(
                             onPressed: ()=>_SnackBar(context, "به روز رسانی با موفقیت انجام شد"),
                             icon: Icon(CupertinoIcons.refresh_bold,color: Colors.black),
                             label: Padding(
                               padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                               child: Text("به روز رسانی",style: Theme.of(context).textTheme.headline1,),
                             ),
                         style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 202, 193, 255)),
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>
                             (RoundedRectangleBorder(borderRadius:BorderRadius.circular(1000) )),
                         ),),
                       ),
                       Text("آخرین به روز رسانی ${_getTime()}"),
                       SizedBox(width: 8,)

                     ],
                   ),
                 ),
               )
             ],
           )),
     ),
   );
  }

 String _getTime() {
    return "20.45";
  }
}




void _SnackBar(BuildContext context,String msg){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg,style: Theme.of(context).textTheme.headline1,),
        backgroundColor: Colors.green,));
}





class MyItem extends StatelessWidget{
  int position;
  List<Currency> currency;
  MyItem(this.position,this.currency );

  @override
  Widget build(BuildContext context) {

   return Container(
     width: double.infinity,
     height: 50,
     decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(1000),
         boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey,blurRadius: 1)]
     ),
     child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
         Text(currency[position].title!,style: Theme.of(context).textTheme.bodyText1,),
         Text(currency[position].price!,style: Theme.of(context).textTheme.bodyText1,),
         Text(currency[position].changes!,
           style: currency[position].status! == "n" ?
           Theme.of(context).textTheme.headline3 :
           Theme.of(context).textTheme.headline4),
       ],
     ),
   );
  }

}





class Add extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey,blurRadius: 1)]
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("تبلیغات",style: Theme.of(context).textTheme.headline2,),
        ],
      ),
    );
  }

}
