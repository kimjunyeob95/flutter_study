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

  bool coolcheckDone = false;

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
                      if (distance <= okDistance) {
                        // 현재 위치와 회사와의 거리가 100M이내에 있는지 분기
                        isWithinRange = true;
                      }
                    }

                    return Column(
                      children: [
                        _renderGoogleMap(
                            initialPosition: initialPosition,
                            circle: coolcheckDone
                                ? doneWithinDistanceCircle
                                : isWithinRange
                                    ? withinDistanceCircle
                                    : notWithinDistanceCircle,
                            marker: marker),
                        _renderCoolguen(
                            isWithinRange: isWithinRange,
                            onCheckPressed: onCheckPressed,
                            coolcheckDone: coolcheckDone)
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

  void onCheckPressed() async {
    final bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("출근하기"),
            content: const Text("출근을 하시겠습니까?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('닫기')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('출근'))
            ],
          );
        });

    setState(() {
      coolcheckDone = result;
    });
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
  final bool isWithinRange;
  final VoidCallback onCheckPressed;
  final bool coolcheckDone;

  const _renderCoolguen(
      {required this.isWithinRange,
      required this.onCheckPressed,
      required this.coolcheckDone,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timelapse,
              size: 50.0,
              color: coolcheckDone ? Colors.green : isWithinRange ? Colors.blue : Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            if (isWithinRange && !coolcheckDone)
              TextButton(onPressed: onCheckPressed, child: const Text('출근'))
          ],
        ));
  }
}
