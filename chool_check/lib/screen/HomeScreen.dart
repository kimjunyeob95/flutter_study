import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng companyLatLng = LatLng(37.5284, 127.1392);
  static const CameraPosition initialPosition =
      CameraPosition(target: companyLatLng, zoom: 15);

  static const double okDistance = 100;
  static final Circle withinDistanceCircle = Circle(
      circleId: const CircleId("withinDistanceCircle"),
      center: companyLatLng,
      fillColor: Colors.blue.withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.blue,
      radius: okDistance);
  static final Circle notWithinDistanceCircle = Circle(
      circleId: const CircleId("notWithinDistanceCircle"),
      center: companyLatLng,
      fillColor: Colors.red.withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.red,
      radius: okDistance);
  static final Circle doneWithinDistanceCircle = Circle(
      circleId: const CircleId("doneWithinDistanceCircle"),
      center: companyLatLng,
      fillColor: Colors.green.withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.green,
      radius: okDistance);
  static const Marker marker =
      Marker(markerId: MarkerId('marker'), position: companyLatLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar(),
        body: FutureBuilder(
          future: checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 로딩 상태
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // 위치 권한 허용
            if (snapshot.data == "위치 권한이 허가되었습니다.") {
              return StreamBuilder<Position>(
                  stream: Geolocator.getPositionStream(),
                  builder: (context, snapshot) {
                    bool isWithinRange = false;

                    if (snapshot.hasData) {
                      final start = snapshot.data!;
                      final end = companyLatLng!;

                      final distance = Geolocator.distanceBetween(
                          start.latitude,
                          start.longitude,
                          end.latitude,
                          end.longitude);

                      if (distance <= okDistance){
                        // 현재 위치와 회사와의 거리가 100M이내에 있는지 분기
                        isWithinRange = true;
                      }
                    }

                    return Column(
                      children: [
                        _renderGoogleMap(
                            initialPosition: initialPosition,
                            circle: isWithinRange ? withinDistanceCircle: notWithinDistanceCircle,
                            marker: marker),
                        const _renderCoolguen()
                      ],
                    );
                  });
            }

            return Center(
              child: Text(snapshot.data),
            );
          },
        ));
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return "위치 서비스를 허용해주세요.";
    }
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return "위치 서비스를 허용해주세요.";
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return "앱 설정에서 직접 위치 서비스를 허용해주세요.";
    }

    return "위치 권한이 허가되었습니다.";
  }

  AppBar renderAppbar() {
    return AppBar(
      title: const Center(
        child: Text(
          "오늘도 출근",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _renderGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;

  const _renderGoogleMap(
      {required this.circle,
      required this.marker,
      required this.initialPosition,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
      ),
    );
  }
}

class _renderCoolguen extends StatelessWidget {
  const _renderCoolguen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(flex: 1, child: Text('출근'));
  }
}
