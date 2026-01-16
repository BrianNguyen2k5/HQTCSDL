# Hướng Dẫn Test Module Thu Ngân

## Bước 1: Chạy Stored Procedures

1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối đến SQL Server của bạn
3. Chọn database **VietSport**
4. Mở file `sp_cashier_procedures.sql`
5. Chạy toàn bộ script (F5)
6. Kiểm tra kết quả: `Đã tạo thành công các stored procedures cho module thu ngân!`

## Bước 2: Test Stored Procedures

Chạy file `test_cashier_procedures.sql` để kiểm tra:

```sql
-- Kiểm tra stored procedures đã tạo
SELECT name FROM sys.procedures 
WHERE name IN ('sp_GetAllInvoices', 'sp_GetInvoiceDetail', 'sp_ProcessPayment');

-- Test lấy danh sách hóa đơn
EXEC sp_GetAllInvoices @MaCoSo = NULL, @TrangThai = NULL;
```

## Bước 3: Truy Cập Giao Diện Web

Ứng dụng đang chạy tại: **http://localhost:5044**

### Truy cập giao diện thu ngân:

```
http://localhost:5044/Cashier
```

hoặc

```
http://localhost:5044/Cashier/Index
```

## Bước 4: Test Chức Năng

### Test 1: Xem Danh Sách Hóa Đơn
- ✅ Kiểm tra danh sách hóa đơn hiển thị
- ✅ Kiểm tra thông tin: Mã HĐ, Khách hàng, Ngày, Tổng tiền, Trạng thái

### Test 2: Tìm Kiếm
- ✅ Nhập tên khách hàng vào ô tìm kiếm
- ✅ Nhập số điện thoại
- ✅ Nhập mã hóa đơn
- ✅ Kiểm tra kết quả lọc real-time

### Test 3: Lọc Theo Trạng Thái
- ✅ Click tab "Tất cả"
- ✅ Click tab "Chưa thanh toán"
- ✅ Click tab "Đã thanh toán"

### Test 4: Xem Chi Tiết
- ✅ Click vào một hóa đơn
- ✅ Kiểm tra thông tin khách hàng
- ✅ Kiểm tra thông tin sân
- ✅ Kiểm tra bảng dịch vụ
- ✅ Kiểm tra tổng tiền

### Test 5: Thanh Toán
- ✅ Click nút "Thanh Toán Ngay"
- ✅ Chọn phương thức "Tiền mặt"
- ✅ Click "Hoàn tất thanh toán"
- ✅ Kiểm tra thông báo thành công
- ✅ Kiểm tra trạng thái đã cập nhật

### Test 6: Quay Lại
- ✅ Click nút back (←)
- ✅ Kiểm tra quay về danh sách
- ✅ Kiểm tra hóa đơn vừa thanh toán đã chuyển trạng thái

## Bước 5: Test API (Optional)

Sử dụng Postman hoặc Thunder Client:

### GET Danh sách hóa đơn
```http
GET http://localhost:5044/api/cashier/invoices
```

### GET Chi tiết hóa đơn
```http
GET http://localhost:5044/api/cashier/invoices/1
```

### POST Thanh toán
```http
POST http://localhost:5044/api/cashier/invoices/1/payment
Content-Type: application/json

{
  "maHoaDon": 1,
  "hinhThucThanhToan": "Tiền mặt",
  "maNhanVien": "NV001"
}
```

### GET Thống kê
```http
GET http://localhost:5044/api/cashier/statistics
```

## Lỗi Thường Gặp

### Lỗi 1: Không kết nối được database
**Giải pháp**: Kiểm tra connection string trong `appsettings.json`

### Lỗi 2: Stored procedure không tồn tại
**Giải pháp**: Chạy lại file `sp_cashier_procedures.sql`

### Lỗi 3: Không có dữ liệu
**Giải pháp**: Kiểm tra bảng `HoaDon` có dữ liệu chưa

### Lỗi 4: 404 Not Found
**Giải pháp**: Đảm bảo URL đúng: `/Cashier` hoặc `/Cashier/Index`

## Checklist Hoàn Thành

- [ ] Stored procedures đã chạy thành công
- [ ] Giao diện thu ngân hiển thị được
- [ ] Danh sách hóa đơn load được
- [ ] Tìm kiếm hoạt động
- [ ] Lọc theo trạng thái hoạt động
- [ ] Xem chi tiết hóa đơn
- [ ] Thanh toán thành công
- [ ] Trạng thái cập nhật đúng

## Ghi Chú

- Port mặc định: **5044** (có thể khác tùy cấu hình)
- Warnings về null reference không ảnh hưởng chức năng
- Mã nhân viên mặc định: **NV001** (cần thay bằng nhân viên thật khi có authentication)
