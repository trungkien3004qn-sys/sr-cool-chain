# Thiết lập quy trình booking, tài xế và giao hàng

## 1. Chạy SQL trên Supabase

1. Mở Supabase Dashboard.
2. Chọn **SQL Editor**.
3. Tạo **New query**.
4. Mở file `supabase-carrier-booking-response.sql` trong VS Code.
5. Sao chép toàn bộ nội dung vào SQL Editor và nhấn **Run**.
6. Kết quả đúng: `Success. No rows returned`.

## 2. Chạy website

```powershell
npm run dev
```

## 3. Kiểm thử tiếp nhận và từ chối

1. Đăng nhập bằng tài khoản doanh nghiệp xuất khẩu và tạo một booking mới.
2. Đăng xuất, đăng nhập bằng tài khoản đơn vị vận tải.
3. Mở **Đặt chỗ trước**.
4. Nhấn **Từ chối**: booking biến mất với đơn vị này nhưng vẫn mở cho đơn vị khác.
5. Với booking khác, nhấn **Tiếp nhận**: trạng thái chuyển thành **Đã tiếp nhận**.
6. Nhấn **Xác nhận vận chuyển**: trạng thái chuyển thành **Đã xác nhận**.

## 4. Kiểm thử phân công tài xế

1. Đăng nhập bằng tài khoản **Đơn vị vận tải**.
2. Trên booking đã tiếp nhận, tại cột **Tài xế**, mở danh sách chọn.
3. Chọn một tài xế đã đăng ký và chờ thông báo thành công.
4. Đăng xuất, đăng nhập bằng tài khoản **Tài xế** tương ứng.
5. Mở **Theo dõi đơn hàng** để xem chuyến được giao.

## 5. Kiểm thử điểm đến, tuyến đường và cập nhật thủ công

1. Đăng nhập tài khoản doanh nghiệp xuất khẩu và mở **Đặt chỗ trước**.
2. Chọn **Vùng trồng**, sau đó nhập một trong các dạng sau vào ô **Điểm đến / tọa độ / link Google Maps**:
   - Địa chỉ: `Cảng Quy Nhơn, Bình Định`.
   - Tọa độ: `13.7425, 109.2333` (vĩ độ trước, kinh độ sau).
   - Link Google Maps đầy đủ có chứa tọa độ, thường có đoạn `@13.7425,109.2333`.
3. Nhấn **Tính tuyến đường**. Kết quả đúng phải có quãng đường, thời gian dự kiến, bản đồ và năm mốc 0%, 25%, 50%, 75%, 100%.
4. Nhấn **Đăng ký đặt chỗ**. Website lưu điểm đầu, điểm đến, tọa độ, hình học tuyến và danh sách mốc vào bảng `bookings`.
5. Sau khi đơn vị vận tải tiếp nhận và phân công tài xế, đăng nhập tài khoản tài xế rồi mở **Theo dõi đơn hàng**.
6. Tài xế nhấn **Cập nhật**, kéo thanh tiến độ qua các mốc 0%, 25%, 50%, 75% hoặc 100%. Hệ thống tự gợi ý số kilomet đã đi và tính số kilomet còn lại.
7. Nhập vị trí thực tế, điều chỉnh số kilomet nếu cần, thêm ghi chú rồi nhấn **Lưu cập nhật**.
8. Mỗi lần cập nhật được lưu vào booking và bảng `tracking_events`.

## 6. Kiểm thử xác nhận giao hàng

1. Đăng nhập bằng tài khoản **Tài xế** và mở **Theo dõi đơn hàng**.
2. Nhấn **Cập nhật**, kéo tiến độ đến mốc **100%**, rồi nhấn **Lưu cập nhật**.
3. Biểu mẫu **Xác nhận giao hàng** tự mở. Nếu đóng nhầm, nhấn nút cùng tên trong cột **Thao tác** để mở lại.
4. Nhập tên người nhận, thời gian bàn giao, tình trạng hàng và chọn một ảnh JPG, PNG hoặc WebP không quá 5 MB.
5. Nhấn **Xác nhận đã giao hàng**. Kết quả đúng:
   - Trạng thái chuyến thành **Đã hoàn thành**.
   - Không còn nút cập nhật hành trình.
   - Thông tin người nhận, thời gian, tình trạng và nút xem ảnh bàn giao xuất hiện trên chuyến.
6. Đăng nhập lại bằng tài khoản doanh nghiệp hoặc đơn vị vận tải liên quan. Hai vai trò này có thể xem kết quả và ảnh bàn giao nhưng không thể sửa thông tin bàn giao.

Ảnh được lưu trong bucket riêng tư `delivery-proofs`. Website chỉ tạo đường dẫn xem tạm thời cho doanh nghiệp, đơn vị vận tải và tài xế liên quan đến booking.

Website dùng Nominatim/OpenStreetMap để tìm tọa độ điểm đến và OSRM để tính tuyến đường bộ. Đây là quãng đường ước tính theo mạng lưới đường, không phải dữ liệu GPS hoặc tình trạng giao thông trực tiếp.

Link rút gọn dạng `maps.app.goo.gl/...` không chứa tọa độ trong chính đường dẫn. Hãy mở link rút gọn trong trình duyệt rồi sao chép link đầy đủ trên thanh địa chỉ, hoặc sao chép trực tiếp tọa độ từ Google Maps.

Nếu dịch vụ tìm địa điểm hoặc định tuyến tạm thời không phản hồi, booking mới sẽ báo lỗi để tránh lưu một tuyến đường không có số liệu.

Booking cũ được tạo trước bản cập nhật sẽ chưa có `route_milestones`. Hãy tạo booking mới để kiểm thử đầy đủ.

## Kết quả nghiệp vụ

- Một đơn vị từ chối không làm booking bị đóng trên toàn hệ thống.
- Booking chỉ được gắn với đơn vị vận tải đã tiếp nhận.
- Đơn vị vận tải chỉ thấy booking còn mở và booking do chính mình tiếp nhận.
- Tài xế chỉ thấy booking được phân công cho tài khoản của mình.
- Chỉ tài xế được phân công mới có thể cập nhật hành trình và xác nhận giao hàng.
- Chuyến đã giao được khóa ở trạng thái **Đã hoàn thành** và lưu bằng chứng bàn giao riêng tư.
