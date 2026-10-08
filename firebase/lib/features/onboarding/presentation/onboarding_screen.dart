import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:talenthub/core/theme/app_colors.dart';
import 'package:talenthub/core/theme/app_text_styles.dart';
import 'package:talenthub/core/router/route_names.dart';
import 'package:talenthub/features/onboarding/providers/launch_provider.dart';

class OnboardingPage {
  final String title;
  final String subtext;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.subtext,
    required this.imagePath,
  });
}

final onboardingPages = [
  OnboardingPage(
    title: 'Your talent deserves the world\'s stage.',
    subtext: 'Join a curated community of elite artists and dancers.',
    imagePath: 'assets/images/onboarding/slide1.jpg',
  ),
  OnboardingPage(
    title: 'Watch artists perform live.',
    subtext: 'Experience raw talent and professional performances in real-time.',
    imagePath: 'assets/images/onboarding/slide2.jpg',
  ),
  OnboardingPage(
    title: 'Never miss an announcement.',
    subtext: 'Get direct access to auditions and agency updates.',
    imagePath: 'assets/images/onboarding/slide3.jpg',
  ),
  OnboardingPage(
    title: 'Join the family.',
    subtext: 'Start your journey toward the world\'s biggest stages.',
    imagePath: 'assets/images/onboarding/slide4.jpg',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Final slide: Navigate to signup
      ref.read(launchNotifierProvider.notifier).completeOnboarding();
      context.go(RouteNames.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Media Layer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              final page = onboardingPages[index];
              return Stack(
                children: [
                  // Image with subtle fade-to-black gradient
                  Positioned.fill(
                    child: Image.asset(
                      page.imagePath,
                      fit: BoxFit.cover,
                      // Error handling for missing assets during scaffolding
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.surface,
                        child: const Center(child: Icon(Icons.image, color: AppColors.border, size: 64)),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withOpacity(0.3),
                            AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Top: Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        ref.read(launchNotifierProvider.notifier).completeOnboarding();
                        context.go(RouteNames.login);
                      },
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Center: Typography
                  Text(
                    onboardingPages[_currentPage].title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    onboardingPages[_currentPage].subtext,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const Spacer(),
                  // Bottom: Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: onboardingPages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.gold,
                          dotColor: AppColors.border,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            _currentPage == onboardingPages.length - 1 ? 'Join Now' : 'Next',
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
