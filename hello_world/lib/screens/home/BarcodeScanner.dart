import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>{
  String _barcodeScanRes = "lol";

  Future _someFunction() async {

    _barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.BARCODE);

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Barcode Scanner"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
          child:Center(
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    setState(() {
                      _someFunction();
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Scan your Barcode".toUpperCase(),
                      style: TextStyle(fontSize: 30)),
                ),
                Text(
                    _barcodeScanRes
                )
              ],
            ),
          )
      ),
    );
  }
}