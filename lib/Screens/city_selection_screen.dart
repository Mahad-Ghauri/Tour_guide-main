import 'package:flutter/material.dart';

class CitySelectionScreen extends StatelessWidget {
  const CitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Illustration
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background light shape
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    // Custom traveler illustration
                    const CustomPaint(
                      size: Size(180, 180),
                      painter: TravelerIllustrationPainter(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Heading
              const Text(
                'Select city to explore',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 24),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter location',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: Icon(Icons.mic, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Lorem ipsum text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Semper sed mattis vitae mattis aliquam delectus. Tempus semper dictumst arcu cursus eget cursus eget ipsum cursus eget vulputate.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Explore button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'EXPLORE CITY',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the traveler illustration
class TravelerIllustrationPainter extends CustomPainter {
  const TravelerIllustrationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;

    // Define colors
    final Color stripedShirtColor = Colors.teal;
    final Color pantsColor = Colors.black87;
    final Color skinColor = const Color(0xFFE0C2A2);
    final Color hairColor = Colors.black87;
    final Color suitcaseColor = Colors.teal.shade100;
    final Color phoneColor = Colors.blueAccent;

    // Draw suitcase
    final Paint suitcasePaint =
        Paint()
          ..color = suitcaseColor
          ..style = PaintingStyle.fill;

    final Paint suitcaseLinePaint =
        Paint()
          ..color = Colors.teal.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final RRect suitcaseBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 30, size.height - 70, 60, 70),
      const Radius.circular(5),
    );

    // Suitcase lines
    canvas.drawRRect(suitcaseBody, suitcasePaint);
    canvas.drawRRect(suitcaseBody, suitcaseLinePaint);

    // Suitcase horizontal lines
    canvas.drawLine(
      Offset(centerX - 30, size.height - 50),
      Offset(centerX + 30, size.height - 50),
      suitcaseLinePaint,
    );

    canvas.drawLine(
      Offset(centerX - 30, size.height - 30),
      Offset(centerX + 30, size.height - 30),
      suitcaseLinePaint,
    );

    // Draw legs
    final Paint legPaint =
        Paint()
          ..color = pantsColor
          ..style = PaintingStyle.fill;

    // Left leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 25, size.height - 105, 15, 45),
        const Radius.circular(5),
      ),
      legPaint,
    );

    // Right leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 10, size.height - 105, 15, 45),
        const Radius.circular(5),
      ),
      legPaint,
    );

    // Draw shoes
    final Paint shoePaint =
        Paint()
          ..color = Colors.teal
          ..style = PaintingStyle.fill;

    // Left shoe
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 35, size.height - 65, 25, 10),
        const Radius.circular(5),
      ),
      shoePaint,
    );

    // Right shoe
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 10, size.height - 65, 25, 10),
        const Radius.circular(5),
      ),
      shoePaint,
    );

    // Draw torso - striped shirt
    final stripedShirtRect = Rect.fromLTWH(
      centerX - 25,
      size.height - 155,
      50,
      50,
    );
    final Paint shirtBasePaint =
        Paint()
          ..color = stripedShirtColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(stripedShirtRect, const Radius.circular(15)),
      shirtBasePaint,
    );

    // Draw shirt stripes
    final Paint stripePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(centerX - 25, size.height - 150 + (i * 10)),
        Offset(centerX + 25, size.height - 150 + (i * 10)),
        stripePaint,
      );
    }

    // Draw arms
    // Left arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 45, size.height - 145, 20, 10),
        const Radius.circular(5),
      ),
      shirtBasePaint,
    );

    // Right arm holding phone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 25, size.height - 145, 20, 10),
        const Radius.circular(5),
      ),
      shirtBasePaint,
    );

    // Draw phone in hand
    final Paint phonePaint =
        Paint()
          ..color = phoneColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 25, size.height - 170, 15, 25),
        const Radius.circular(2),
      ),
      phonePaint,
    );

    // Phone screen
    final Paint phoneScreenPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX + 27, size.height - 167, 11, 19),
        const Radius.circular(1),
      ),
      phoneScreenPaint,
    );

    // Draw lightbulb idea icon on phone
    final Paint ideaPaint =
        Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX + 32.5, size.height - 162), 4, ideaPaint);

    // Draw neck
    final Paint skinPaint =
        Paint()
          ..color = skinColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(centerX - 5, size.height - 175, 10, 20),
        const Radius.circular(3),
      ),
      skinPaint,
    );

    // Draw head
    canvas.drawCircle(Offset(centerX, size.height - 195), 20, skinPaint);

    // Draw hair bun
    final Paint hairPaint =
        Paint()
          ..color = hairColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, size.height - 215), 12, hairPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Main app entry point
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
      ),
      home: const CitySelectionScreen(),
    );
  }
}
