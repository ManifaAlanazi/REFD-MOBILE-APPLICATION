import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';

class RequestLoadingWidget extends StatelessWidget {
  const RequestLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 5.0,
            ),
            const SizedBox(
              height: 50,
              child: CommonLoaderWidget(),
            ),
            const SizedBox(
              width: 25.0,
            ),
            Text(AppLocalizations.of(context)!.loading)
          ],
        ),
      ),
    );
  }
}
