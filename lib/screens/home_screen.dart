import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/analysis_sheet.dart';
import '../widgets/compare_sheet.dart';
import '../widgets/chat_sheet.dart';

enum ViewMode { camera, analyzing, analysis, compare, chat }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ViewMode _viewMode = ViewMode.camera;
  final DraggableScrollableController _chatController = DraggableScrollableController();
  bool _isChatExpanded = false;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Optimization: Use ResolutionPreset.medium for low-end devices
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _captureAndAnalyze() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        // Optional: Take picture here if needed for backend
        // final image = await _cameraController!.takePicture();
      } catch (e) {
        debugPrint('Error taking picture: $e');
      }
    }

    setState(() {
      _viewMode = ViewMode.analyzing;
    });

    // Simulate AI Analysis
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _viewMode = ViewMode.analysis;
      });
    }
  }

  void _reset() {
    setState(() {
      _viewMode = ViewMode.camera;
      _isChatExpanded = false;
    });
  }

  void _showCompare() {
    setState(() {
      _viewMode = ViewMode.compare;
    });
  }

  void _showChat() {
    setState(() {
      _viewMode = ViewMode.chat;
      _isChatExpanded = false;
    });
  }

  void _backToAnalysis() {
    setState(() {
      _viewMode = ViewMode.analysis;
      _isChatExpanded = false;
    });
  }

  void _toggleChatExpand() {
    setState(() {
      _isChatExpanded = !_isChatExpanded;
    });
    if (_isChatExpanded) {
      _chatController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _chatController.animateTo(
        0.9,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_viewMode == ViewMode.compare || _viewMode == ViewMode.chat) {
      _backToAnalysis();
      return false;
    } else if (_viewMode == ViewMode.analysis) {
      _reset();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool showOverlay = _viewMode == ViewMode.analysis || _viewMode == ViewMode.compare || _viewMode == ViewMode.chat;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 1. Camera Viewfinder (Background)
            Positioned.fill(
              child: _isCameraInitialized
                  ? CameraPreview(_cameraController!)
                  : Image.asset(
                      'assets/product.png',
                      fit: BoxFit.cover,
                    ).animate().blur(begin: const Offset(0, 0), end: const Offset(4, 4)),
            ),
            
            // Darken overlay when showing results
            if (showOverlay)
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.3))
                    .animate()
                    .fadeIn(),
              ),

            // 2. Camera UI Overlay (Visible when NOT showing result)
            if (_viewMode == ViewMode.camera) ...[
              // Top Bar
              Positioned(
                top: 60,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(LucideIcons.user, color: Colors.white, size: 28),
                    const Icon(LucideIcons.x, color: Colors.white, size: 28),
                  ],
                ),
              ),

              // Stats Overlay
              Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCameraStat('869', 'Scan'),
                    _buildCameraStat('135', 'Terjual'),
                    _buildCameraStat('485', 'Disimpan'),
                  ],
                ).animate().fadeIn().slideY(begin: 0.5),
              ),

              // Fixed Bottom Sheet for Controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery Button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(LucideIcons.image, color: Colors.black87),
                      ),
                      
                      // Capture Button
                      GestureDetector(
                        onTap: _captureAndAnalyze,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red, // Accent color for capture
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(LucideIcons.camera, color: Colors.white, size: 32),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds),

                      // Settings Button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(LucideIcons.settings, color: Colors.black87),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutQuart),
              ),
            ],

            // 3. Analysis Loading Overlay
            if (_viewMode == ViewMode.analyzing)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.scanLine, color: Colors.white, size: 48)
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 1.seconds),
                      const SizedBox(height: 16),
                      Text(
                        'Menganalisis Barang...',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),
              ),

            // 4. Analysis Result Bottom Sheet
            if (_viewMode == ViewMode.analysis)
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent < 0.25) {
                    _reset();
                  }
                  return true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.55,
                  minChildSize: 0.0,
                  maxChildSize: 0.92,
                  snap: true,
                  snapSizes: const [0.55, 0.92],
                  builder: (context, scrollController) {
                    return AnalysisSheet(
                      scrollController: scrollController,
                      onComparePressed: _showCompare,
                      onAskAIPressed: _showChat,
                    );
                  },
                ),
              ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutQuart, duration: 600.ms),

            // 5. Compare Bottom Sheet
            if (_viewMode == ViewMode.compare)
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent < 0.25) {
                    _backToAnalysis();
                  }
                  return true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.0,
                  maxChildSize: 0.92,
                  snap: true,
                  snapSizes: const [0.6, 0.92],
                  builder: (context, scrollController) {
                    return CompareSheet(
                      scrollController: scrollController,
                      onBackPressed: _backToAnalysis,
                    );
                  },
                ),
              ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutQuart, duration: 600.ms),

            // 6. Chat Bottom Sheet
            if (_viewMode == ViewMode.chat)
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent < 0.25) {
                    _backToAnalysis();
                  }
                  return true;
                },
                child: DraggableScrollableSheet(
                  controller: _chatController,
                  initialChildSize: 0.9,
                  minChildSize: 0.0,
                  maxChildSize: 1.0,
                  snap: true,
                  snapSizes: const [0.9, 1.0],
                  builder: (context, scrollController) {
                    return ChatSheet(
                      scrollController: scrollController,
                      onBackPressed: _backToAnalysis,
                      isExpanded: _isChatExpanded,
                    );
                  },
                ),
              ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutQuart, duration: 600.ms),
              
            // Floating Action Button (Close / Expand)
            if (showOverlay)
               Positioned(
                top: 60,
                right: 24,
                child: IconButton(
                  onPressed: _viewMode == ViewMode.chat ? _toggleChatExpand : _reset,
                  icon: Icon(
                    _viewMode == ViewMode.chat 
                        ? (_isChatExpanded ? LucideIcons.minimize : LucideIcons.maximize) 
                        : LucideIcons.x, 
                    color: Colors.white, 
                    size: 28
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
