import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:de_fi_sample1/screens/add_post_screen.dart';
import 'package:de_fi_sample1/screens/feed_screen.dart';
import 'package:de_fi_sample1/screens/profile_screen.dart';
import 'package:de_fi_sample1/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];