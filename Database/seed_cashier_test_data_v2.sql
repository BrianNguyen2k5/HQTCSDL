/* ====================================================
   SEED DATA FOR TESTING CASHIER MODULE - CS01 (SET 2)
   Tạo dữ liệu test bổ sung cho HoaDon, PhieuDatSan
   ==================================================== */

USE VietSport;
GO

PRINT '====================================================';
PRINT 'BẮT ĐẦU TẠO DỮ LIỆU TEST BỔ SUNG (SET 2)';
PRINT '====================================================';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 1: Đặt sân cầu lông + Nhiều dịch vụ (Chờ xác nhận)
-- ====================================================
PRINT 'Tạo trường hợp 1: Sân cầu lông + Nhiều dịch vụ...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_NEW_01', GETDATE(), CAST(DATEADD(DAY, 1, GETDATE()) AS DATE), '17:00:00', '19:00:00', N'Online', N'Chờ xác nhận', NULL, 'KH001', NULL, 'CS01LS0201');

-- Dịch vụ
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_NEW_01', GETDATE(), 2, 200000, 'PDS_NEW_01', NULL, 'DV02', NULL, 0), -- 2 Vợt
('CT_NEW_02', GETDATE(), 1, 50000, 'PDS_NEW_01', NULL, 'DV03', NULL, 0),  -- 1 Ống cầu
('CT_NEW_03', GETDATE(), 4, 40000, 'PDS_NEW_01', NULL, 'DV05', NULL, 0);  -- 4 Nước

-- Hóa đơn: Sân 300k + Dịch vụ 290k = 590k
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 300000, 290000, 0, 590000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_NEW_01', NULL);


-- ====================================================
-- TRƯỜNG HỢP 2: Sân bóng đá (Chờ thanh toán - Có phát sinh)
-- ====================================================
PRINT 'Tạo trường hợp 2: Sân bóng đá có phát sinh dịch vụ...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_NEW_02', DATEADD(HOUR, -2, GETDATE()), CAST(GETDATE() AS DATE), '15:00:00', '16:30:00', N'Tại quầy', N'Chờ thanh toán', '15:00:00', 'KH002', 'NV003', 'CS01LS0101');

-- Dịch vụ cũ
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_NEW_04', DATEADD(HOUR, -2, GETDATE()), 10, 100000, 'PDS_NEW_02', 'NV003', 'DV01', NULL, 1); -- 10 Áo bib (Đã trả tiền trước đó - giả định)

-- Dịch vụ mới phát sinh (Chưa trả)
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_NEW_05', GETDATE(), 20, 200000, 'PDS_NEW_02', 'NV003', 'DV05', NULL, 0); -- 20 Nước (Mới gọi)

-- Hóa đơn tổng kết: Sân 450k + DV phát sinh 200k = 650k (DV cũ đã thanh toán ko tính vào bill cuối hoặc tính tuỳ logic, ở đây giả sử bill này là bill tổng toán)
-- Logic thường là Bill cuối sẽ tính: Tiền Sân (chưa trả) + DV phát sinh (chưa trả). DV cũ (đã trả) ko tính.
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 450000, 200000, 0, 650000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_NEW_02', NULL);


-- ====================================================
-- TRƯỜNG HỢP 3: Sân Tennis VIP + Giảm giá Voucher
-- ====================================================
PRINT 'Tạo trường hợp 3: Sân Tennis VIP có Voucher giảm giá...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_NEW_03', GETDATE(), CAST(DATEADD(DAY, 2, GETDATE()) AS DATE), '08:00:00', '11:00:00', N'Online', N'Chờ xác nhận', NULL, 'KH005', NULL, 'CS01LS0301');

-- Hóa đơn: Sân 3h x 200k = 600k. Giảm giá 50k.
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 600000, 0, 50000, 550000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_NEW_03', NULL);


PRINT '====================================================';
PRINT 'HOÀN THÀNH TẠO DỮ LIỆU TEST BỔ SUNG';
PRINT '====================================================';
