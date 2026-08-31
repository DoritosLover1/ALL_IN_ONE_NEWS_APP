import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/models/source_channel.dart';
import 'package:flutter_medic/services/live_stream_resolver_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LiveBroadcastsScreen extends StatefulWidget {
  final bool isTabActive;

  const LiveBroadcastsScreen({super.key, this.isTabActive = true});

  @override
  State<LiveBroadcastsScreen> createState() => _LiveBroadcastsScreenState();
}

class _LiveBroadcastsScreenState extends State<LiveBroadcastsScreen> {
  late SourceChannel _activeChannel;
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    _activeChannel = initialLiveChannels.first;
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: _activeChannel.youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        enableJavaScript: true,
        showVideoAnnotations: false,
      ),
    );
    _resolveActiveChannelStream(_activeChannel);
  }

  @override
  void didUpdateWidget(covariant LiveBroadcastsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTabActive != oldWidget.isTabActive) {
      if (widget.isTabActive) {
        _ytController.setVolume(100);
      } else {
        _ytController.setVolume(20);
      }
    }
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  void _selectChannel(SourceChannel channel) {
    if (_activeChannel.id == channel.id) return;
    setState(() {
      _activeChannel = channel;
    });
    _ytController.loadVideoById(videoId: channel.youtubeVideoId);
    _resolveActiveChannelStream(channel);
  }

  Future<void> _resolveActiveChannelStream(SourceChannel channel) async {
    final liveId = await LiveStreamResolverService.resolveLiveVideoId(
      handle: channel.channelHandle,
      fallbackVideoId: channel.youtubeVideoId,
    );
    if (mounted &&
        _activeChannel.id == channel.id &&
        liveId != channel.youtubeVideoId) {
      _ytController.loadVideoById(videoId: liveId);
    }
  }

  Future<void> _openInYouTubeApp() async {
    final uri = Uri.parse(_activeChannel.liveStreamUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final channels = initialLiveChannels;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.darkRed,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Canlı Yayınlar',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.black,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _buildPlayerCard(primaryColor),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tüm Canlı Kanallar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${channels.length} Kanal Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final channel = channels[index];
                final isCurrentActive = channel.id == _activeChannel.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildChannelCard(
                    channel: channel,
                    isActive: isCurrentActive,
                    primaryColor: primaryColor,
                  ),
                );
              }, childCount: channels.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            YoutubePlayer(controller: _ytController, aspectRatio: 16 / 9),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF0F172A),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _activeChannel.badgeColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _activeChannel.badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _activeChannel.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.darkRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'CANLI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 9,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _activeChannel.programTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _openInYouTubeApp,
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    tooltip: "YouTube'da Aç",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelCard({
    required SourceChannel channel,
    required bool isActive,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: () => _selectChannel(channel),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? primaryColor : const Color(0xFFE2E8F0),
            width: isActive ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? primaryColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: channel.badgeColor,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                channel.badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        channel.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'İzleniyor',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${channel.category} • HD Canlı Yayın',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isActive ? primaryColor : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isActive ? Icons.play_arrow_rounded : Icons.play_arrow_outlined,
                color: isActive ? Colors.white : AppColors.black,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
