import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.termsAndConditions,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "This charter aims to clarify the controls, obligations, values ​​and principles that contribute to achieving the goals of the Kingdom’s Vision 2030 to reach one million volunteers, and defines the requirements assigned to volunteers and their duties, and preserves their rights during the practice of volunteer work. Commitment to the ethical charter facilitates and helps all parties involved in volunteer work to Performing their tasks with high quality and efficiency. Through their commitment to the following elements",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "1. Feeling the responsibility of the great work he is doing before God Almighty, before his community, and before the university administration that he represents.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "2. Commitment to polite and positive behavior toward fellow volunteers and cooperating with them to achieve the goals of volunteer work.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "3. Commitment to performing duty and carrying out the tasks required of officials with accuracy and mastery.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "4. High moral dealing with beneficiaries of volunteer services, taking into account their health and psychological conditions, and seeking reward from God Almighty for that.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "5. Taking into account the rights of beneficiaries of volunteer services and maintaining the confidentiality of their information and private cases.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "Volunteer rights Volunteers are people who give their time and effort to benefit people and provide services to them.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "1. Treat volunteers with respect and give them confidence to carry out the tasks required of them.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "2. Training volunteers and qualifying them to perform their work with high professionalism and professionalism.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "3. Providing direct support to them and solving the problems they encounter during their work.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "4. Maintaining the confidentiality of their private data and information.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "5. Giving volunteers a certificate proving their participation in volunteer work and documenting their achievements.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "6. Record volunteer hours in the student activities document.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),

              Text(
                "7. Celebrating, honoring and praising volunteers.",
                textAlign: TextAlign.start,
              ),

              /// Space
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
