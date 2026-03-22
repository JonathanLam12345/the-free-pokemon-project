import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCYkT62xc7bvkUvszzqlNIps2w1i-DTiCs",
      authDomain: "jlstudios-custom-cards.firebaseapp.com",
      projectId: "jlstudios-custom-cards",
      storageBucket: "jlstudios-custom-cards.firebasestorage.app",
      messagingSenderId: "517030096782",
      appId: "1:517030096782:web:e822239c2e58751f5cfedf",
      measurementId: "G-6DD22GDJYP",
    ),
  );
  runApp(const PokemonProjectApp());
}

class PokemonProjectApp extends StatelessWidget {
  const PokemonProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Free Pokémon Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101B3B),
        primaryColor: const Color(0xFFFFCB05),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _registrationKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final String githubBase =
      "https://raw.githubusercontent.com/JonathanLam12345/the-free-pokemon-project/refs/heads/main/assets/";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-caching the logo for a smooth load
    precacheImage(NetworkImage('${githubBase}logo.webp'), context);

    precacheImage(NetworkImage('${githubBase}image1.webp'), context);
    precacheImage(NetworkImage('${githubBase}image2.webp'), context);
    precacheImage(NetworkImage('${githubBase}image3.webp'), context);
    precacheImage(NetworkImage('${githubBase}image4.webp'), context);
    precacheImage(NetworkImage('${githubBase}image5.webp'), context);
    precacheImage(NetworkImage('${githubBase}image6.webp'), context);
    precacheImage(NetworkImage('${githubBase}image7.webp'), context);
    precacheImage(NetworkImage('${githubBase}image8.webp'), context);
    precacheImage(NetworkImage('${githubBase}image9.webp'), context);
    precacheImage(NetworkImage('${githubBase}image10.webp'), context);
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double navbarHeight = kToolbarHeight + topPadding;

    return Scaffold(
      backgroundColor: const Color(0xFF101B3B),
      body: SelectionArea(
        child: RefreshIndicator(
          color: const Color(0xFFFFCB05),
          edgeOffset: topPadding + 10,
          onRefresh: () async {
            html.window.location.reload();
            return await Future.delayed(const Duration(milliseconds: 500));
          },
          child: Stack(
            children: [
              // Global Star Field Background
              Positioned.fill(child: _buildGlobalStarField()),

              // Scrolling Content
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  children: [
                    SizedBox(height: navbarHeight + 20),
                    _buildHeroSection(),
                    _buildAboutSection(isMobile, _aboutKey),
                    _buildEventDetails(isMobile, _detailsKey),
                    _buildIncludedSection(isMobile),
                    _buildRegistrationSection(_registrationKey),
                    _buildGallerySection(_galleryKey),
                    _buildSponsorsSection(),
                    _buildFAQSection(_faqKey),
                    // _buildTeamSection(),
                    _buildFooter(),
                  ],
                ),
              ),

              // Sticky Navbar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: navbarHeight,
                  child: AppBar(
                    backgroundColor: const Color(0xFF101B3B).withOpacity(0.6),
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () => html.window.location.reload(),
                          child: Image.network(
                            '${githubBase}logo.webp',
                            height: 20,
                            fit: BoxFit.contain,
                            // The errorBuilder has been removed
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'The Free Pokémon Project',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFCB05),
                          ),
                        ),
                      ],
                    ),
                    actions: _buildAppBarActions(isMobile),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalStarField() {
    return IgnorePointer(
      child: Stack(
        children: List.generate(95, (index) {
          final double top = (index * 177.7) % 4000;
          final double left = (index * 211.3) % 1800;
          final double opacity = 0.15 + (index % 5) * 0.05;
          return Positioned(
            top: top,
            left: left,
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white.withOpacity(opacity),
              size: 4.0 + (index % 4) * 3.0,
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildAppBarActions(bool isMobile) {
    return [
      if (!isMobile) ...[
        _navButton("About", _aboutKey),
        _navButton("Event Info", _detailsKey),
        _navButton("Register", _registrationKey),
        _navButton("Gallery", _galleryKey),
        _navButton("FAQ", _faqKey),
      ],
    ];
  }

  Widget _navButton(String text, GlobalKey key) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return TextButton(
      onPressed: () {
        analytics.logEvent(
          name: 'free-pokemon-button_press',
          parameters: {'Navigate to Key': 'navigate_to_$key'},
        );

        _scrollTo(key);
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 20,
        runSpacing: 60,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "THE ADVENTURE BEGINS",
                  style: TextStyle(
                    color: Color(0xFFFFCB05),
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 20),
                Text(
                  "The Free Pokémon Project",
                  style: GoogleFonts.montserrat(
                    fontSize: 55,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(),
                const SizedBox(height: 30),
                const Text(
                  "Join us for a magical day of free cards, games, and community fun!",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCB05),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: const Color(0xFFFFCB05).withOpacity(0.5),
                  ),
                  onPressed: () => _scrollTo(_registrationKey),
                  child: const Text(
                    //"REGISTER NOW",
                    "Registration Available Soon. Stay Tuned!!!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ).animate().shake(delay: 1200.ms),
              ],
            ),
          ),

          Image.network(
                '${githubBase}logo.webp',
                height: 160,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                // Falls back to a simple icon if the image fails to load
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.white24,
                ),
              )
              // 1st Animation: The original entrance (Fade in and slide up)
              .animate()
              .fadeIn(delay: 800.ms)
              .slideY(begin: 0.1)
              // 2nd Animation: The cute idle "tilt" wobble
              .animate(
                onPlay: (controller) => controller
                    .repeat(), // Loops this specific animation forever
              )
              // Waits 5 seconds before shaking to create a pause
              .shake(
                delay: 5.seconds,
                duration: 800.ms,
                hz: 2,
                // How many times it tilts back and forth
                rotation: 0.15,
                // The angle of the tilt (left and right)
                offset: const Offset(0, 0),
                // Keeps it in place (only rotates, no shifting)
                curve: Curves.easeInOut,
              )
              // Adds another 2 seconds of stillness before the loop repeats,
              // giving it a semi-random, organic feel!
              .then(delay: 2.seconds),

          // // The Parent Container provides the solid background to hide the stars
          // Container(
          //   padding: const EdgeInsets.all(20), // Optional: adds a small "safe zone" around the card
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF101B3B), // Your requested background color
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Container(
          //     width: 210,
          //     height: 300,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF1E2A4A), // The card's internal color
          //       borderRadius: BorderRadius.circular(16),
          //       border: Border.all(
          //         color: const Color(0xFFFFCB05).withOpacity(0.9),
          //         width: 3,
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: const Color(0xFFFFCB05).withOpacity(0.3),
          //           blurRadius: 20,
          //           spreadRadius: 2,
          //         ),
          //       ],
          //       gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: [
          //           const Color(0xFFFFCB05).withOpacity(0.1),
          //           Colors.transparent,
          //         ],
          //       ),
          //     ),
          //     child: Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         // Internal glow/pattern
          //         Container(
          //           margin: const EdgeInsets.all(12),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8),
          //             color: Colors.white.withOpacity(0.03),
          //           ),
          //         ),
          //         // The Pokémon Icon
          //         Transform.flip(
          //           flipY: true,
          //           child: const Icon(
          //             Icons.catching_pokemon,
          //             size: 120,
          //             color: Colors.white10,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF081229),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "About The Event",
            subtitle: "Bringing Smiles To Young Trainers",
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 60,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: const Text(
                  "The Free Pokémon Project is back! We welcome young trainers to a magical world where Pokémon dreams come true...\n\nThis free community event is all about bringing smiles to kids through games, raffles, and Pokémon cards.\n\n",
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Colors.white70,
                  ),
                ),
              ),
              //  SizedBox(height: 50, width: 50,),
              Container(
                width: 520,
                height: 400,
                clipBehavior: Clip.antiAlias,
                // Ensures the slideshow images respect the rounded corners
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A4A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child:
                    const CardSlideshow(), // The newly added slideshow widget
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF101B3B),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const SectionHeader(title: "Details", subtitle: "Where & When"),
          const SizedBox(height: 50),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _infoCard("Date", "Sunday, May 24, 2026", Icons.calendar_month),
              _infoCard("Time", "8:30 AM – 11:00 AM", Icons.alarm),
              _infoCard(
                "Location",
                "Toogood Pond Park,\nMarkham, Ontario",
                Icons.map,
                link: "https://maps.app.goo.gl/qEUvHB2oTm2mQnuW7",
                actionText: "Tap to open Google Maps",
              ),
              _infoCard("Ages", "3–12 Years Old", Icons.child_care),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedSection(bool isMobile) {
    return Container(
      color: const Color(0xFF081229),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "What's Included",
            subtitle: "100% Free For Everyone",
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _featurePoint("Admission"),
                  _featurePoint("Games and activities"),
                  _featurePoint("Raffles and prizes",url: "https://www.facebook.com/share/p/16xtsYJt77/"),
                  _featurePoint("Pokémon cards, \nincluding Holo cards!"),

                  SizedBox(height: 15),
                  Container(
                    constraints: isMobile
                        ? const BoxConstraints(maxWidth: 270)
                        : const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCB05).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFCB05).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFFFFCB05)),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Trainer Tip: We won't be handing out Pokémon card binders or tins, so be sure to bring your own bag or binder to safely store your new cards!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF1E2A4A),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "Registration",
            subtitle: "Secure Your Free Gifts",
          ),
          const SizedBox(height: 25),
          const Text(
            "All attendees must register in advance to participate and receive free gifts. Spots are limited!",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCB05),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            // onPressed: () => _launchURL(
            //   "https://docs.google.com/forms/d/e/1FAIpQLSe62I_R8h1crE2auiA62R3PVzFc1RJ8iPWVdvTcMsRxd7jphg/viewform?fbclid=IwY2xjawQW4WJleHRuA2FlbQIxMABicmlkETFid2RCU2tyMzFNZjVnRkptc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHoMheblqS3bhmokeuwOR5wqfWD3A3tOSClcEMoC1tE4Sie6mHDTSdqeCexdT_aem_YcSR9ZlKoKIPIyumQfblvQ",
            // )
            onPressed: () => null,
            child: const Text(
              //"Register Now",
              "Registration Available Soon. Stay Tuned!!!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF101B3B),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          const SectionHeader(
            title: "Photo Gallery",
            subtitle: "Memories In The Making",
          ),
          const SizedBox(height: 50),
          Container(
            width: 800,
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A4A),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFFCB05).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFFFFCB05),
                  size: 60,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Photos Coming Soon!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Photos from the event will be posted here...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Text(
              "Photographs and videos may be taken during the event and could be used on our social media pages or promotional materials.\nIf you do not feel comfortable having your image or your child’s image taken, please let one of our staff members know.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white38,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection() {
    return Container(
      color: const Color(0xFF081229),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "Sponsors",
            subtitle: "Our Community Partners",
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 60,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _sponsorLogo(
                "Flaring Lair",
                "https://FlaringLair.com",
                "flaring_lair_logo.webp",
              ),
              _sponsorLogo(
                "JLStudios",
                "https://www.instagram.com/jlstudios416/",
                "jlstudios_logo.webp",
                // NEW: Add the promo text here
                promoText:
                    "Get \$10 off your first order by stating the promo code, TheFreePokemonProject",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF101B3B),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "FAQ",
            subtitle: "Frequently Asked Questions",
          ),
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _faqItem(
                  "Is this event really free?",
                  "Yes, admission and activities are completely free.",
                ),
                _faqItem(
                  "Do parents need to stay?",
                  "Yes, children must be supervised by a parent or guardian at all times.",
                ),
                _faqItem(
                  "What should we bring to the event?",
                  "Just your excitement! While we provide plenty of free Pokémon cards, we will not be handing out items to store them it. We highly recommend bringing your own binder, tin, or a bag to safely store your new collection.",
                ),
                _faqItem(
                  "What happens if we arrive late?",
                  "Free gifts and Pokémon cards are available on a first-come, first-served basis while supplies last.",
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SelectableText.rich(
            TextSpan(
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
              children: [
                const TextSpan(
                  text: "If you have any questions, please contact us at ",
                ),
                TextSpan(
                  text: "JLStudios416@gmail.com",
                  style: const TextStyle(
                    color: Color(0xFFFFCB05),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchURL("mailto:JLStudios416@gmail.com"),
                ),
                const TextSpan(
                  text:
                      ".\nDuring the event, please reach out to Daniel or Frances.",
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildTeamSection() {
  //   return Container(
  //     color: const Color(0xFF081229),
  //     padding: const EdgeInsets.all(80),
  //     child: const Column(
  //       children: [
  //         SectionHeader(title: "The Team", subtitle: "Organizers"),
  //         SizedBox(height: 30),
  //         Text(
  //           "To be Posted...",
  //           style: TextStyle(
  //             fontSize: 22,
  //             color: Color(0xFFFFCB05),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFooter() {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          const Divider(color: Colors.white10),
          const SizedBox(height: 30),
          const Text(
            "© 2021 The Free Pokémon Project",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          const Text(
            "All Pokémon-related trademarks and characters are the property of their respective owners. This is a fan-organized community event and is not affiliated with or endorsed by The Pokémon Company.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white38,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              analytics.logEvent(
                name: 'free-pokemon-website_visit',
                parameters: {'about_JLStudios': 'about_JLStudios'},
              );

              _launchURL("mailto:JLStudios416@gmail.com");
            },
            child: const Text(
              "Website designed by JLStudios",
              style: TextStyle(color: Color(0xFFFFCB05)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    String title,
    String content,
    IconData icon, {
    String? link,
    String? actionText,
  }) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return InkWell(
      onTap: link != null
          ? () {
              _launchURL(link);

              analytics.logEvent(
                name: 'free-pokemon-info_card_clicked',
                parameters: {'info_card_clicked': link},
              );
            }
          : null,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A4A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCB05).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFFFCB05), size: 35),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
            if (link != null && actionText != null) ...[
              const SizedBox(height: 15),
              Text(
                actionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFCB05),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _featurePoint(String text, {String? url}) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        // If url is null, the button is not clickable
        onTap: url != null
            ? () {
          _launchURL(url);
          analytics.logEvent(
            name: 'free-pokemon-feature_click',
            parameters: {'feature_text': text, 'url': url},
          );
        }
            : null,
        mouseCursor: url != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Color(0xFFFFCB05), size: 18),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                // Optional: Underline the text if it is a link to signify it is clickable
                decoration: url != null ? TextDecoration.underline : TextDecoration.none,
                color: url != null ? const Color(0xFFFFCB05) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _faqItem(String question, String answer, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Color(0xFFFFCB05),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            answer,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Divider(color: Colors.white10),
            ),
        ],
      ),
    );
  }

  Widget _sponsorLogo(
    String name,
    String url,
    String imageName, {
    String? promoText,
  }) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return InkWell(
      onTap: url.isNotEmpty
          ? () {
              _launchURL(url);

              analytics.logEvent(
                name: 'free-pokemon-sponsor_link_clicked',
                parameters: {'sponsor_link_clicked': url},
              );
            }
          : null,
      child: Column(
        children: [
          // Replaced the Icon with a network image from your GitHub assets
          Image.network(
            '$githubBase$imageName',
            height: 150,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            },
            // Optional: Falls back to a simple icon if the image fails to load
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.business, size: 50, color: Colors.white24),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFFFFCB05),
              fontWeight: FontWeight.bold,
            ),
          ),
          // NEW: Conditionally show the promo text if it is provided
          if (promoText != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: 200, // Keeps the text wrapped nicely under the logo
              child: Text(
                promoText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFFFCB05),
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Container(width: 80, height: 3, color: const Color(0xFFFFCB05)),
      ],
    );
  }
}

