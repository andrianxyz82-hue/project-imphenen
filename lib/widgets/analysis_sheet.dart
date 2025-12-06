import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AnalysisSheet extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback? onComparePressed;
  final VoidCallback? onAskAIPressed;
  final Map<String, dynamic>? analysisData;

  const AnalysisSheet({
    super.key, 
    required this.scrollController,
    this.onComparePressed,
    this.onAskAIPressed,
    this.analysisData,
  });

  @override
  Widget build(BuildContext context) {
    // Default / Loading State
    final String name = analysisData?['productName'] ?? 'Menganalisis...';
    final String priceRange = analysisData?['priceRange'] ?? 'Rp -';
    final String desc = analysisData?['description'] ?? 'Sedang memproses data visual...';
    final String accuracy = analysisData?['accuracy'] ?? 'High';
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Darker shadow for better separation
            blurRadius: 25,
            spreadRadius: 2,
            offset: Offset(0, -5), // Shadow upwards to separate from image
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Ensure vertical center alignment
            children: [
              Container( // Wrap in container for shadow/border if needed for neatness
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/product.png', // Ideally this follows the captured image too, but for now asset fallback is safer for UI demo
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20), // Increased spacing for breathability
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green[100]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.sparkles, size: 14, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            'Akurasi $accuracy',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn().slideX(),

          const SizedBox(height: 32),

          // Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Est. Harga', _formatCompactPrice(priceRange), LucideIcons.tag),
              _buildMetric('Terjual/Mgg', '124', LucideIcons.shoppingBag),
              _buildMetric('Rating', '4.8', LucideIcons.star),
            ],
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 32),

          // AI Analysis
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded( // Make it full width/expanded for symmetry if desired, or keep centered.
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text(
                          'Analisis AI', // Slightly more descriptive
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                         Image.asset(
                          'assets/icons/update-removebg-preview.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              desc,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 32),

          // Recommendations
          Text(
            'Rekomendasi Marketplace',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMarketplaceCard('Tokopedia', 'Potensi Tinggi', Colors.green, 'assets/icons/tokopedia.png'),
                const SizedBox(width: 12),
                _buildMarketplaceCard('Shopee', 'Kompetisi Sedang', Colors.orange, 'assets/icons/shopee.png'),
                const SizedBox(width: 12),
                _buildMarketplaceCard('Instagram', 'Pasar Niche', Colors.purple, 'assets/icons/instagram.png'),
              ],
            ),
          ).animate(delay: 600.ms).fadeIn().slideX(begin: 0.2),

          const SizedBox(height: 40),

          // Actions
          ElevatedButton(
            onPressed: onAskAIPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: const Color(0xFF10B981).withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.messageCircle, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tanya AI',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate(delay: 800.ms).scale(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onComparePressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Bandingkan',
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ).animate(delay: 900.ms).fadeIn(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black87, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
  
  // Helper to format string with numbers to compact format (e.g., 2.500.000 -> 2.5jt)
  String _formatCompactPrice(String raw) {
    return raw.replaceAllMapped(RegExp(r'\b\d{1,3}(?:\.\d{3})+(?:,\d+)?\b|\b\d{4,}\b'), (match) {
      String numberStr = match.group(0)!;
      String cleanStr = numberStr.replaceAll('.', '').replaceAll(',', '');
      try {
        double value = double.parse(cleanStr);
        if (value >= 1000000) {
          double millions = value / 1000000;
          String s = millions.toStringAsFixed(1);
          if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
          return '${s}jt';
        } else if (value >= 1000) {
          double thousands = value / 1000;
          String s = thousands.toStringAsFixed(0);
          if (value % 1000 != 0) {
             s = thousands.toStringAsFixed(1);
             if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
          }
          return '${s}k';
        }
        return numberStr;
      } catch (e) {
        return numberStr;
      }
    });
  }

  Widget _buildMarketplaceCard(String name, String status, Color color, String assetPath) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(assetPath, width: 32, height: 32),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
