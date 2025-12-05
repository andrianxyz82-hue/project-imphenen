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
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.barChart2, color: Colors.blue),
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

          // Price Graph Mock
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tren Harga Pasar',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(0.4, 'assets/icons/tokopedia.png'),
                    _buildBar(0.7, 'assets/icons/shopee.png'),
                    _buildBar(0.5, 'assets/icons/lazada.png'),
                    _buildBar(0.8, 'assets/icons/tiktok_shop.png'),
                    _buildBar(0.3, 'assets/icons/facebook.png'),
                  ],
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

  Widget _buildBar(double heightFactor, String assetPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(assetPath, width: 20, height: 20),
      ],
    );
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
