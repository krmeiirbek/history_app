import 'package:flutter/material.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ApplicationBody extends StatelessWidget {
  const ApplicationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Қолданба авторы:  Молдадосова Алтынай',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: const Image(
                      image: AssetImage(TImages.author),
                      height: 150,
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                      width: 140,
                      child: Text(
                        "Қазір Жетісай қаласындағы «Дарын» мектеп-интернатында қызмет етеді. 2023ж ол «TARIH TIME» қосымшасын жасады.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                "Қолданба туралы ақпарат",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                  width: 320,
                  child: Text(
                    "Біздің қосымшамызбен білімініздің жаңа деңгейіне барыңыз "
                    "— қарапайымдылық пен терең байытудың керемет үйлесімі. Ойландыратын сынақтар "
                    "арқылы ойыңызды тартыңыз, әртүрлі нұсқалардағы бай білім түрлерін зерттеңіз"
                    " және сенімді қателерді түзету арқылы білім беру зерттеулеріңізді оңай шарлаңыз."
                    " Прагматикалық философияны басшылыққа ала отырып, әр функция ұсақ-түйекке дейін ойластырылып,"
                    " түсінудің мақсатты және тегіс ізденісін қамтамасыз етеді. Біздің қолданба құрал емес!"
                    " ол оқытудың мәнін ұстанатын сенімді серіктеске айналады"
                    " - бұл сіздің ойынызды кеңейтіп қана қоймай, сонымен қатар"
                    " әр қадам мағыналы өсу мен байыту мүмкіндігі болып табылатын қызықты білім беру қолданбасының құрылымдық тәжірибе.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
