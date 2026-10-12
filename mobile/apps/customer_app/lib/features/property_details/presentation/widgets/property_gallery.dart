import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertyGallery extends StatefulWidget {
  const PropertyGallery({
    super.key,
    required this.images,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onBack,
  });

  final List<Uri> images;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onBack;

  @override
  State<PropertyGallery> createState() => _PropertyGalleryState();
}

class _PropertyGalleryState extends State<PropertyGallery> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreenGallery(BuildContext context) {
    if (widget.images.isEmpty) return;
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (context) => _FullScreenGalleryDialog(
        images: widget.images,
        initialIndex: _currentPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageCount = widget.images.length;

    return SizedBox(
      height: 310,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Swipable Hero PageView or Placeholder
          if (widget.images.isEmpty)
            const _GalleryPlaceholder()
          else
            GestureDetector(
              onTap: () => _openFullScreenGallery(context),
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageCount,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (context, index) {
                  final uri = widget.images[index];
                  return Image.network(
                    uri.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const _GalleryPlaceholder(),
                  );
                },
              ),
            ),

          // 2. Subtle top vignette for contrast
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 94,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0C1A2D).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Top Action Buttons (Back & Favorite)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button: In RTL, first child in Row is at START (TOP RIGHT)
                    // Icons.arrow_back in RTL automatically points RIGHT (hierarchical return)
                    _CircleActionButton(
                      icon: Icons.arrow_back,
                      label: 'الرجوع إلى الاستكشاف',
                      onPressed: widget.onBack,
                    ),
                    // Favorite Button: In RTL, second child in Row is at END (TOP LEFT)
                    _CircleActionButton(
                      icon: widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: widget.isFavorite ? const Color(0xFFE34154) : const Color(0xFF111723),
                      label: widget.isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                      onPressed: widget.onToggleFavorite,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Photo Count Pill (Approved Lower-Left Corner)
          if (imageCount > 0)
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => _openFullScreenGallery(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101A2C).withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '${_currentPage + 1} من $imageCount',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.white.withValues(alpha: 0.94),
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              icon,
              size: 22,
              color: iconColor ?? const Color(0xFF111723),
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDCE8ED),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 56,
        color: Color(0xFF64768B),
      ),
    );
  }
}

class _FullScreenGalleryDialog extends StatefulWidget {
  const _FullScreenGalleryDialog({
    required this.images,
    required this.initialIndex,
  });

  final List<Uri> images;
  final int initialIndex;

  @override
  State<_FullScreenGalleryDialog> createState() => _FullScreenGalleryDialogState();
}

class _FullScreenGalleryDialogState extends State<_FullScreenGalleryDialog> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF070B12),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF070B12),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 26),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      '${_currentIndex + 1} من ${widget.images.length}',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance close button
                  ],
                ),
              ),

            // Main Image View
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentIndex = idx;
                  });
                },
                itemBuilder: (context, index) {
                  final uri = widget.images[index];
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        uri.toString(),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const _GalleryPlaceholder(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Thumbnails Row
            if (widget.images.length > 1)
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.images.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = index == _currentIndex;
                    return GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.images[index].toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _GalleryPlaceholder(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}

