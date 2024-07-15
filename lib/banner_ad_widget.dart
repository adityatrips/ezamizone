import 'package:ezamizone/globals.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  final String adUnitId = "ca-app-pub-5931956401636205/4300680692";

  const MyBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 50,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color:
              Get.isDarkMode ? Globals.darkBackground : Globals.lightBackground,
        ),
        child: SizedBox(
          width: widget.adSize.width.toDouble(),
          height: widget.adSize.height.toDouble(),
          child:
              _bannerAd == null ? const SizedBox() : AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    );

    bannerAd.load();
  }
}
