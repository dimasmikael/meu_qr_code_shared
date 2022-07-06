import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebWidget extends StatefulWidget {
  WebWidget(this.texto, {Key? key}) : super(key: key);
  late String? texto;

  @override
  _WebWidgetState createState() => _WebWidgetState();
}

class _WebWidgetState extends State<WebWidget> {
  String? _url() {
    String toLaunch;
    try {
      widget.texto;
      return toLaunch = 'https://www.google.com.br/search?q=${widget.texto}';
    } catch (e) {
      print(e);
    }
  }

  Future<void> _launchInBrowser() async {
    String? url = widget.texto;
    if (url != null) {
      if (!await launchUrl(
        Uri.parse(_url() ?? ''),
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
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
          // shouldDisplayTheAd();

          _launchInBrowser();
        },
        onLongPress: () {
          // createInterad();
          //  showInterad();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Tooltip(
                  message: 'Web',
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: new Image.asset('assets/website.png'),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Web',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
