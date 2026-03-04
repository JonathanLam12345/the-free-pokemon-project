import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart'; // [cite: 1, 2]

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
  ); // [cite: 2]
  runApp(const PokemonProjectApp()); // [cite: 3]
}

class PokemonProjectApp extends StatelessWidget {
  const PokemonProjectApp({super.key}); // [cite: 3]

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
    ); // [cite: 4]
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState(); // [cite: 5]
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey(); // [cite: 6]
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _registrationKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey(); // [cite: 7]

  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Cache UI elements first
    precacheImage(NetworkImage('${githubBase}instagram_logo.webp'), context);
    precacheImage(NetworkImage('${githubBase}jlstudios_logo.webp'), context);
    precacheImage(NetworkImage('${githubBase}how_cards_made.webp'), context);

    // Staggered and Resized Caching for slideshow
    for (String url in cardImages) {
      precacheImage(
        // Resize to 800px height to save massive amounts of RAM
        ResizeImage(NetworkImage(url), height: 800),
        context,
      ).catchError((e) => debugPrint("Error caching $url: $e"));
    }



    precacheImage(NetworkImage('${githubBase}elsie_lam_image.webp'), context);
  }


  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ); // [cite: 8, 9]
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800; // [cite: 9]
    final double topPadding = MediaQuery.of(context).padding.top;
    final double navbarHeight = kToolbarHeight + topPadding; // [cite: 10]

    return Scaffold(
      backgroundColor: const Color(0xFF101B3B),
      body: SelectionArea(
        child: RefreshIndicator(
          color: const Color(0xFFFFCB05),
          edgeOffset: topPadding + 10,
          onRefresh: () async {
            html.window.location.reload();
            return await Future.delayed(
              const Duration(milliseconds: 500),
            ); // [cite: 11]
          },
          child: Stack(
            children: [
              // 1. BACKGROUND LAYER: The stars are placed here
              Positioned.fill(child: _buildGlobalStarField()), // [cite: 12]
              // 2. FOREGROUND LAYER: The scrolling content
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(), // [cite: 12, 13]
                ),
                child: Column(
                  children: [
                    SizedBox(height: navbarHeight + 20), // [cite: 13]
                    _buildHeroSection(), // [cite: 14]
                    _buildAboutSection(isMobile, _aboutKey),
                    _buildEventDetails(isMobile, _detailsKey),
                    _buildIncludedSection(isMobile),
                    _buildRegistrationSection(_registrationKey), // [cite: 14]
                    _buildGallerySection(_galleryKey), // [cite: 15]
                    _buildSponsorsSection(),
                    _buildFAQSection(_faqKey),
                    _buildTeamSection(),
                    _buildFooter(), // [cite: 15]
                  ],
                ),
              ),

              // 3. STICKY NAVBAR
              Positioned(
                top: 0,
                left: 0,
                right: 0, // [cite: 16]
                child: SizedBox(
                  height: navbarHeight,
                  child: AppBar(
                    backgroundColor: const Color(0xFF101B3B).withOpacity(0.6),
                    flexibleSpace: ClipRect(
                      // [cite: 17]
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(color: Colors.transparent),
                      ), // [cite: 18]
                    ),
                    title: const Text(
                      'The Free Pokémon Project',
                      style: TextStyle(
                        // [cite: 19]
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFCB05),
                      ),
                    ),
                    actions: _buildAppBarActions(isMobile), // [cite: 20]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ); // [cite: 21]
  }

  Widget _buildGlobalStarField() {
    return IgnorePointer(
      child: Stack(
        children: List.generate(70, (index) {
          final double top = (index * 177.7) % 4000;
          final double left = (index * 211.3) % 1800;
          // Slightly increased opacity so they show up better behind the text
          final double opacity = 0.15 + (index % 5) * 0.05; // [cite: 22]
          return Positioned(
            // [cite: 22]
            top: top,
            left: left,
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white.withOpacity(opacity),
              size: 4.0 + (index % 4) * 3.0,
            ), // [cite: 23]
          );
        }),
      ),
    ); // [cite: 24]
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
    ]; // [cite: 25]
  }

  Widget _navButton(String text, GlobalKey key) {
    return TextButton(
      onPressed: () => _scrollTo(key),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    ); // [cite: 26]
  }

  Widget _buildHeroSection() {
    return Container(
      // Changed from a solid color to transparent so the stars show through
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 60,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500), //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "THE ADVENTURE BEGINS",
                  style: TextStyle(
                    // [cite: 28]
                    color: Color(0xFFFFCB05),
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(), // [cite: 29]
                const SizedBox(height: 20),
                Text(
                  "The Free Pokémon Project",
                  style: GoogleFonts.montserrat(
                    fontSize: 55, // [cite: 30]
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(), // [cite: 31]
                const SizedBox(height: 30),
                const Text(
                  "Join us for a magical day of free cards, games, and community fun!",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ).animate().fadeIn(delay: 600.ms), // [cite: 32]
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCB05),
                    foregroundColor: Colors.black,
                    // [cite: 33]
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 25,
                    ),
                    // [cite: 34]
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    // [cite: 35]
                    shadowColor: const Color(0xFFFFCB05).withOpacity(0.5),
                  ),
                  onPressed: () => _scrollTo(_registrationKey),
                  child: const Text(
                    "REGISTER NOW", // [cite: 36]
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ).animate().shake(delay: 1200.ms),
              ],
            ),
          ),

          Container(
            width: 220, // Adjusted for card aspect ratio
            height: 310,
            decoration: BoxDecoration(
              // Changed shape from circle to rectangle for the card look
              color: const Color(0xFF1E2A4A),
              // Solid indigo base [cite: 39]
              borderRadius: BorderRadius.circular(16),
              // Rounded corners like a real card
              border: Border.all(
                color: const Color(0xFFFFCB05),
                // Classic Pokemon Yellow border [cite: 35]
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFCB05).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFCB05).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Subtle background pattern or glow
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),
                // The Pokémon Icon
                Transform.flip(
                  flipY: true,
                  // Applied flip as requested in your latest snippet
                  child: const Icon(
                    Icons.catching_pokemon,
                    size: 120,
                    color: Colors.white10,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  // --- REST OF THE SECTIONS ---
  Widget _buildAboutSection(bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      color: const Color(0xFF081229),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "About The Event",
            subtitle: "Bringing Smiles To Young Trainers", // [cite: 48]
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 60,
            children: [
              // [cite: 49]
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: const Text(
                  "The Free Pokémon Project is back! We welcome young trainers to a magical world where Pokémon dreams come true, and we are excited to have you join us on this unforgettable Pokémon journey.\n\nThis free community event is all about bringing smiles to kids through games, raffles, and Pokémon cards.",
                  // [cite: 50]
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Colors.white70, // [cite: 51]
                  ),
                ),
              ),
              Container(
                width: 400,
                height: 250, // [cite: 52]
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A4A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ), // [cite: 53]
                child: const Center(
                  child: Icon(
                    Icons.groups_outlined,
                    size: 80,
                    color: Color(0xFFFFCB05), // [cite: 54]
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ],
      ),
    ); // [cite: 55]
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
            // [cite: 56]
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _infoCard("Date", "Sunday\nMay 24, 2026", Icons.calendar_month),
              _infoCard("Time", "8:30 AM – 11:00 AM", Icons.alarm),
              _infoCard(
                // [cite: 57]
                "Location",
                "Toogood Pond Park,\nMarkham, Ontario",
                Icons.map,
                link: "https://maps.app.goo.gl/qEUvHB2oTm2mQnuW7",
                actionText: "Tap to open Google Maps",
              ), // [cite: 58]
              _infoCard("Ages", "3–12 Years Old", Icons.child_care),
            ],
          ),
        ],
      ),
    ); // [cite: 59]
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
          ), // [cite: 60]
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [cite: 61]
                  _featurePoint("Admission"),
                  _featurePoint("Games and activities"),
                  _featurePoint("Raffles and prizes"),
                  _featurePoint("Pokémon cards, \nincluding Holo cards!"),
                ],
              ), // [cite: 62]
            ],
          ),
        ],
      ),
    ); // [cite: 63]
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
          ), // [cite: 64]
          const SizedBox(height: 25),
          const Text(
            "All attendees must register in advance to participate and receive free gifts. Spots are limited!",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            // [cite: 65]
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCB05),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // [cite: 66]
              ),
            ),
            onPressed: () => null,
            child: const Text(
              "Coming Soon",
              style: TextStyle(fontWeight: FontWeight.bold), // [cite: 67]
            ),
          ),
        ],
      ),
    ); // [cite: 68]
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
            subtitle: "Memories In The Making", // [cite: 69]
          ),
          const SizedBox(height: 50),
          Container(
            width: 800,
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A4A),
              borderRadius: BorderRadius.circular(30), // [cite: 70]
              border: Border.all(
                color: const Color(0xFFFFCB05).withOpacity(0.2),
              ),
            ),
            child: const Column(
              children: [
                // [cite: 71]
                Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFFFFCB05),
                  size: 60,
                ),
                SizedBox(height: 25), // [cite: 72]
                Text(
                  "Photos Coming Soon!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold, // [cite: 73]
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Photos from the event will be posted here...", // [cite: 74]
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6, // [cite: 75]
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 30),
          ConstrainedBox(
            // [cite: 76]
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              "Photographs and videos may be taken during the event and used on social media. If you prefer not to be photographed or filmed, please let one of our staff members know.",
              // [cite: 77]
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white38,
                height: 1.4, // [cite: 78]
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
          // [cite: 79]
          const SectionHeader(
            title: "Sponsors",
            subtitle: "Our Community Partners",
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 60,
            runSpacing: 40, // [cite: 80]
            alignment: WrapAlignment.center,
            children: [
              _sponsorLogo("Flaring Lair", "https://FlaringLair.com"),
              _sponsorLogo("JLStudios", ""),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(GlobalKey key) {
    return Container(
      // [cite: 81]
      key: key,
      color: const Color(0xFF101B3B),
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          const SectionHeader(
            title: "FAQ",
            subtitle: "Frequently Asked Questions",
          ), // [cite: 82]
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _faqItem(
                  // [cite: 83]
                  "Is this event really free?",
                  "Yes, admission and activities are completely free.",
                ),
                _faqItem(
                  // [cite: 84]
                  "Do parents need to stay?",
                  "Yes, children must be supervised by a parent or guardian at all times.",
                ), // [cite: 85]
                _faqItem(
                  // [cite: 85]
                  "What happens if we arrive late?",
                  "Free gifts and Pokémon cards are available on a first-come, first-served basis while supplies last.",
                  isLast: true,
                ), // [cite: 86]
              ],
            ),
          ),
          const SizedBox(height: 50),
          SelectableText.rich(
            TextSpan(
              style: const TextStyle(
                // [cite: 87]
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
              children: [
                const TextSpan(
                  // [cite: 88]
                  text:
                      "If you have any questions, please don't hesitate to contact us at ",
                ),
                TextSpan(
                  text: "JLStudios416@gmail.com", // [cite: 89]
                  style: const TextStyle(
                    color: Color(0xFFFFCB05),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ), // [cite: 90]
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchURL("mailto:JLStudios416@gmail.com"),
                ),
                const TextSpan(
                  text: // [cite: 91]
                      ".\nDuring the event, please reach out to Daniel or Frances.",
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ], // [cite: 92]
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      color: const Color(0xFF081229),
      padding: const EdgeInsets.all(80),
      child: const Column(
        children: [
          SectionHeader(title: "The Team", subtitle: "Organizers"),
          SizedBox(height: 30),
          Text(
            "To be Posted...", // [cite: 93]
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFFFFCB05),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ); // [cite: 94]
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          const Divider(color: Colors.white10),
          const SizedBox(height: 30),
          const Text(
            "© 2021 The Free Pokémon Project",
            style: TextStyle(color: Colors.white70), // [cite: 95]
          ),
          const SizedBox(height: 10),
          const Text(
            "All Pokémon-related trademarks and characters are the property of their respective owners. This is a fan-organized community event and is not affiliated with or endorsed by The Pokémon Company.",
            textAlign: TextAlign.center,
            style: TextStyle(
              // [cite: 96]
              fontSize: 12,
              color: Colors.white38,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => null, // [cite: 97]
            child: const Text(
              "Website designed by JLStudios",
              style: TextStyle(color: Color(0xFFFFCB05)),
            ),
          ),
        ], // [cite: 98]
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
    return InkWell(
      onTap: link != null ? () => _launchURL(link) : null,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(30), // [cite: 99]
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A4A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20, // [cite: 100]
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15), // [cite: 101]
              decoration: BoxDecoration(
                color: const Color(0xFFFFCB05).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFFFCB05), size: 35),
            ),
            const SizedBox(height: 20), // [cite: 102]
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white, // [cite: 103]
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ), // [cite: 104]
            ),
            if (link != null && actionText != null) ...[
              const SizedBox(height: 15),
              Text(
                actionText, // [cite: 105]
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFCB05),
                  fontSize: 12,
                  fontWeight: FontWeight.bold, // [cite: 106]
                ),
              ),
            ],
          ],
        ),
      ),
    ); // [cite: 107]
  }

  Widget _featurePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFCB05), size: 18),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 18)), // [cite: 108]
        ],
      ),
    ); // [cite: 109]
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
              // [cite: 110]
              color: Color(0xFFFFCB05),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            answer,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ), // [cite: 111]
          ),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Divider(color: Colors.white10),
            ),
        ],
      ), // [cite: 112]
    );
  }

  Widget _sponsorLogo(String name, String url) {
    return InkWell(
      onTap: () => null,
      child: Column(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 50,
            color: Colors.white24, // [cite: 113]
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFFFFCB05),
              fontWeight: FontWeight.bold,
            ), // [cite: 114]
          ),
        ],
      ),
    ); // [cite: 115]
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url)))
      throw 'Could not launch $url'; // [cite: 116]
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  }); // [cite: 117]

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
            fontSize: 14, // [cite: 118]
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold, // [cite: 119]
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Container(width: 80, height: 3, color: const Color(0xFFFFCB05)),
      ],
    ); // [cite: 120]
  }
}