class CardSlideshow extends StatefulWidget {
  const CardSlideshow({super.key});

  @override
  State<CardSlideshow> createState() => _CardSlideshowState();
}

class _CardSlideshowState extends State<CardSlideshow> {
  final PageController _pageController = PageController();
  Timer? _timer;
  String githubBase =
      "https://raw.githubusercontent.com/JonathanLam12345/the-free-pokemon-project/refs/heads/main/assets/";

  late final List<String> cardImages = [
    '${githubBase}image1.webp',
    '${githubBase}image2.webp',
    '${githubBase}image3.webp',
    '${githubBase}image4.webp',
    '${githubBase}image5.webp',
    '${githubBase}image6.webp',
    '${githubBase}image7.webp',
    '${githubBase}image8.webp',
    '${githubBase}image9.webp',
    '${githubBase}image10.webp',
  ];

  @override
  void initState() {
    super.initState();
    html.window.localStorage['cookie_consent'] = 'true';
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(
      name: 'free-pokemon-website_visit',
      parameters: {'main_website_visit': 'main_website_visit'},
    );

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page!.toInt() + 1) % cardImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _moveNext() {
    if (_pageController.hasClients) {
      int nextPage = (_pageController.page!.toInt() + 1) % cardImages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      _startTimer();
    }
  }

  void _movePrevious() {
    if (_pageController.hasClients) {
      int prevPage =
          (_pageController.page!.toInt() - 1 + cardImages.length) %
          cardImages.length;

      _pageController.animateToPage(
        prevPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: cardImages.length,
          itemBuilder: (context, index) {
            return Image.network(
              cardImages[index],
              fit: BoxFit.cover,
              // Ensures images cover the entire container elegantly
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white24,
                  size: 50,
                ),
              ),
            );
          },
        ),
        // Previous Button Overlay
        Positioned(
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
            onPressed: () {
              analytics.logEvent(
                name: 'free-pokemon-image_slideShow',
                parameters: {'image_slideShow_move_previous': 'move_previous'},
              );

              _movePrevious;
            },
          ),
        ),
        // Next Button Overlay
        Positioned(
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onPressed: () {
              analytics.logEvent(
                name: 'free-pokemon-image_slideShow',
                parameters: {'image_slideShow_move_next': 'move_next'},
              );
              _moveNext;
            },
          ),
        ),
      ],
    );
  }
}
