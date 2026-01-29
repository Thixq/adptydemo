import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adptydemo/service_and_managers/adapty_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<Adapty>(),
  MockSpec<AdaptyProfile>(),
  MockSpec<AdaptyAccessLevel>(),
])
import 'adapty_service_test.mocks.dart';

void main() {
  late MockAdapty mockAdapty;
  late AdaptyService adaptyService;

  setUp(() {
    mockAdapty = MockAdapty();
    adaptyService = AdaptyService(adapty: mockAdapty);
  });

  group('AdaptyService Tests', () {
    test(
      'isPremium should be false by default before initialize is called',
      () {
        // 1. Arrange
        // setUp block creates service:
        // adaptyService = AdaptyService(adapty: mockAdapty);

        // 2. Act
        // No action taken, checking initial state.

        // 3. Assert
        expect(
          adaptyService.isPremium.value,
          isFalse,
          reason:
              'Premium access should be disabled when service first initializes.',
        );
      },
    );

    test('Initialization activates Adapty and sets log level', () async {
      // Arrange
      const apiKey = 'test_api_key';
      when(
        mockAdapty.activate(configuration: anyNamed('configuration')),
      ).thenAnswer((_) async {});
      when(mockAdapty.setLogLevel(any)).thenAnswer((_) async {});
      when(
        mockAdapty.getProfile(),
      ).thenThrow(const AdaptyError('Profile error', 0, null));
      when(
        mockAdapty.didUpdateProfileStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act
      await adaptyService.initialize(apiKey: apiKey);

      // Assert
      verify(
        mockAdapty.activate(configuration: anyNamed('configuration')),
      ).called(1);
      verify(mockAdapty.setLogLevel(any)).called(1);
    });

    test('isPremium should be false when accessLevels is empty', () async {
      // 1. Arrange: Mock a profile returning an empty accessLevels map
      final mockProfile = MockAdaptyProfile();
      when(mockProfile.accessLevels).thenReturn({}); // Empty map {}

      when(mockAdapty.getProfile()).thenAnswer((_) async => mockProfile);
      when(
        mockAdapty.didUpdateProfileStream,
      ).thenAnswer((_) => const Stream.empty());

      // 2. Act
      await adaptyService.initialize(apiKey: 'test_key');

      // 3. Assert
      expect(
        adaptyService.isPremium.value,
        isFalse,
        reason: 'Access should be denied if no premium key exists.',
      );
    });

    test(
      'should deactivate premium if new profile data does not contain premium key',
      () async {
        // 1. Arrange: Manually set service to "true" (independent of other tests)
        // Note: isPremium is final, so we modify its value.
        adaptyService.isPremium.value = true;

        final mockProfile = MockAdaptyProfile();
        when(mockProfile.accessLevels).thenReturn({
          'gold_member':
              MockAdaptyAccessLevel(), // Has another key but not 'premium'
        });

        when(mockAdapty.getProfile()).thenAnswer((_) async => mockProfile);
        when(
          mockAdapty.didUpdateProfileStream,
        ).thenAnswer((_) => const Stream.empty());

        // 2. Act
        await adaptyService.initialize(apiKey: 'test_key');

        // 3. Assert: The value that was true should now be false
        expect(
          adaptyService.isPremium.value,
          isFalse,
          reason:
              'Status should be false if premium key is missing in new data.',
        );
      },
    );

    test(
      'updates isPremium when profile fetch shows active premium access',
      () async {
        // Arrange
        final mockProfile = MockAdaptyProfile();
        final mockAccessLevel = MockAdaptyAccessLevel();

        when(mockAccessLevel.isActive).thenReturn(true);
        when(mockProfile.accessLevels).thenReturn({'premium': mockAccessLevel});
        when(mockAdapty.getProfile()).thenAnswer((_) async => mockProfile);
        when(
          mockAdapty.didUpdateProfileStream,
        ).thenAnswer((_) => const Stream.empty());

        // Act
        await adaptyService.initialize(apiKey: 'key');

        // Assert
        expect(adaptyService.isPremium.value, isTrue);
      },
    );

    test(
      'updates isPremium when profile fetch shows inactive premium access',
      () async {
        // Arrange
        final mockProfile = MockAdaptyProfile();
        final mockAccessLevel = MockAdaptyAccessLevel();

        when(mockAccessLevel.isActive).thenReturn(false);
        when(mockProfile.accessLevels).thenReturn({'premium': mockAccessLevel});
        when(mockAdapty.getProfile()).thenAnswer((_) async => mockProfile);
        when(
          mockAdapty.didUpdateProfileStream,
        ).thenAnswer((_) => const Stream.empty());

        // Act
        await adaptyService.initialize(apiKey: 'key');

        // Assert
        expect(adaptyService.isPremium.value, isFalse);
      },
    );

    test('handles stream updates correctly', () async {
      // Arrange
      final mockProfile = MockAdaptyProfile();
      final mockAccessLevel = MockAdaptyAccessLevel();

      when(mockAccessLevel.isActive).thenReturn(true);
      when(mockProfile.accessLevels).thenReturn({'premium': mockAccessLevel});

      // Initial profile fetch fails to avoid interference
      when(
        mockAdapty.getProfile(),
      ).thenThrow(const AdaptyError('error', 0, null));

      when(
        mockAdapty.didUpdateProfileStream,
      ).thenAnswer((_) => Stream.value(mockProfile));

      // Act
      await adaptyService.initialize(apiKey: 'key');

      // Wait for stream to emit
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(adaptyService.isPremium.value, isTrue);
    });

    test('handles errors gracefully during initialization', () async {
      // Arrange
      when(
        mockAdapty.activate(configuration: anyNamed('configuration')),
      ).thenThrow(const AdaptyError('Init failed', 1, null));

      // Act & Assert
      // Should not throw
      await expectLater(
        adaptyService.initialize(apiKey: 'key'),
        completes,
      );
    });
  });

  test(
    'cancels previous stream subscription when initialize is called a second time',
    () async {
      // 1. Arrange
      // Create two separate controllers to track which one is being listened to.
      final controller1 = StreamController<AdaptyProfile>();
      final controller2 = StreamController<AdaptyProfile>();

      // Provide controller1's stream for the first call.
      when(
        mockAdapty.didUpdateProfileStream,
      ).thenAnswer((_) => controller1.stream);
      when(
        mockAdapty.getProfile(),
      ).thenAnswer((_) async => MockAdaptyProfile());
      when(
        mockAdapty.activate(configuration: anyNamed('configuration')),
      ).thenAnswer((_) async {});

      // 2. Act - First Call
      await adaptyService.initialize(apiKey: 'test_key');

      // Validation: controller1 should be listened to now.
      expect(
        controller1.hasListener,
        isTrue,
        reason: 'Should have listener after first init',
      );

      // 3. Act - Second Call
      // Now return controller2 when didUpdateProfileStream is called.
      when(
        mockAdapty.didUpdateProfileStream,
      ).thenAnswer((_) => controller2.stream);

      await adaptyService.initialize(apiKey: 'test_key');

      // 4. Assert
      // If `await _profileSubscription?.cancel();` inside the code worked,
      // controller1 should no longer have a listener.
      expect(
        controller1.hasListener,
        isFalse,
        reason: 'Previous subscription should be cancelled after second init',
      );
      expect(
        controller2.hasListener,
        isTrue,
        reason: 'New subscription should be active',
      );

      // Cleanup
      await controller1.close();
      await controller2.close();
    },
  );
}
