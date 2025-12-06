import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompareSheet extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback? onBackPressed;

  const CompareSheet({
    super.key, 
    required this.scrollController,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Mock Data for Comparison
    final List<Map<String, dynamic>> marketData = [
      {'name': 'Tokopedia', 'price': 2850000, 'icon': 'assets/icons/tokopedia.png'},
      {'name': 'Shopee',    'price': 2600000, 'icon': 'assets/icons/shopee.png'},
      {'name': 'Lazada',    'price': 2450000, 'icon': 'assets/icons/lazada.png'},
      {'name': 'TikTok',    'price': 2700000, 'icon': 'assets/icons/tiktok_shop.png'},
      {'name': 'Facebook',  'price': 2100000, 'icon': 'assets/icons/facebook.png'},
    ];

    // Find highest price for scaling and highlighting
    double maxPrice = 0;
    Map<String, dynamic> highestMarket = marketData[0];
    
    for (var data in marketData) {
      if (data['price'] > maxPrice) {
        maxPrice = (data['price'] as int).toDouble();
        highestMarket = data;
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            spreadRadius: 5,
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

          // Header with Back Button
          Row(
            children: [
              if (onBackPressed != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.barChart2, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perbandingan Harga',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'vs Barang Serupa',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn().slideX(),

          const SizedBox(height: 32),

          // Insight Summary Box
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.trendingUp, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Potensi Tertinggi',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${highestMarket['name']} memiliki harga pasar tertinggi Rp ${_formatPriceShort(highestMarket['price'])}.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: 100.ms).fadeIn().slideY(),

          const SizedBox(height: 24),

          // Price Graph
          Container(
            height: 280, // Increased height to prevent overflow
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grafik Harga Rata-rata',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '30 Hari Terakhir',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: marketData.map((data) {
                    bool isHighest = data == highestMarket;
                    double heightFactor = (data['price'] as int) / maxPrice;
                    return _buildBar(heightFactor, data['icon'], data['name'], data['price'] as int, isHighest);
                  }).toList(),
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn().scale(),

          const SizedBox(height: 32),

          // Competitor List
          Text(
            'Kompetitor Teratas',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildCompetitorRow('Toko Kamera Antik', 'Rp 2.450.000', '4.9', true, 'assets/icons/tokopedia.png'),
          _buildCompetitorRow('Retro Gadgets', 'Rp 2.600.000', '4.7', false, 'assets/icons/shopee.png'),
          _buildCompetitorRow('Dunia Analog', 'Rp 2.300.000', '4.5', false, 'assets/icons/instagram.png'),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, String assetPath, String label, int price, bool isHighest) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _formatPriceShort(price),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isHighest ? const Color(0xFF10B981) : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 36, // Slightly wider bars
          height: 120 * heightFactor,
          decoration: BoxDecoration(
            color: isHighest ? const Color(0xFF10B981) : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            boxShadow: isHighest ? [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          assetPath, 
          width: 20, 
          height: 20, 
          errorBuilder: (c,e,s) => const Icon(Icons.store, size: 20, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        // Use Logo or Short Name only to avoid clutter
      ],
    );
  }

  // Helper to format price to "2.8jt"
  String _formatPriceShort(int price) {
    if (price >= 1000000) {
      double simplified = price / 1000000;
      // Remove trailing zero if whole number (e.g. 2.0 -> 2)
      return simplified.toStringAsFixed(simplified.truncateToDouble() == simplified ? 0 : 1) + 'jt';
    }
    return (price / 1000).toStringAsFixed(0) + 'rb';
  }

  Widget _buildCompetitorRow(String name, String price, String rating, bool isCheapest, String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(assetPath, width: 32, height: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    const Icon(LucideIcons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: isCheapest ? Colors.green : Colors.black87,
                ),
              ),
              if (isCheapest)
                Text(
                  'Termurah',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}
