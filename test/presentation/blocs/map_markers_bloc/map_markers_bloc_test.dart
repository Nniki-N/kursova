import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/domain/entities/location_marker.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_bloc.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_event.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

void main() {
  group(
    'MapMarkersBloc ->',
    () {
      late MapMarkersBloc mapMarkersBloc;
      late LatLng mockLatLng;
      late LocationMarker mockLocationMarker;

      setUp(() {
        mapMarkersBloc = MapMarkersBloc(
          logger: Logger(),
        );

        mockLatLng = const LatLng(48.136691343766316, 11.577186091868162);
        mockLocationMarker = LocationMarker(coordinate: mockLatLng);
      });

      tearDown(() async {
        await mapMarkersBloc.close();
      });

      test('initial state is MapMarkersEmpty', () {
        expect(mapMarkersBloc.state, isA<MapMarkersEmpty>());
      });

      group(
        'MapMarkersAddMakerRequested',
        () {
          blocTest<MapMarkersBloc, MapMarkersState>(
            'should emit MapMarkersAddMakerRequested with one added marker to locationMarkers',
            build: () => mapMarkersBloc,
            act: (bloc) => bloc.add(
              MapMarkersAddMakerRequested(latLng: mockLatLng),
            ),
            expect: () => [
              isA<MapMarkersNotEmpty>().having(
                (state) => state.locationMarkers.length,
                'locationMarkers is not empty',
                equals(1),
              ),
            ],
          );

          blocTest<MapMarkersBloc, MapMarkersState>(
            'should emit MapMarkersReachedMarkersLimit when markers count reached limit and new marker can not be added',
            build: () => mapMarkersBloc,
            seed: () => MapMarkersNotEmpty(
              locationMarkers: List.filled(
                AppConstants.locationsLimit,
                mockLocationMarker,
              ),
            ),
            act: (bloc) => bloc.add(
              MapMarkersAddMakerRequested(latLng: mockLatLng),
            ),
            expect: () => [isA<MapMarkersReachedMarkersLimit>()],
          );

          blocTest<MapMarkersBloc, MapMarkersState>(
            'should emit MapMarkersReachedMarkersLimit when markers count is over limit and removes last markers from the list',
            build: () => mapMarkersBloc,
            seed: () => MapMarkersNotEmpty(
              locationMarkers: List.filled(
                AppConstants.locationsLimit + 5,
                mockLocationMarker,
              ),
            ),
            act: (bloc) => bloc.add(
              MapMarkersAddMakerRequested(latLng: mockLatLng),
            ),
            expect: () => [
              isA<MapMarkersReachedMarkersLimit>().having(
                (state) => state.locationMarkers.length,
                'locationMarkers length is AppConstants.locationsLimit',
                equals(AppConstants.locationsLimit),
              ),
            ],
          );
        },
      );

      group(
        'MapMarkersReplaceMarkersRequested',
        () {
          blocTest<MapMarkersBloc, MapMarkersState>(
            'should emit MapMarkersNotEmpty with markers from provided coordinates',
            build: () => mapMarkersBloc,
            act: (bloc) => bloc.add(
              MapMarkersReplaceMarkersRequested(
                coordinatesList: List.filled(1, mockLatLng),
              ),
            ),
            expect: () => [
              isA<MapMarkersNotEmpty>().having(
                (state) => state.locationMarkers.first.coordinate,
                'first marker has the same coordinate that was provided',
                equals(mockLatLng),
              ),
            ],
          );
        },
      );

      group(
        'MapMarkersClearMarkersRequested',
        () {
          blocTest<MapMarkersBloc, MapMarkersState>(
            'should emit MapMarkersEmpty',
            build: () => mapMarkersBloc,
            act: (bloc) => bloc.add(
              const MapMarkersClearMarkersRequested(),
            ),
            expect: () => [isA<MapMarkersEmpty>()],
          );
        },
      );
    },
  );
}
