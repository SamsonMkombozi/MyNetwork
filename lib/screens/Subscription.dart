import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'model/PlanModal.dart';

class DemoChoosePlanScreen3 extends StatefulWidget {
  @override
  DemoChoosePlanScreen3State createState() => DemoChoosePlanScreen3State();
}

class DemoChoosePlanScreen3State extends State<DemoChoosePlanScreen3> {
  List<PlanModal> planList = [];
  PageController controller =
      PageController(initialPage: 0, viewportFraction: 0.85);
  int selectedIndex = 0;
  int pageIndex = 0;
  Color blueButtonAndTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    planList.add(
      PlanModal(
        image: 'lib/Assets/ThirdScreen1.png',
        title: 'Habari Starter',
        subTitle: 'A Simplest Start to everyone',
        price: '165,000 TZS',
        planPriceSubTitle: 'Dedicated Bandwidth',
        optionList: [
          PlanModal(title: 'Before daily volume limit - 5Mbps\n'),
          PlanModal(title: 'Daily volume Limit - 3GB\n'),
          PlanModal(title: 'After Daily volume limit - 3Mbps\n'),
        ],
      ),
    );
    planList.add(
      PlanModal(
        image: 'lib/Assets/ThirdScreen2.png',
        title: 'Pro Starter',
        subTitle: 'For Small and medium business',
        price: '250,000 TZS',
        planPriceSubTitle: 'Dedicated Bandwidth',
        optionList: [
          PlanModal(title: 'Before daily volume limit - 7Mbps\n'),
          PlanModal(title: 'Daily volume Limit - 5GB\n'),
          PlanModal(title: 'After Daily volume limit - 4Mbps\n'),
        ],
        isVisible: true,
      ),
    );
    planList.add(
      PlanModal(
        image: 'lib/Assets/ThirdScreen3.png',
        title: 'Habari Lite',
        subTitle: 'Solution for big organization',
        price: '415,000 TZS',
        planPriceSubTitle: 'Dedicated Bandwidth',
        optionList: [
          PlanModal(title: 'Before daily volume limit - 10Mbps\n'),
          PlanModal(title: 'Daily volume Limit - 8GB\n'),
          PlanModal(title: 'After Daily volume limit - 7Mbps\n'),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // appBar: AppBar(
  //     // title: Center(child: Text('Subscriptions')),
  //     leading: Transform.scale(
  //         scale:
  //             2.5, // Adjust this value to increase or decrease the icon size
  //         child: Padding(
  //           padding: EdgeInsets.only(left: 13),
  //           child: IconButton(
  //             onPressed: () {
  //               // Handle back button press here
  //               Navigator.of(context).pop();
  //             },
  //             icon: Icon(Icons.arrow_back),
  //           ),
  //         )),
  //     toolbarHeight: 130,
  //     backgroundColor: Color.fromARGB(255, 218, 32, 40),
  //   ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Subscription Plans',
        textColor: Colors.white,
        center: true,
        color: Color.fromARGB(255, 218, 32, 40),
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: Container(
        height: context.height(),
        width: context.width(),
        child: PageView.builder(
          controller: controller,
          itemCount: planList.length,
          onPageChanged: (index) {
            pageIndex = index;
            setState(() {});
          },
          itemBuilder: (_, int index) {
            bool isPageIndex = selectedIndex == index;

            return AnimatedContainer(
              margin: EdgeInsets.symmetric(
                  vertical: pageIndex == index ? 16 : 50, horizontal: 8),
              height: pageIndex == index ? 0.5 : 0.45,
              width: context.width(),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: defaultBoxShadow(),
              ),
              duration: 1000.milliseconds,
              curve: Curves.linearToEaseOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    planList[index].image.validate(),
                    fit: BoxFit.cover,
                    height: 190,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(planList[index].title.validate(),
                            style: boldTextStyle(size: 30)),
                        Text(planList[index].subTitle.validate(),
                            style: secondaryTextStyle()),
                        24.height,
                        Text(planList[index].price.validate(),
                            style: boldTextStyle(
                                size: 45, color: blueButtonAndTextColor)),
                        Text(planList[index].planPriceSubTitle.validate(),
                            style: secondaryTextStyle()),
                        24.height,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: UL(
                            symbolType: SymbolType.Bullet,
                            symbolColor: Colors.black,
                            spacing: 24,
                            children: List.generate(
                              planList[index].optionList!.length,
                              (i) => Text(
                                planList[index].optionList![i].title.validate(),
                                style: boldTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).expand(),
                  AppButton(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: context.width() - 120,
                    child: TextIcon(
                      prefix: isPageIndex
                          ? Icon(Icons.check,
                              color:
                                  selectedIndex == index ? Colors.green : null,
                              size: 16)
                          : null,
                      text: isPageIndex ? ' Your current plan' : 'Upgrade',
                      textStyle: boldTextStyle(
                          size: 18, color: isPageIndex ? Colors.green : white),
                    ),
                    onTap: () {
                      setState(() {});
                      selectedIndex = index;
                    },
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultRadius)),
                    color: isPageIndex
                        ? Colors.green.shade100
                        : blueButtonAndTextColor,
                  ).paddingBottom(16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
