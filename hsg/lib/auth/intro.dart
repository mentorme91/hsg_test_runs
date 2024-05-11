import 'package:flutter/material.dart';
// import 'dart:async';
import '../../widgets/blue_button.dart';
import '../../widgets/white_button.dart';
import '../../widgets/loading.dart';

class Intro extends StatefulWidget {
  final Function
      toggleAuth; // allows toggle between the Onboarding, register and signIn pages
  Intro({required this.toggleAuth});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int currentIndex = 1;
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(() {
      if (mounted && (currentIndex < 2)) {
        setState(() {
          currentIndex = (_controller.value * 2).floor() + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return (currentIndex == 1)
            ? LoadingScreen()
            : Onboarding(
                toggleAuth: widget.toggleAuth,
              );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// the introduction page or Squash (First page the user sees)
class Onboarding extends StatefulWidget {
  final Function
      toggleAuth; // allows toggle between the Onboarding, register and signIn pages
  Onboarding({required this.toggleAuth});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

// Onboarding state class
class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          TextButton(
            // used to toggle to the signIn page
            onPressed: () => widget.toggleAuth(1),
            child: Text(
              'Skip',
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 56, 107, 246),
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          // allows user to scroll down and up on the page
          child: Column(
            children: [
              const SizedBox(
                // just for space
                height: 5,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/onboarding.png'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'Welcome to Squash',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Squash is a platform that allows you to connect with people around you and share your thoughts and ideas with them.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              BlueButton('Get Started', () => widget.toggleAuth(2), 60),
              const SizedBox(
                height: 7,
              ),
              whiteButton(
                  'Sign In', () => widget.toggleAuth(1), 60, Theme.of(context)),
            ],
          ),
        ),
      ),
    );
  }
}
