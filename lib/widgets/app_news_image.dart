import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medic/services/parsers/base_news_parser.dart';

/// Haber görselini (Network veya Asset) render eden, hata durumunda
/// otomatik olarak gazetenin/kanalın lokal asset paneline fallback yapan widget.
class AppNewsImage extends StatelessWidget {
  final String? imageUrl;
  final String sourceId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNewsImage({
    super.key,
    required this.imageUrl,
    required this.sourceId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageContent();

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: imageWidget,
    );
  }

  Widget _buildImageContent() {
    final rawUrl = imageUrl?.trim();

    // 1. Görsel yoksa veya boşsa -> Lokal asset logo göster
    if (rawUrl == null || rawUrl.isEmpty) {
      return _buildAssetFallback();
    }

    // 2. Lokal asset yolu ise (assets/...) -> Direkt Image.asset
    if (rawUrl.startsWith('assets/')) {
      return Image.asset(
        rawUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => _buildAssetFallback(),
      );
    }

    // 3. Web URL ise -> CachedNetworkImage, hata durumunda lokal asset logo fallback
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: rawUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => Container(
          color: const Color(0xFFF1F5F9),
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF94A3B8)),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildAssetFallback(),
      );
    }

    // Beklenmedik format -> Fallback
    return _buildAssetFallback();
  }

  Widget _buildAssetFallback() {
    final assetPath = BaseNewsParser.getFallbackImageForSource(sourceId);
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => Container(
        color: const Color(0xFF1E293B),
        child: const Center(
          child: Icon(
            Icons.newspaper_rounded,
            color: Colors.white54,
            size: 28,
          ),
        ),
      ),
    );
  }
}
