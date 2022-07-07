import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class CompartilharWidget extends StatefulWidget {
  CompartilharWidget(this.texto, {Key? key}) : super(key: key);

  late String? texto;

  @override
  _CompartilharWidgetState createState() => _CompartilharWidgetState();
}

class _CompartilharWidgetState extends State<CompartilharWidget> {
  Future<bool?> share() async {
    if (widget.texto != null && widget.texto != '') {
      bool? shareResult = await FlutterShare.share(
          title: 'Compartilhamento',
          linkUrl: widget.texto,
          chooserTitle: 'Escolha aonde quer compartilhar');

      return shareResult;
    } else {
      await ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leia o QRCode!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          share();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: new Tooltip(
                  message: 'Compartillhar',
                  child: Icon(Icons.share, color: Colors.black, size: 50),
                ),
              ),
              Expanded(
                child: Text(
                  'Compartillhar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
