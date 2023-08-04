// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(
          const Duration(seconds: 1),
        ),
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                // borderRadius: kAppbarCircularBorder,
                // color: Colors.red[100],
                ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 25,
                      child: FittedBox(
                        child: Text(
                          DateFormat.yMd().format(DateTime.now()).toString(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/logo2.png',
                      // width: 50,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // // Spacer(),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        DateFormat.Hms().format(
                          DateTime.now(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
