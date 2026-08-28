# Thiết lập tiếp nhận và từ chối booking

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

## 3. Kiểm thử

1. Đăng nhập bằng tài khoản doanh nghiệp xuất khẩu và tạo một booking mới.
2. Đăng xuất, đăng nhập bằng tài khoản đơn vị vận tải.
3. Mở **Đặt chỗ trước**.
4. Nhấn **Từ chối**: booking biến mất với đơn vị này nhưng vẫn mở cho đơn vị khác.
5. Với booking khác, nhấn **Tiếp nhận**: trạng thái chuyển thành **Đã tiếp nhận**.
6. Nhấn **Xác nhận vận chuyển**: trạng thái chuyển thành **Đã xác nhận**.

## Kết quả nghiệp vụ

- Một đơn vị từ chối không làm booking bị đóng trên toàn hệ thống.
- Booking chỉ được gắn với đơn vị vận tải đã tiếp nhận.
- Đơn vị vận tải chỉ thấy booking còn mở và booking do chính mình tiếp nhận.
