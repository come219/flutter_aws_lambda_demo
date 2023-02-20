import 'package:flutter/material.dart';
import 'package:flutter_aws_lambda/screen_ScanQR.dart';
//import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';



class checkedIn_Screen extends StatefulWidget {
  checkedIn_Screen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckedInState();


}

class CheckedInState extends State<checkedIn_Screen> {

  @override
  void initState() {
   // Intl.defaultLocale = 'pt_BR';
    super.initState();
  }


  var checkedInTime;
  var currentTime;
  String timeElapsed = "";
  //var format = DateFormat.yMd('th');



  void checkIn( ) {
    //checkedInTime = format.format(DateTime.now());
    checkedInTime = "00:00:00";
    print("the checked in time is: " + checkedInTime.toString());

  }

  String s_timer( String checkedInTime) {

    String s_timetext = "";

    // init time now
    //currentTime = format.format(DateTime.now());
    checkedInTime = "00:00:00";
    print("the current time is: " + currentTime.toString());












    return s_timetext;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
        child: Column(children: [

          Container(width: 400, height: 300, ),
          Text("Checked-in!", style: TextStyle(fontWeight: FontWeight.bold),),
          Text("abdefghijklmnopqrz"),

          Text("10:00"),



          Text("Time you have been checked-in"),


          ElevatedButton.icon(onPressed: () {},
              icon: Icon(Icons.assignment_returned_outlined),
              label: Text("Check out")),



        ],),
      ),
    );
  }





}




class addPet_Screen extends StatefulWidget {
  addPet_Screen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => PetScreenState();

}

class PetScreenState extends State<addPet_Screen> {


  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Column(children: [


        ElevatedButton.icon(onPressed: () {},
            icon: Icon(Icons.reset_tv_outlined),
            label: Text("Return")),



        ElevatedButton.icon(onPressed: () {},
            icon: Icon(Icons.lock_reset_rounded),
            label: Text("Retake picture")),


        ElevatedButton.icon(onPressed: () {},
            icon: Icon(Icons.picture_as_pdf_sharp),
            label: Text("picture")),

        Text("Adding pet"),
        Text("QR code data: null"),

        ElevatedButton.icon(
            onPressed: () {}, icon: Icon(Icons.add), label: Text("add pet")),


        ElevatedButton.icon(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_context) => checkedIn_Screen()),
              );

            }, icon: Icon(Icons.add), label: Text("Confirm")),


      ],),
      ),
    );
  }


}


MobileScannerController cameraController = MobileScannerController();


class scanQR_Screen extends StatefulWidget {
  scanQR_Screen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => scanQRState();

}

class scanQRState extends State<scanQR_Screen> {



  @override
  initState() {
    initQRCode();
    super.initState();
  }

  void initQRCode() {

    cameraController = MobileScannerController( facing: CameraFacing.back, torchEnabled: false, );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: Container( child: Column(  mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

        mobileScanner(context),
        qrScannerActions(),

      ],),


      ),
    );

  }


}


Widget qrScannerActions() {
  return Container( color: Colors.black87,
    child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [



    IconButton(
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: cameraController.torchState,
        builder: (context, state, child) {
          switch (state as TorchState) {
            case TorchState.off:
              return const Icon(Icons.flash_off, color: Colors.grey);
            case TorchState.on:
              return const Icon(Icons.flash_on, color: Colors.yellow);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => cameraController.toggleTorch(),
    ),



    IconButton(
      color: Colors.white,
      icon: ValueListenableBuilder(
        valueListenable: cameraController.cameraFacingState,
        builder: (context, state, child) {
          switch (state as CameraFacing) {
            case CameraFacing.front:
              return const Icon(Icons.camera_front);
            case CameraFacing.back:
              return const Icon(Icons.camera_rear);
          }
        },
      ),
      iconSize: 32.0,
      onPressed: () => cameraController.switchCamera(),
    ),


  ],
  ),

    
    
  );
}



Widget mobileScanner(BuildContext _context) {
  return Container( width: 400, height: 400,
    child: MobileScanner(
        controller: cameraController,

            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                debugPrint('Barcode found! $code');



                  Navigator.push(
                    _context,
                    MaterialPageRoute(builder: (_context) => addPet_Screen()),
                );

              }
            }),

  );
}

