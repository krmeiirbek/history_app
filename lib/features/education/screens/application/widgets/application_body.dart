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
                'Қолданба авторы: Молдадосова Алтынай Кайыповна',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: const Image(
                      image: AssetImage(TImages.author),
                      height: 140,
                    ),
                  ),
                  const SizedBox(width: 8), // Add space between image and text
                  Expanded(
                    child: Text(
                      "Түркістан облысына қарасты «Жетісай ауданының мамандандырылған «Дарын» мектеп-интернатының» тарих пәні мұғалімі, педагог-шебер.  «Үздік педагог» -2020 конкурсының жеңімпазы, 2020 жылы Президент Қ.К.Тоқаевтың  Жарлығымен « Ерен Еңбегі үшін» медалімен наградталған.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                "Қолданба туралы",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                  width: 320,
                  child: Text(
                    """«Tarih Time» бағдарламасы – Қазақстан тарихы, Дүниежүзі тарихы және Құқық негіздері пәндері бойынша Ұлттық бірыңғай тестілеуге дайындалуға арналған. Сонымен қатар орта білім беру саласындағы ұйымдастырылатын түрлі деңгейдегі олимпиадалар мен конкурстарға дайындалуға таптырмас құрал.
Бағдарламаның артықшылығы Қазақстан тарихы және Дүниежүзі тарихы курсы 5 сыныптан бастап 11 сыныпқа дейінгі барлық тақырыптар қамтылса, Құқық негіздері пәні 9-11 сыныптардың барлық тақырыптары қамтылған.
Бағдарламаның тиімділігі – оқушы көрсетілген оқулық бойынша тақты тақырыпты оқып,  сол тақырып бойынша тест тапсырмасын осы бағдарламада тапсыруына болады. Тест тапсырмалары мәнмәтіндік, сәйкестендіру, хронологиялық реттілік түрінде,  түрлі деңгейде жасалған.
Сәттілік!""",
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
