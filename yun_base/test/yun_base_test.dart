import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yun_base/yun_base.dart';

void main() {
  const MethodChannel channel = MethodChannel('yun_base');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await YunBase.platformVersion, '42');
  });
}
