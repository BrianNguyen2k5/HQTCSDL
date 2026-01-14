-- ====================================================
-- HƯỚNG DẪN CHẠY STORED PROCEDURES
-- ====================================================

-- Bước 1: Kết nối đến database VietSport trong SQL Server Management Studio
-- Bước 2: Copy và chạy toàn bộ nội dung file sp_cashier_procedures.sql
-- Bước 3: Kiểm tra stored procedures đã được tạo

-- Kiểm tra stored procedures đã tạo:
SELECT 
    name AS ProcedureName,
    create_date AS CreatedDate,
    modify_date AS ModifiedDate
FROM sys.procedures
WHERE name LIKE 'sp_%cashier%' OR name IN ('sp_GetAllInvoices', 'sp_GetInvoiceDetail', 'sp_ProcessPayment')
ORDER BY name;

-- ====================================================
-- TEST STORED PROCEDURES
-- ====================================================

-- Test 1: Lấy tất cả hóa đơn
EXEC sp_GetAllInvoices @MaCoSo = NULL, @TrangThai = NULL;

-- Test 2: Lấy hóa đơn chưa thanh toán
EXEC sp_GetAllInvoices @MaCoSo = NULL, @TrangThai = N'Chưa thanh toán';

-- Test 3: Lấy hóa đơn đã thanh toán
EXEC sp_GetAllInvoices @MaCoSo = NULL, @TrangThai = N'Đã thanh toán';

-- Test 4: Lấy chi tiết hóa đơn (thay số 1 bằng MaHoaDon thực tế)
EXEC sp_GetInvoiceDetail @MaHoaDon = 1;

-- Test 5: Xử lý thanh toán (CHỈ CHẠY KHI MUỐN THANH TOÁN THẬT)
-- EXEC sp_ProcessPayment 
--     @MaHoaDon = 1, 
--     @HinhThucThanhToan = N'Tiền mặt', 
--     @MaNhanVien = 'NV001';

-- ====================================================
-- KIỂM TRA DỮ LIỆU
-- ====================================================

-- Xem danh sách hóa đơn hiện có
SELECT TOP 10
    hd.MaHoaDon,
    hd.NgayXuat,
    hd.TongThanhToan,
    hd.TrangThaiThanhToan,
    kh.HoTen AS TenKhachHang,
    kh.SoDienThoai
FROM HoaDon hd
LEFT JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
LEFT JOIN PhieuThueTaiSan pts ON hd.MaPhieuThue = pts.MaPhieuThue
LEFT JOIN KhachHang kh ON (pds.MaKhachHang = kh.MaKhachHang OR pts.MaKhachHang = kh.MaKhachHang)
ORDER BY hd.NgayXuat DESC;

-- Đếm số hóa đơn theo trạng thái
SELECT 
    TrangThaiThanhToan,
    COUNT(*) AS SoLuong,
    SUM(TongThanhToan) AS TongTien
FROM HoaDon
GROUP BY TrangThaiThanhToan;
