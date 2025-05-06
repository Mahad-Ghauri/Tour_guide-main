// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tour_guide_application/Theme/chatbot_theme.dart';
// import 'package:tour_guide_application/Screens/Authentication%20Screens/profile_screen.dart';

// class HeaderComponent extends StatelessWidget {
//   const HeaderComponent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF559CB2), // Match logo screen background color
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(Icons.explore, color: AppColors.lightText),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     'Globe Guide!',
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.lightText,
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ProfileScreen()),
//                   );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(Icons.person, color: AppColors.lightText),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildSearchBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         style: GoogleFonts.poppins(),
//         decoration: InputDecoration(
//           hintText: "Where to go?",
//           hintStyle: GoogleFonts.poppins(color: AppColors.greyText),
//           prefixIcon: Icon(Icons.search, color: AppColors.primaryTeal),
//           suffixIcon: Icon(Icons.mic, color: AppColors.primaryTeal),
//           filled: true,
//           fillColor: AppColors.lightSurface,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/profile_screen.dart';

class HeaderComponent extends StatefulWidget {
  const HeaderComponent({super.key});

  @override
  State<HeaderComponent> createState() => _HeaderComponentState();
}

class _HeaderComponentState extends State<HeaderComponent> {
  String selectedCity = 'Loading...';
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController(text: selectedCity);
    fetchSelectedCity();
  }

  Future<void> fetchSelectedCity() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await supabase
            .from('cities')
            .select('name')
            .eq('user_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        setState(() {
          selectedCity = response != null && response['name'] != null
              ? response['name'] as String
              : 'No City Selected';
          cityController.text = selectedCity;
        });
      } catch (e) {
        print("Error fetching city: $e");
        setState(() {
          selectedCity = 'No City Selected';
          cityController.text = selectedCity;
        });
      }
    } else {
      setState(() {
        selectedCity = 'No City Selected';
        cityController.text = selectedCity;
      });
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF559CB2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.explore, color: AppColors.lightText),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Globe Guide!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person, color: AppColors.lightText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCityBox(),
        ],
      ),
    );
  }

  Widget _buildCityBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: cityController,
        readOnly: true,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_city, color: AppColors.primaryTeal),
          filled: true,
          fillColor: AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
