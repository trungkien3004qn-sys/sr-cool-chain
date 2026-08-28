# Thiết lập chức năng đăng ký tài khoản

## 1. Chạy migration Supabase

Mở **Supabase Dashboard → SQL Editor → New query**, dán toàn bộ nội dung file
`supabase-registration-migration.sql`, sau đó nhấn **Run**.

Kết quả đúng: `Success. No rows returned`.

## 2. Bật xác thực email cho đăng ký

Trong Supabase Authentication:

1. Mở cấu hình nhà cung cấp **Email**.
2. Bật đăng ký bằng email và mật khẩu.
3. Bật yêu cầu xác nhận email trước khi đăng nhập.
4. Lưu cấu hình.

## 3. Cấu hình email OTP đăng ký

Mở **Authentication → Email Templates → Confirm signup**.

Trong nội dung email, phải có biến:

```text
{{ .Token }}
```

Có thể dùng nội dung tối giản:

```html
<h2>Xác thực tài khoản SR Cool Chain</h2>
<p>Mã xác thực của bạn:</p>
<h1>{{ .Token }}</h1>
<p>Không chia sẻ mã này cho người khác.</p>
```

Lưu template. Hệ thống hiện chờ mã 8 số, phù hợp cấu hình OTP đang dùng trong
dự án.

## 4. Kiểm thử

1. Chạy `npm run dev`.
2. Chọn **Đăng ký tài khoản**.
3. Chọn một trong ba role: exporter, carrier hoặc driver.
4. Điền thông tin và nhấn **Gửi mã xác thực**.
5. Nhập OTP vào 8 ô.
6. Sau khi xác thực thành công, đăng nhập lại bằng email và mật khẩu.
7. Đăng xuất rồi đăng nhập tài khoản khác để kiểm thử role khác.

## Lưu ý cho tài khoản cũ

Tài khoản đã tạo bằng luồng OTP cũ có thể chưa có mật khẩu. Để kiểm thử nhanh,
hãy đăng ký các email mới. Với Gmail có thể dùng alias như:

```text
tenban+exporter@gmail.com
tenban+carrier@gmail.com
tenban+driver@gmail.com
```

Các email thường vẫn được chuyển về cùng một hộp thư Gmail nhưng Supabase xem
chúng là các tài khoản khác nhau.
