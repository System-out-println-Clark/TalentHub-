import 'package:flutter/material.dart';
import 'package:talenthub/core/theme/app_theme.dart';

class MockArtist {
  final String id;
  final String name;
  final String role;
  final String primaryImage;
  final List<String> portfolioItems;
  final List<String> skills;

  MockArtist({
    required this.id,
    required this.name,
    required this.role,
    required this.primaryImage,
    required this.portfolioItems,
    required this.skills,
  });
}

class MockAnnouncement {
  final String id;
  final String title;
  final String date;
  final String content;

  MockAnnouncement({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
  });
}

class MockLiveSession {
  final String id;
  final String artistId;
  final String title;
  final String thumbnail;
  final bool isLive;

  MockLiveSession({
    required this.id,
    required this.artistId,
    required this.title,
    required this.thumbnail,
    required this.isLive,
  });
}

class MockData {
  static final List<MockArtist> artists = [
    MockArtist(
      id: '1',
      name: 'Elena Vance',
      role: 'CONTEMPORARY DANCER',
      primaryImage: 'https://images.unsplash.com/photo-1508700115892-45ecd05724ca?q=80&w=1000',
      portfolioItems: [
        'https://images.unsplash.com/photo-1508700115892-45ecd05724ca?q=80&w=500',
        'https://images.unsplash.com/photo-1547153769-2739ed57c077?q=80&w=500',
        'https://images.unsplash.com/photo-1518834107795-76675a77a62a?q=80&w=500',
      ],
      skills: ['Contemporary', 'Jazz', 'Ballet'],
    ),
    MockArtist(
      id: '2',
      name: 'Marcus Thorne',
      role: 'MODERN BALLET',
      primaryImage: 'https://images.unsplash.com/photo-1508700115892-45ecd05724ca?q=80&w=1000',
      portfolioItems: [
        'https://images.unsplash.com/photo-1547153769-2739ed5724ca?q=80&w=500',
        'https://images.unsplash.com/photo-1518834107795-76675a77a62a?q=80&w=500',
      ],
      skills: ['Classical Ballet', 'Contemporary'],
    ),
  ];

  static final List<MockAnnouncement> announcements = [
    MockAnnouncement(
      id: 'a1',
      title: 'Winter Showcase 2026',
      date: 'Oct 12',
      content: 'The annual Winter Showcase will be held at the Grand Theatre.',
    ),
    MockAnnouncement(
      id: 'a2',
      title: 'New Studio Opening',
      date: 'Oct 20',
      content: 'Our new downtown studio is now open for bookings.',
    ),
  ];

  static final List<MockLiveSession> liveSessions = [
    MockLiveSession(
      id: 'l1',
      artistId: '1',
      title: 'Contemporary Flow Masterclass',
      thumbnail: 'https://images.unsplash.com/photo-1508700115892-45ecd05724ca?q=80&w=500',
      isLive: true,
    ),
  ];
}
