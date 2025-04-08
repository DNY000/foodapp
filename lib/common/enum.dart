enum Role { user, sellers, managment, shipper }

enum PaymentMethod { visa, banking, momo, zalopay, thanhtoankhinhanhang }

enum OrderState {
  pending, // Đơn hàng đang chờ xác nhận
  confirmed, // Đơn hàng đã được nhà hàng xác nhận
  preparing, // Nhà hàng đang chuẩn bị món ăn
  readyForPickup, // Đồ ăn đã sẵn sàng để giao
  delivering, // Đơn hàng đang được giao bởi shipper
  delivered, // Đơn hàng đã được giao thành công
  cancelled, // Đơn hàng bị hủy bởi khách hoặc hệ thống
  failed
}

enum CategoryFood { pho, banhmi, doannhan, bun, combo2nguoi, monnhau }

enum PaymentState { pending, confirmed, delivering, cancelled, failed }

enum ShipperStatus { available, busy, inactive }
