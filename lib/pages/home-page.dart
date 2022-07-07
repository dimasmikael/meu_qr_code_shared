import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meu_qr_code/components/qr-code/qr-code.widget.dart';
import 'package:meu_qr_code/helpers/ad_helper.dart';
import 'package:meu_qr_code/pages/widgets-page-home/compartilhar-widget.dart';
import 'package:meu_qr_code/pages/widgets-page-home/web-widget.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? texto = '';
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  int num_of_attempt_load = 0;
  int maxFailedLoadAttempts = 3;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    createInterad();
    showInterad();
    _initGoogleMobileAds();
    //_createInterstitialAd();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(
            () {
              _isBannerAdReady = true;
            },
          );
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<InitializationStatus>? _initGoogleMobileAds() {
    if (MobileAds.instance == null) {
      return MobileAds.instance.initialize();
    }
  }

  void createInterad() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          num_of_attempt_load = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          num_of_attempt_load + 1;
          _interstitialAd = null;

          if (num_of_attempt_load <= 2) {
            createInterad();
          }
        },
      ),
    );
  }

  void showInterad() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print("add onAdshowedFullScreen");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("add Dispose");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        print('$ad OnAdFailed $adError');
        ad.dispose();
        createInterad();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  Widget _buildInputCodProduto() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        texto ?? "",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _lerQrCode() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new QRCodeWidget(),
            ),
          );
          setState(
            () {
              texto = result;
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

  Widget _gridviewCard(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.green[50],
            constraints: BoxConstraints(
              maxHeight: size.height * .50,
              maxWidth: size.width,
            ),
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: (size.height / 0.6 / size.width / 2),
              children: <Widget>[
                _lerQrCode(),
                CompartilharWidget(texto),
                WebWidget(texto),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: const Text('QRCode-Light', textAlign: TextAlign.left)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 70,
                        left: 10,
                        right: 10,
                      ),
                      child: _buildInputCodProduto(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _gridviewCard(context),
                  ),
                  if (_isBannerAdReady)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: _bannerAd?.size.width.toDouble(),
                        height: _bannerAd?.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
