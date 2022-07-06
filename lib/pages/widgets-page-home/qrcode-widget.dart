import 'package:flutter/material.dart';
import 'package:meu_qr_code/components/qr-code/qr-code.widget.dart';

class QrCodeWidget extends StatefulWidget {
  QrCodeWidget(this.texto, {Key? key}) : super(key: key);

  late String? texto;

  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () async {
          //      shouldDisplayTheAd();

          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const QRCodeWidget(),
            ),
          );
          setState(
            () {
              widget.texto = result;
            },
          );
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Tooltip(
                  message: "Ler QRCODE",
                  child: Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.black, size: 50),
                ),
              ),
              Expanded(
                child: Text(
                  'Ler QRCode',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
