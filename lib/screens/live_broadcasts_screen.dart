import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/models/source_channel.dart';
import 'package:flutter_medic/services/live_stream_resolver_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LiveBroadcastsScreen extends StatefulWidget {
  final bool isTabActive;
  final Set<String> selectedSourceIds;

  const LiveBroadcastsScreen({
    super.key,
    this.isTabActive = true,
    this.selectedSourceIds = const {},
  });

  @override
  State<LiveBroadcastsScreen> createState() => _LiveBroadcastsScreenState();
}

class _LiveBroadcastsScreenState extends State<LiveBroadcastsScreen>
    with SingleTickerProviderStateMixin {
  late List<SourceChannel> _channels;
  late SourceChannel _activeChannel;
  late YoutubePlayerController _ytController;
  StreamSubscription<YoutubePlayerValue>? _playerSub;
  PlayerState _playerState = PlayerState.unknown;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _channels = getChannelsForSelectedSources(widget.selectedSourceIds);
    _activeChannel = _channels.first;
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: _activeChannel.youtubeVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        enableJavaScript: true,
        showVideoAnnotations: false,
      ),
    );

    _playerSub = _ytController.stream.listen((value) {
      if (mounted && _playerState != value.playerState) {
        setState(() {
          _playerState = value.playerState;
        });
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.2, end: 0.65).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _resolveActiveChannelStream(_activeChannel);
  }

  @override
  void didUpdateWidget(covariant LiveBroadcastsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTabActive != oldWidget.isTabActive) {
      if (!widget.isTabActive) {
        _ytController.pauseVideo();
      }
    }

    if (widget.selectedSourceIds != oldWidget.selectedSourceIds) {
      final updated = getChannelsForSelectedSources(widget.selectedSourceIds);
      setState(() {
        _channels = updated;
        if (!_channels.any((c) => c.id == _activeChannel.id)) {
          _activeChannel = _channels.first;
          _ytController.loadVideoById(videoId: _activeChannel.youtubeVideoId);
          _ytController.pauseVideo();
          _resolveActiveChannelStream(_activeChannel);
        }
      });
    }
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _pulseController.dispose();
    _ytController.close();
    super.dispose();
  }

  bool get _isPlaying => _playerState == PlayerState.playing;

  void _togglePlayPause(SourceChannel channel) {
    if (_activeChannel.id != channel.id) {
      setState(() {
        _activeChannel = channel;
      });
      _ytController.loadVideoById(videoId: channel.youtubeVideoId);
      _ytController.playVideo();
      _resolveActiveChannelStream(channel);
    } else {
      if (_isPlaying) {
        _ytController.pauseVideo();
      } else {
        _ytController.playVideo();
      }
    }
  }

  Future<void> _resolveActiveChannelStream(SourceChannel channel) async {
    final liveId = await LiveStreamResolverService.resolveLiveVideoId(
      handle: channel.channelHandle,
      fallbackVideoId: channel.youtubeVideoId,
    );
    if (mounted &&
        _activeChannel.id == channel.id &&
        liveId != channel.youtubeVideoId) {
      if (_isPlaying) {
        _ytController.loadVideoById(videoId: liveId);
        _ytController.playVideo();
      } else {
        _ytController.cueVideoById(videoId: liveId);
      }
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
    final channels = _channels;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: _pulseAnimation.value * 1.5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.darkRed.withValues(
                            alpha: _waveAnimation.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.darkRed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkRed.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 10),
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
                    'Size Özel Canlı Kanallar',
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
                      '${channels.length} Kanal Seçili',
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
                    isPlaying: isCurrentActive && _isPlaying,
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
                    onPressed: () => _togglePlayPause(_activeChannel),
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    tooltip: _isPlaying ? 'Durdur' : 'Oynat',
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
    required bool isPlaying,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: () => _togglePlayPause(channel),
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
                      Flexible(
                        child: Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
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
                            isPlaying ? 'Oynatılıyor' : 'Duraklatıldı',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
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
                isActive
                    ? (isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded)
                    : Icons.play_arrow_outlined,
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
