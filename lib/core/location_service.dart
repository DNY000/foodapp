import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có được bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Hiển thị dialog yêu cầu bật dịch vụ vị trí
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Dịch vụ vị trí bị tắt'),
              content: const Text(
                'Để tìm nhà hàng gần bạn, vui lòng bật dịch vụ vị trí trong cài đặt thiết bị.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Mở Cài đặt'),
                  onPressed: () => Geolocator.openLocationSettings(),
                ),
              ],
            );
          },
        );
      }
      return null;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quyền truy cập vị trí bị từ chối'),
            ),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Quyền truy cập vị trí bị chặn'),
              content: const Text(
                'Bạn đã chặn quyền truy cập vị trí. Vui lòng vào cài đặt để cho phép ứng dụng truy cập vị trí.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Mở Cài đặt'),
                  onPressed: () => Geolocator.openAppSettings(),
                ),
              ],
            );
          },
        );
      }
      return null;
    }

    // Nếu mọi thứ OK, lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition();
  }

  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
