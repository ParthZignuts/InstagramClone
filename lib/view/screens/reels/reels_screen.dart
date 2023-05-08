


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  late List<String> _videoUrls;
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoUrls = [
      'https://player.vimeo.com/external/436213673.sd.mp4?s=57e512cb2ae63957c8137cd33a16c004069ef626&profile_id=165&oauth2_token_id=57447761'
      'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      'https://player.vimeo.com/external/538561465.sd.mp4?s=786eeae0e3c0f89892c3c0ef13d59127799f3182&profile_id=165&oauth2_token_id=57447761',
      'https://player.vimeo.com/external/538562269.sd.mp4?s=8338aff0bf955cd062e5e660a9a059c29325e018&profile_id=165&oauth2_token_id=57447761',
      'https://player.vimeo.com/external/538562549.sd.mp4?s=f132e54f72491d919409cb025cf82cefaeee9190&profile_id=165&oauth2_token_id=57447761',
    ];
    _controller = VideoPlayerController.network(_videoUrls[0])
      ..initialize().then((_) {
        _controller.addListener(_onVideoFinished);
        _controller.play();
      });
  }

  void _onPageChanged(int index) {
    setState(() {
      _controller.dispose();
      _controller = VideoPlayerController.network(_videoUrls[index])
        ..initialize().then((_) {
          _controller.addListener(_onVideoFinished);
          _controller.play();
        });
    });
  }

  void _onVideoFinished() {
    setState(() {
      _controller.seekTo(Duration.zero);
      _controller.play();
    });
  }

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videoUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: _togglePlayback,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        },
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
