import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SampleData {
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'id': '1',
        'name': 'Phở',
        'image': 'assets/images/pho.jpg',
        'icon': 'bowl_food',
        'description': 'Phở Việt Nam truyền thống',
        'isActive': true,
        'sortOrder': 1,
      },
      {
        'id': '2',
        'name': 'Cơm',
        'image': 'assets/images/com.jpg',
        'icon': 'rice_bowl',
        'description': 'Cơm Việt Nam',
        'isActive': true,
        'sortOrder': 2,
      },
      {
        'id': '3',
        'name': 'Bún',
        'image': 'assets/images/bun.jpg',
        'icon': 'noodles',
        'description': 'Các món bún',
        'isActive': true,
        'sortOrder': 3,
      }
    ];
  }

  static List<Map<String, dynamic>> getRestaurants() {
    // Tạo các timestamp cho giờ mở cửa và đóng cửa
    final today = DateTime.now();

    return [
      {
        'id': '1',
        'name': 'Phở Hà Nội',
        'description': 'Phở ngon truyền thống Hà Nội',
        'address': '123 Đường Lê Lợi, Quận 1, TP.HCM',
        'location': {'latitude': 10.762622, 'longitude': 106.660172},
        'openTime': '06:00',
        'closeTime': '22:00',
        'openTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 6, 0)),
        'closeTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 22, 0)),
        'rating': 4.5,
        'categories': ['1'],
        'images': [
          'assets/images/restaurant1.jpg',
          'assets/images/restaurant1_2.jpg'
        ],
        'status': 'open',
        'deliveryFee': 15000,
        'minOrderAmount': 50000,
      },
      {
        'id': '2',
        'name': 'Bún Bò Huế Thanh',
        'description': 'Bún bò Huế chuẩn vị',
        'address': '45 Nguyễn Thị Minh Khai, Quận 3, TP.HCM',
        'location': {'latitude': 10.779468, 'longitude': 106.698594},
        'openTime': '06:30',
        'closeTime': '21:00',
        'openTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 6, 30)),
        'closeTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 21, 0)),
        'rating': 4.3,
        'categories': ['3'],
        'images': [
          'assets/images/restaurant2.jpg',
          'assets/images/restaurant2_2.jpg'
        ],
        'status': 'open',
        'deliveryFee': 20000,
        'minOrderAmount': 45000,
      },
      {
        'id': '3',
        'name': 'Cơm Tấm Sài Gòn',
        'description': 'Cơm tấm sườn bì chả',
        'address': '78 Võ Văn Tần, Quận 3, TP.HCM',
        'location': {'latitude': 10.771683, 'longitude': 106.691802},
        'openTime': '07:00',
        'closeTime': '21:00',
        'openTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 7, 0)),
        'closeTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 21, 0)),
        'rating': 4.7,
        'categories': ['2'],
        'images': ['assets/images/restaurant3.jpg'],
        'status': 'open',
        'deliveryFee': 18000,
        'minOrderAmount': 40000,
      },
      {
        'id': '4',
        'name': 'Phở 24',
        'description': 'Phở ngon phục vụ 24/7',
        'address': '200 Nguyễn Thị Minh Khai, Quận 1, TP.HCM',
        'location': {'latitude': 10.773456, 'longitude': 106.685432},
        'openTime': '00:00',
        'closeTime': '24:00',
        'openTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 0, 0)),
        'closeTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 23, 59)),
        'rating': 4.2,
        'categories': ['1'],
        'images': ['assets/images/restaurant4.jpg'],
        'status': 'open',
        'deliveryFee': 25000,
        'minOrderAmount': 55000,
      },
      {
        'id': '5',
        'name': 'Bún Đậu Mắm Tôm',
        'description': 'Bún đậu mắm tôm chuẩn vị Hà Nội',
        'address': '156 Lý Tự Trọng, Quận 1, TP.HCM',
        'location': {'latitude': 10.768345, 'longitude': 106.693456},
        'openTime': '10:00',
        'closeTime': '21:00',
        'openTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 10, 0)),
        'closeTimeTimestamp': Timestamp.fromDate(
            DateTime(today.year, today.month, today.day, 21, 0)),
        'rating': 4.6,
        'categories': ['3'],
        'images': ['assets/images/restaurant5.jpg'],
        'status': 'open',
        'deliveryFee': 22000,
        'minOrderAmount': 100000,
      }
    ];
  }

  static List<Map<String, dynamic>> getFoods() {
    List<Map<String, dynamic>> foods = [];

    // 10 món phở
    final phoList = [
      {
        'id': 'pho1',
        'name': 'Phở Bò Tái',
        'description': 'Phở bò với thịt bò tái mềm',
        'price': 45000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_tai.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bánh phở', 'Thịt bò tái', 'Hành', 'Rau thơm'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [45000, 55000, 65000]
          }
        ],
      },
      {
        'id': 'pho2',
        'name': 'Phở Bò Nạm',
        'description': 'Phở với thịt bò nạm mềm',
        'price': 50000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_nam.jpg'],
        'restaurantId': '2',
        'ingredients': ['Bánh phở', 'Thịt bò nạm', 'Hành', 'Rau thơm'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [50000, 60000, 70000]
          }
        ],
      },
      {
        'id': 'pho3',
        'name': 'Phở Gà',
        'description': 'Phở với thịt gà ta',
        'price': 45000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_ga.jpg'],
        'restaurantId': '3',
        'ingredients': ['Bánh phở', 'Thịt gà', 'Hành', 'Rau thơm'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [45000, 55000, 65000]
          }
        ],
      },
      {
        'id': 'pho4',
        'name': 'Phở Bò Viên',
        'description': 'Phở với bò viên tươi',
        'price': 45000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_bo_vien.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bánh phở', 'Bò viên', 'Hành', 'Rau thơm'],
        'preparationTime': 8,
        'isAvailable': true,
        'rating': 4.2,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [45000, 55000, 65000]
          }
        ],
      },
      {
        'id': 'pho5',
        'name': 'Phở Tái Nạm Gầu',
        'description': 'Phở với thịt bò tái, nạm và gầu',
        'price': 60000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_tai_nam_gau.jpg'],
        'restaurantId': '2',
        'ingredients': [
          'Bánh phở',
          'Thịt bò tái',
          'Thịt bò nạm',
          'Thịt gầu',
          'Hành',
          'Rau thơm'
        ],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.6,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [60000, 70000, 80000]
          }
        ],
      },
      {
        'id': 'pho6',
        'name': 'Phở Gà Nấm',
        'description': 'Phở gà với nấm đông cô',
        'price': 50000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_ga_nam.jpg'],
        'restaurantId': '3',
        'ingredients': [
          'Bánh phở',
          'Thịt gà',
          'Nấm đông cô',
          'Hành',
          'Rau thơm'
        ],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [50000, 60000, 70000]
          }
        ],
      },
      {
        'id': 'pho7',
        'name': 'Phở Bò Sốt Vang',
        'description': 'Phở với thịt bò sốt vang đậm đà',
        'price': 65000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_bo_sot_vang.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bánh phở', 'Thịt bò sốt vang', 'Hành', 'Rau thơm'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.7,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [65000, 75000, 85000]
          }
        ],
      },
      {
        'id': 'pho8',
        'name': 'Phở Bò Kho',
        'description': 'Phở với bò kho truyền thống',
        'price': 60000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_bo_kho.jpg'],
        'restaurantId': '2',
        'ingredients': [
          'Bánh phở',
          'Thịt bò kho',
          'Cà rốt',
          'Hành',
          'Rau thơm'
        ],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [60000, 70000, 80000]
          }
        ],
      },
      {
        'id': 'pho9',
        'name': 'Phở Gà Quay',
        'description': 'Phở với thịt gà quay',
        'price': 55000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_ga_quay.jpg'],
        'restaurantId': '3',
        'ingredients': ['Bánh phở', 'Gà quay', 'Hành', 'Rau thơm'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [55000, 65000, 75000]
          }
        ],
      },
      {
        'id': 'pho10',
        'name': 'Phở Đặc Biệt',
        'description': 'Phở với đầy đủ các loại thịt bò',
        'price': 70000,
        'category': 'PHO',
        'images': ['assets/images/pho/pho_dac_biet.jpg'],
        'restaurantId': '1',
        'ingredients': [
          'Bánh phở',
          'Thịt bò tái',
          'Thịt bò nạm',
          'Gầu bò',
          'Bò viên',
          'Hành',
          'Rau thơm'
        ],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.8,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [70000, 80000, 90000]
          }
        ],
      }
    ];
    foods.addAll(phoList);

    // 10 món cơm rang
    final comRangList = [
      {
        'id': 'comrang1',
        'name': 'Cơm Rang Dương Châu',
        'description': 'Cơm rang với thịt xá xíu, tôm, trứng',
        'price': 55000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_duong_chau.jpg'],
        'restaurantId': '1',
        'ingredients': ['Cơm', 'Thịt xá xíu', 'Tôm', 'Trứng', 'Rau củ'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.6,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [55000, 65000]
          }
        ],
      },
      {
        'id': 'comrang2',
        'name': 'Cơm Rang Hải Sản',
        'description': 'Cơm rang với tôm, mực, cua',
        'price': 65000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_hai_san.jpg'],
        'restaurantId': '2',
        'ingredients': ['Cơm', 'Tôm', 'Mực', 'Cua', 'Rau củ'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [65000, 75000]
          }
        ],
      },
      {
        'id': 'comrang3',
        'name': 'Cơm Rang Gà',
        'description': 'Cơm rang với thịt gà',
        'price': 50000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_ga.jpg'],
        'restaurantId': '3',
        'ingredients': ['Cơm', 'Thịt gà', 'Trứng', 'Rau củ'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [50000, 60000]
          }
        ],
      },
      {
        'id': 'comrang4',
        'name': 'Cơm Rang Bò',
        'description': 'Cơm rang với thịt bò xào',
        'price': 60000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_bo.jpg'],
        'restaurantId': '1',
        'ingredients': ['Cơm', 'Thịt bò', 'Trứng', 'Rau củ'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [60000, 70000]
          }
        ],
      },
      {
        'id': 'comrang5',
        'name': 'Cơm Rang Kim Chi',
        'description': 'Cơm rang với kim chi và thịt heo',
        'price': 55000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_kim_chi.jpg'],
        'restaurantId': '2',
        'ingredients': ['Cơm', 'Kim chi', 'Thịt heo', 'Trứng'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [55000, 65000]
          }
        ],
      },
      {
        'id': 'comrang6',
        'name': 'Cơm Rang Cá Mặn',
        'description': 'Cơm rang với cá mặn',
        'price': 50000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_ca_man.jpg'],
        'restaurantId': '3',
        'ingredients': ['Cơm', 'Cá mặn', 'Trứng', 'Rau củ'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.2,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [50000, 60000]
          }
        ],
      },
      {
        'id': 'comrang7',
        'name': 'Cơm Rang Thập Cẩm',
        'description': 'Cơm rang với nhiều loại thịt và hải sản',
        'price': 70000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_thap_cam.jpg'],
        'restaurantId': '1',
        'ingredients': ['Cơm', 'Thịt heo', 'Tôm', 'Mực', 'Trứng', 'Rau củ'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.7,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [70000, 80000]
          }
        ],
      },
      {
        'id': 'comrang8',
        'name': 'Cơm Rang Cà Ri',
        'description': 'Cơm rang với bột cà ri và thịt gà',
        'price': 55000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_ca_ri.jpg'],
        'restaurantId': '2',
        'ingredients': ['Cơm', 'Thịt gà', 'Bột cà ri', 'Rau củ'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [55000, 65000]
          }
        ],
      },
      {
        'id': 'comrang9',
        'name': 'Cơm Rang Chay',
        'description': 'Cơm rang với các loại rau củ',
        'price': 45000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_chay.jpg'],
        'restaurantId': '3',
        'ingredients': ['Cơm', 'Nấm', 'Đậu hũ', 'Rau củ'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [45000, 55000]
          }
        ],
      },
      {
        'id': 'comrang10',
        'name': 'Cơm Rang Xúc Xích',
        'description': 'Cơm rang với xúc xích và trứng',
        'price': 50000,
        'category': 'COMRANG',
        'images': ['assets/images/com/com_rang_xuc_xich.jpg'],
        'restaurantId': '1',
        'ingredients': ['Cơm', 'Xúc xích', 'Trứng', 'Rau củ'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [50000, 60000]
          }
        ],
      }
    ];
    foods.addAll(comRangList);

    // 10 món bún
    final bunList = [
      {
        'id': 'bun1',
        'name': 'Bún Chả Hà Nội',
        'description': 'Bún với chả viên và thịt nướng',
        'price': 50000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_cha.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bún', 'Chả viên', 'Thịt nướng', 'Rau sống'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.7,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [50000, 60000]
          }
        ],
      },
      {
        'id': 'bun2',
        'name': 'Bún Đậu Mắm Tôm',
        'description': 'Bún với đậu rán và mắm tôm',
        'price': 65000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_dau.jpg'],
        'restaurantId': '2',
        'ingredients': ['Bún', 'Đậu rán', 'Chả cốm', 'Rau sống'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['1 người', '2 người'],
            'prices': [65000, 120000]
          }
        ],
      },
      {
        'id': 'bun3',
        'name': 'Bún Bò Huế',
        'description': 'Bún bò Huế truyền thống',
        'price': 55000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_bo_hue.jpg'],
        'restaurantId': '3',
        'ingredients': ['Bún', 'Thịt bò', 'Giò heo', 'Rau sống'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.6,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [55000, 65000, 75000]
          }
        ],
      },
      {
        'id': 'bun4',
        'name': 'Bún Riêu Cua',
        'description': 'Bún với riêu cua và đậu phụ',
        'price': 50000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_rieu.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bún', 'Riêu cua', 'Đậu phụ', 'Rau sống'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [50000, 60000, 70000]
          }
        ],
      },
      {
        'id': 'bun5',
        'name': 'Bún Cá',
        'description': 'Bún với cá rán và nước dùng',
        'price': 45000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_ca.jpg'],
        'restaurantId': '2',
        'ingredients': ['Bún', 'Cá rán', 'Rau sống'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [45000, 55000, 65000]
          }
        ],
      },
      {
        'id': 'bun6',
        'name': 'Bún Thịt Nướng',
        'description': 'Bún với thịt heo nướng',
        'price': 45000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_thit_nuong.jpg'],
        'restaurantId': '3',
        'ingredients': ['Bún', 'Thịt heo nướng', 'Rau sống'],
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [45000, 55000]
          }
        ],
      },
      {
        'id': 'bun7',
        'name': 'Bún Mọc',
        'description': 'Bún với giò mọc và nấm',
        'price': 50000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_moc.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bún', 'Giò mọc', 'Nấm', 'Rau sống'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.4,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [50000, 60000, 70000]
          }
        ],
      },
      {
        'id': 'bun8',
        'name': 'Bún Ốc',
        'description': 'Bún với ốc và nước dùng',
        'price': 55000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_oc.jpg'],
        'restaurantId': '2',
        'ingredients': ['Bún', 'Ốc', 'Rau sống'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.6,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [55000, 65000]
          }
        ],
      },
      {
        'id': 'bun9',
        'name': 'Bún Măng Vịt',
        'description': 'Bún với thịt vịt và măng tươi',
        'price': 60000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_mang_vit.jpg'],
        'restaurantId': '3',
        'ingredients': ['Bún', 'Thịt vịt', 'Măng tươi', 'Rau sống'],
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.5,
        'options': [
          {
            'name': 'Size',
            'options': ['Nhỏ', 'Vừa', 'Lớn'],
            'prices': [60000, 70000, 80000]
          }
        ],
      },
      {
        'id': 'bun10',
        'name': 'Bún Sườn Chua',
        'description': 'Bún với sườn nấu chua',
        'price': 55000,
        'category': 'BUN',
        'images': ['assets/images/bun/bun_suon_chua.jpg'],
        'restaurantId': '1',
        'ingredients': ['Bún', 'Sườn', 'Cà chua', 'Rau sống'],
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.3,
        'options': [
          {
            'name': 'Size',
            'options': ['Thường', 'Đặc biệt'],
            'prices': [55000, 65000]
          }
        ],
      }
    ];
    foods.addAll(bunList);

    return foods;
  }

  static List<Map<String, dynamic>> getAddresses() {
    return [
      {
        'id': '1',
        'userId': 'user1',
        'name': 'Nhà',
        'address': '123 Nguyễn Văn Cừ',
        'district': 'Quận 5',
        'city': 'TP.HCM',
        'phoneNumber': '0901234567',
        'location': {'latitude': 10.762622, 'longitude': 106.660172},
        'note': 'Gần trường đại học',
        'isDefault': true,
      },
      {
        'id': '2',
        'userId': 'user1',
        'name': 'Công ty',
        'address': '456 Lê Văn Việt',
        'district': 'Quận 9',
        'city': 'TP.HCM',
        'phoneNumber': '0901234567',
        'location': {'latitude': 10.841394, 'longitude': 106.790347},
        'note': 'Tòa nhà ABC, tầng 5',
        'isDefault': false,
      },
      {
        'id': '3',
        'userId': 'user2',
        'name': 'Nhà trọ',
        'address': '789 Lý Thường Kiệt',
        'district': 'Quận 10',
        'city': 'TP.HCM',
        'phoneNumber': '0909876543',
        'location': {'latitude': 10.770912, 'longitude': 106.666039},
        'note': 'Gần chợ',
        'isDefault': true,
      },
      {
        'id': '4',
        'userId': 'user2',
        'name': 'Trường học',
        'address': '321 Võ Văn Ngân',
        'district': 'Thủ Đức',
        'city': 'TP.HCM',
        'phoneNumber': '0909876543',
        'location': {'latitude': 10.850798, 'longitude': 106.772019},
        'note': 'Cổng sau trường',
        'isDefault': false,
      },
      {
        'id': '5',
        'userId': 'user3',
        'name': 'Văn phòng',
        'address': '159 Điện Biên Phủ',
        'district': 'Bình Thạnh',
        'city': 'TP.HCM',
        'phoneNumber': '0905555555',
        'location': {'latitude': 10.798824, 'longitude': 106.714159},
        'note': 'Tòa nhà Innovation, tầng 15',
        'isDefault': true,
      }
    ];
  }

  static List<Map<String, dynamic>> getUsers() {
    return [
      {
        'id': 'user1',
        'name': 'Nguyễn Văn A',
        'email': 'nguyenvana@gmail.com',
        'phoneNumber': '0901234567',
        'addresses': ['1', '2'],
        'favoriteRestaurants': ['1', '3'],
        'favoriteFood': ['1', '4'],
        'orderHistory': ['order1', 'order2'],
        'avatarUrl': 'assets/images/avatar1.jpg',
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'id': 'user2',
        'name': 'Trần Thị B',
        'email': 'tranthib@gmail.com',
        'phoneNumber': '0909876543',
        'addresses': ['3', '4'],
        'favoriteRestaurants': ['2', '5'],
        'favoriteFood': ['3', '5'],
        'orderHistory': [],
        'avatarUrl': 'assets/images/avatar2.jpg',
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'id': 'user3',
        'name': 'Lê Văn C',
        'email': 'levanc@gmail.com',
        'phoneNumber': '0905555555',
        'addresses': ['5'],
        'favoriteRestaurants': ['4'],
        'favoriteFood': ['2'],
        'orderHistory': [],
        'avatarUrl': 'assets/images/avatar3.jpg',
        'createdAt': Timestamp.fromDate(DateTime.now()),
      }
    ];
  }

  static List<Map<String, dynamic>> getOrders() {
    return [
      {
        'id': 'order1',
        'customerId': 'user1',
        'restaurantId': '1',
        'restaurantName': 'Phở Hà Nội',
        'restaurantImage': 'assets/images/restaurant1.jpg',
        'restaurantAddress': '123 Đường Lê Lợi, Quận 1, TP.HCM',
        'shipperId': 'shipper1',
        'items': [
          {
            'foodId': '1',
            'foodName': 'Phở Bò Tái',
            'foodImage': 'assets/images/pho_tai.jpg',
            'category': '1',
            'quantity': 2,
            'price': 45000,
            'discountPrice': 40000,
            'options': {'size': 'Vừa'},
            'note': 'Ít hành'
          }
        ],
        'deliveryAddress': '123 Nguyễn Văn Cừ, Quận 5, TP.HCM',
        'deliveryFee': 15000,
        'discount': 10000,
        'totalPrice': 95000,
        'paymentMethod': 'cash',
        'note': 'Gọi trước khi giao',
        'orderTime': Timestamp.fromDate(DateTime.now()),
        'estimatedDeliveryTime':
            Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 30))),
        'status': 'preparing'
      },
      {
        'id': 'order2',
        'customerId': 'user1',
        'restaurantId': '3',
        'restaurantName': 'Cơm Tấm Sài Gòn',
        'restaurantImage': 'assets/images/restaurant3.jpg',
        'restaurantAddress': '78 Võ Văn Tần, Quận 3, TP.HCM',
        'shipperId': 'shipper1',
        'items': [
          {
            'foodId': '4',
            'foodName': 'Cơm Tấm Sườn Bì Chả',
            'foodImage': 'assets/images/com_tam.jpg',
            'category': '2',
            'quantity': 1,
            'price': 50000,
            'options': {'Thêm trứng ốp la': 'Có'},
            'note': 'Ít nước mắm'
          }
        ],
        'deliveryAddress': '456 Lê Văn Việt, Quận 9, TP.HCM',
        'deliveryFee': 18000,
        'discount': 0,
        'totalPrice': 73000,
        'paymentMethod': 'cash',
        'note': '',
        'orderTime': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
        'estimatedDeliveryTime': Timestamp.fromDate(DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(minutes: 30))),
        'actualDeliveryTime': Timestamp.fromDate(DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(minutes: 25))),
        'status': 'delivered'
      }
    ];
  }

  static List<Map<String, dynamic>> getShippers() {
    return [
      {
        'id': 'shipper1',
        'name': 'Trần Văn B',
        'phoneNumber': '0909876543',
        'vehicleType': 'motorcycle',
        'vehicleNumber': '59P1-23456',
        'location': {'latitude': 10.762622, 'longitude': 106.660172},
        'status': 'active',
        'rating': 4.8,
        'deliveryHistory': ['order1', 'order2']
      },
      {
        'id': 'shipper2',
        'name': 'Nguyễn Thị D',
        'phoneNumber': '0901112222',
        'vehicleType': 'motorcycle',
        'vehicleNumber': '59P1-78901',
        'location': {'latitude': 10.776543, 'longitude': 106.654321},
        'status': 'active',
        'rating': 4.5,
        'deliveryHistory': []
      }
    ];
  }

  static List<Map<String, dynamic>> getPayments() {
    return [
      {
        'id': 'payment1',
        'orderId': 'order1',
        'amount': 95000,
        'method': 'cash',
        'status': 'completed',
        'transactionId': 'TX123456',
        'paymentTime': Timestamp.fromDate(DateTime.now())
      },
      {
        'id': 'payment2',
        'orderId': 'order2',
        'amount': 73000,
        'method': 'cash',
        'status': 'completed',
        'transactionId': 'TX123457',
        'paymentTime':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)))
      }
    ];
  }

  static List<Map<String, dynamic>> getReviews() {
    return [
      {
        'id': 'review1',
        'userId': 'user1',
        'targetId': '1', // restaurantId
        'targetType': 'restaurant',
        'rating': 4.5,
        'comment': 'Phở rất ngon, nước dùng đậm đà',
        'images': ['assets/images/review1.jpg'],
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5)))
      },
      {
        'id': 'review2',
        'userId': 'user1',
        'targetId': '3', // restaurantId
        'targetType': 'restaurant',
        'rating': 4.7,
        'comment': 'Cơm tấm ngon, phần ăn lớn',
        'images': [],
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)))
      },
      {
        'id': 'review3',
        'userId': 'user1',
        'targetId': '4', // foodId
        'targetType': 'food',
        'rating': 4.8,
        'comment': 'Sườn nướng thơm, cơm dẻo',
        'images': ['assets/images/review3.jpg'],
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)))
      }
    ];
  }

  static List<Map<String, dynamic>> getPromotions() {
    return [
      {
        'id': 'promo1',
        'code': 'WELCOME50',
        'description': 'Giảm 50% cho đơn hàng đầu tiên',
        'discountType': 'percentage',
        'discountValue': 50,
        'maxDiscountAmount': 100000, // Giảm tối đa 100k
        'minOrderAmount': 100000,
        'startDate': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 30))),
        'endDate':
            Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
        'usageLimit': 1000,
        'currentUsage': 50,
        'isActive': true,
        'applicableRestaurants': ['1', '2', '3'],
        'applicableCategories': ['1', '2', '3']
      },
      {
        'id': 'promo2',
        'code': 'FREESHIP',
        'description': 'Miễn phí giao hàng',
        'discountType': 'fixed',
        'discountValue': 25000,
        'maxDiscountAmount': 25000,
        'minOrderAmount': 50000,
        'startDate': Timestamp.fromDate(DateTime.now()),
        'endDate':
            Timestamp.fromDate(DateTime.now().add(const Duration(days: 15))),
        'usageLimit': 500,
        'currentUsage': 10,
        'isActive': true,
        'applicableRestaurants': null, // Áp dụng cho tất cả nhà hàng
        'applicableCategories': null // Áp dụng cho tất cả danh mục
      }
    ];
  }

  static List<Map<String, dynamic>> getNotifications() {
    return [
      {
        'id': 'notif1',
        'userId': 'user1',
        'title': 'Đơn hàng đã được xác nhận',
        'content': 'Đơn hàng #order1 của bạn đã được nhà hàng xác nhận',
        'type': 'order',
        'data': {'orderId': 'order1'},
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 1))),
        'isRead': false
      },
      {
        'id': 'notif2',
        'userId': 'user1',
        'title': 'Đơn hàng đang được giao',
        'content': 'Đơn hàng #order1 của bạn đang được giao đến',
        'type': 'order',
        'data': {'orderId': 'order1'},
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(minutes: 30))),
        'isRead': false
      },
      {
        'id': 'notif3',
        'userId': 'user1',
        'title': 'Khuyến mãi mới',
        'content': 'Sử dụng mã FREESHIP để được miễn phí giao hàng!',
        'type': 'promotion',
        'data': {'promoId': 'promo2'},
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
        'isRead': true
      }
    ];
  }

  static List<Map<String, dynamic>> getRatings() {
    return [
      {
        'id': 'rating1',
        'userId': 'user1',
        'orderId': 'order2',
        'shipperId': 'shipper1',
        'deliveryRating': 5,
        'deliveryComment': 'Shipper rất thân thiện và giao hàng đúng giờ',
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)))
      }
    ];
  }

  static List<Map<String, dynamic>> getSearchHistory() {
    return [
      {
        'id': 'search1',
        'userId': 'user1',
        'keyword': 'phở bò',
        'searchTime':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)))
      },
      {
        'id': 'search2',
        'userId': 'user1',
        'keyword': 'cơm tấm',
        'searchTime':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)))
      },
      {
        'id': 'search3',
        'userId': 'user1',
        'keyword': 'bún đậu',
        'searchTime': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 5)))
      }
    ];
  }

  static List<Map<String, dynamic>> getFavorites() {
    return [
      {
        'id': 'fav1',
        'userId': 'user1',
        'itemId': '1',
        'itemType': 'restaurant',
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7)))
      },
      {
        'id': 'fav2',
        'userId': 'user1',
        'itemId': '3',
        'itemType': 'restaurant',
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5)))
      },
      {
        'id': 'fav3',
        'userId': 'user1',
        'itemId': '1',
        'itemType': 'food',
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3)))
      },
      {
        'id': 'fav4',
        'userId': 'user1',
        'itemId': '4',
        'itemType': 'food',
        'createdAt':
            Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)))
      }
    ];
  }

  static List<Map<String, dynamic>> getCarts() {
    return [
      {
        'id': 'cart1',
        'userId': 'user1',
        'restaurantId': '1',
        'items': [
          {
            'foodId': '1',
            'foodName': 'Phở Bò Tái',
            'foodImage': 'assets/images/pho_tai.jpg',
            'category': '1',
            'quantity': 2,
            'price': 45000,
            'discountPrice': 40000,
            'options': {'size': 'Vừa'},
            'note': 'Ít hành'
          },
          {
            'foodId': '2',
            'foodName': 'Phở Bò Tái Nạm',
            'foodImage': 'assets/images/pho_tai_nam.jpg',
            'category': '1',
            'quantity': 1,
            'price': 55000,
            'options': {'size': 'Nhỏ'},
            'note': ''
          }
        ],
        'updatedAt': Timestamp.fromDate(DateTime.now())
      },
      {
        'id': 'cart2',
        'userId': 'user2',
        'restaurantId': '2',
        'items': [
          {
            'foodId': '3',
            'foodName': 'Bún Bò Huế',
            'foodImage': 'assets/images/bun_bo_hue.jpg',
            'category': '3',
            'quantity': 1,
            'price': 60000,
            'discountPrice': 55000,
            'options': {'Độ cay': 'Vừa'},
            'note': 'Không hành'
          }
        ],
        'updatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 2)))
      }
    ];
  }

  // Helper methods để tạo dữ liệu động

  // Tạo timestamp từ chuỗi thời gian "HH:MM"
  static Timestamp timeStringToTimestamp(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return Timestamp.now();

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

      return Timestamp.fromDate(dateTime);
    } catch (e) {
      return Timestamp.now();
    }
  }

  // Tạo Timestamp từ DateTime với offset ngày
  static Timestamp getTimestampWithDayOffset(int days) {
    final now = DateTime.now();
    return Timestamp.fromDate(now.add(Duration(days: days)));
  }

  // Tạo random orders để testing
  static List<Map<String, dynamic>> generateRandomOrders(int count) {
    final List<Map<String, dynamic>> orders = [];
    final List<String> statuses = [
      'pending',
      'confirmed',
      'preparing',
      'on_the_way',
      'delivered',
      'cancelled'
    ];
    final List<String> restaurants = ['1', '2', '3', '4', '5'];
    final Map<String, String> restaurantNames = {
      '1': 'Phở Hà Nội',
      '2': 'Bún Bò Huế Thanh',
      '3': 'Cơm Tấm Sài Gòn',
      '4': 'Phở 24',
      '5': 'Bún Đậu Mắm Tôm',
    };
    final Map<String, String> restaurantImages = {
      '1': 'assets/images/restaurant1.jpg',
      '2': 'assets/images/restaurant2.jpg',
      '3': 'assets/images/restaurant3.jpg',
      '4': 'assets/images/restaurant4.jpg',
      '5': 'assets/images/restaurant5.jpg',
    };
    final Random random = Random();

    for (int i = 0; i < count; i++) {
      final String restaurantId =
          restaurants[random.nextInt(restaurants.length)];
      final String status = statuses[random.nextInt(statuses.length)];
      final int daysAgo = random.nextInt(10);
      final Timestamp orderTime = Timestamp.fromDate(DateTime.now()
          .subtract(Duration(days: daysAgo, hours: random.nextInt(24))));

      final items = getFoods()
          .where((food) => food['restaurantId'] == restaurantId)
          .take(1 + random.nextInt(2))
          .map((food) => {
                'foodId': food['id'],
                'foodName': food['name'],
                'foodImage': food['images'][0],
                'category': food['category'],
                'quantity': 1 + random.nextInt(3),
                'price': food['price'],
                'discountPrice': food['discountPrice'],
                'options': {},
                'note': ''
              })
          .toList();

      // Tính tổng giá
      double subtotal = 0;
      for (var item in items) {
        final price = (item['discountPrice'] ?? item['price']) as double;
        subtotal += price * (item['quantity'] as int);
      }

      final deliveryFee = (random.nextInt(3) + 1) * 5000.0;
      final discount = random.nextBool() ? random.nextInt(5) * 10000.0 : 0.0;
      final totalPrice = subtotal + deliveryFee - discount;

      orders.add({
        'id': 'order${100 + i}',
        'customerId': 'user${1 + random.nextInt(3)}',
        'restaurantId': restaurantId,
        'restaurantName': restaurantNames[restaurantId],
        'restaurantImage': restaurantImages[restaurantId],
        'shipperId': random.nextBool() ? 'shipper1' : 'shipper2',
        'items': items,
        'deliveryAddress':
            '123 Đường ABC, Quận ${1 + random.nextInt(12)}, TP.HCM',
        'deliveryFee': deliveryFee,
        'discount': discount,
        'totalPrice': totalPrice,
        'paymentMethod': random.nextBool() ? 'cash' : 'card',
        'note': '',
        'orderTime': orderTime,
        'estimatedDeliveryTime': Timestamp.fromDate(
            orderTime.toDate().add(Duration(minutes: 30 + random.nextInt(30)))),
        'status': status,
      });

      // Nếu đã giao hàng, thêm thời gian giao hàng thực tế
      if (status == 'delivered') {
        orders.last['actualDeliveryTime'] = Timestamp.fromDate(
            orderTime.toDate().add(Duration(minutes: 25 + random.nextInt(35))));
      }
    }

    return orders;
  }
}
