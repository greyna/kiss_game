library main_webtest;

import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';
import 'dart:html';
import '../main.dart' as webapp;

void main()
{
  useHtmlEnhancedConfiguration();
  webapp.main();
  
  Element h1;
  Element container;
  
  group('Testing html entry', ()
  {
    setUp(() {
      h1 = querySelector("h1");
      container = querySelector("#canvas_container");
    });
    
    tearDown(() {
      
    });
    
    test('canvasContainer is empty', () {
      expect(container.text, isEmpty);
    });

    test('canvasContainer contains "hello world" after click() on h1', () {
      h1.click();
      expect(container.text, "Kiss game hellooooooooooo world");
    });
    
  });
}

// replace test or group by solo_test or solo_group to run only this one
// replace test or group by skip_test or skip_group to do not run only this one
// can use filterTests(regexp | predicate | string) to filter by test name