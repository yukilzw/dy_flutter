// import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/dy_index/focus/index.dart';


void main() {
  test('DY app unit test', () {

  });
  testWidgets('DY app Widgets test', (WidgetTester tester) async {

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Material(
              child: FocusPage(),
            ),
          );
        },
      ),
    );

  });
}
