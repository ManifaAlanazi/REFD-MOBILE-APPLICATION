import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {

  List<dynamic> faqs = [
    {
      "question": "1. هل أستطيع أن أقدم مبادرة في خدمة المجتمع ؟",
      "answer": "نعم",
    },
    {
      "question": "2. هل أستطيع أن أكون متطوع خارج الجامعة ؟",
      "answer": "نعم يمكن ذلك في حال كانت المبادرة تقدم خارج الجامعة",
    },
    {
      "question": "3. هل تحتسب ساعاتي التطوعية ؟",
      "answer": "نعم تحتسب الساعات التطوعية",
    },
    {
      "question": "4. هل الخدمات التطوعية التي تقدم فترة صباحية أم مسائية؟",
      "answer": "يوجد خدمات تطوعية تقدم فترة مسائية وأخرى صباحية",
    },
    {
      "question": "5. هل أستطيع أن أستفيد من الدورات المقدمة للمتطوعين داخل الجامعة ، أم إلزامي أن أكون مسجل كمتطوع لحضورها؟",
      "answer": "يمكن لجميع منسوبي الجامعة الالتحاق بالدورات المقدمه في حال التسجيل وتوفر مقاعد شاغرة",
    },
    {
      "question": "6.هل اقتراح المبادرات التطوعية قاصر على الدكاترة فقط؟",
      "answer": "لا ،،فاقتراح المبادرات التطوعية متاح للجميع",
    },
    {
      "question": "7. إذا كنت من ذوي الاحتياجات الخاصة هل يمكنني التسجيل كمتطوع؟",
      "answer": "نعم يمكن للجميع أن يسجل",
    },
    {
      "question": "8. أنا من ذوي الاحتياجات الخاصة هل يمكنني اقتراح مبادرات تطوعية موجهة لذوي الاحتياجات الخاصة؟",
      "answer": "نعم يمكن تقديم أي مبادرة مجتمعية لأي فئة من فئات المجتمع",
    },
  ];

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
          AppLocalizations.of(context)!.faq,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            backgroundColor: AppColors.greyColor.withOpacity(0.1),
            title: Text(faqs[index]['question'],style: const TextStyle(
              fontSize: 14,
            ),),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  faqs[index]['answer'],
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
