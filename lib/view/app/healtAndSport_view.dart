import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';

class HealtAndSportView extends StatelessWidget {
  const HealtAndSportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrakyaColors.background,
      appBar: trakyaAppBar(context, "Trakya Kampüs 4.0", [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 27, color: Colors.white),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 22, bottom: 4),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sağlık Kültür Spor ',
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        color: TrakyaColors.negative,
                      ),
                    ),
                    TextSpan(
                      text: '(1)',
                      style: TextStyle(
                        fontSize: 16,
                        color: TrakyaColors.negative,
                      ), // Küçük ve soluk renkli
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),

                      padding: EdgeInsets.all(14),

                      child: Column(
                        spacing: 5,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Topluluklar",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: TrakyaColors.primary,
                                ),
                              ),
                              Text(
                                "(2)",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: TrakyaColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: TrakyaColors.primary),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200],
                            ),

                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                top: 0,
                                bottom: 10,
                                left: 12,
                                right: 12,
                              ),
                              title: Text(
                                "Katıldığım Topluluklar",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: TrakyaColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                Icons.fact_check_sharp,

                                color: TrakyaColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200],
                            ),

                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                top: 0,
                                bottom: 10,
                                left: 12,
                                right: 12,
                              ),
                              title: Text(
                                "Katıldığım Topluluklar",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: TrakyaColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                Icons.fact_check_sharp,

                                color: TrakyaColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
