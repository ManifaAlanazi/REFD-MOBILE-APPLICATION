import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';

class GuidLinesScreen extends StatefulWidget {
  const GuidLinesScreen({super.key});

  @override
  State<GuidLinesScreen> createState() => _GuidLinesScreenState();
}

class _GuidLinesScreenState extends State<GuidLinesScreen> {
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
          AppLocalizations.of(context)!.guidLines,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "You can browse all event categories, find Active Events, Future Events and Complete Events You must been logined to can join us in events All event opportunities sort by date and can do their filter by some criteria through Specializations, Date, Gender etc.. You can view the opportunity details like Dates, Times, Target Gender ... etc",
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
