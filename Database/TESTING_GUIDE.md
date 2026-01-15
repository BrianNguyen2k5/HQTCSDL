# HƯỚNG DẪN CHẠY TEST - CASHIER MODULE

## Các bước thực hiện

### 1. Cập nhật Schema (nếu cần thiết)

Nếu database chưa được tạo hoặc cần tạo lại:

```sql
-- Mở SQL Server Management Studio
-- Kết nối đến SQL Server
-- Chạy file: vietsport-schema.sql
```

### 2. Cập nhật Stored Procedures

```sql
-- Chạy file: sp_cashier_procedures.sql
-- File này sử dụng CREATE OR ALTER nên sẽ tự động cập nhật
```

### 3. Chạy Test

```sql
-- Chạy file: test_cashier_procedures.sql
-- Xem kết quả trong tab Messages và Results
```

### 4. Test Thanh Toán Thực Tế

Để test thanh toán thực tế, uncomment phần TEST 8 trong file `test_cashier_procedures.sql`

### 5. Test API và Frontend

```powershell
# Mở PowerShell
cd "d:\HCMUS\Hk5\Hệ quản trị csdl\Đồ án\Vietsport\HQTCSDL\Web"
dotnet run

# Sau đó mở trình duyệt và truy cập:
# http://localhost:5000/Cashier
```

## Kết quả mong đợi

✅ Schema không có lỗi cú pháp
✅ 3 stored procedures được tạo/cập nhật thành công
✅ Tất cả test cases chạy thành công
✅ Logic thanh toán hoạt động đúng cho cả 2 trường hợp
✅ API endpoints trả về dữ liệu đúng
✅ Frontend hiển thị và xử lý thanh toán chính xác

## Lưu ý

- Đảm bảo SQL Server đang chạy
- Đảm bảo connection string trong appsettings.json đúng
- Nếu có lỗi, kiểm tra lại các bước trên
