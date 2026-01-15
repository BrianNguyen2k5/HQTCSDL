/* ====================================================
   SEED DATA FOR TESTING CASHIER MODULE - CS01
   Tạo dữ liệu test cho HoaDon, PhieuDatSan, ChiTietPhieuDatSan
   Sử dụng các mã đã có trong database seed
   ==================================================== */

USE VietSport;
GO

PRINT '====================================================';
PRINT 'BẮT ĐẦU TẠO DỮ LIỆU TEST CHO MODULE THU NGÂN - CS01';
PRINT '====================================================';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 1: Thanh toán ban đầu (Chờ xác nhận)
-- Khách hàng đặt sân bóng đá mini + mua dịch vụ
-- ====================================================
PRINT 'Tạo trường hợp 1: Thanh toán ban đầu - Sân bóng đá mini...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST01', GETDATE(), CAST(DATEADD(DAY, 1, GETDATE()) AS DATE), '14:00:00', '15:30:00', N'Tại quầy', N'Chờ xác nhận', NULL, 'KH016', 'NV006', 'CS01LS0101');

-- Dịch vụ: Áo bib + Nước uống
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST01', GETDATE(), 2, 200000, 'PDS_TEST01', 'NV006', 'DV01', NULL, 0),  -- 2 áo bib
('CT_TEST02', GETDATE(), 5, 50000, 'PDS_TEST01', 'NV006', 'DV05', NULL, 0);   -- 5 chai nước

-- Hóa đơn: Sân 600,000 + Dịch vụ 250,000 = 850,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 600000, 250000, 0, 850000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST01', NULL);

PRINT 'Đã tạo: PDS_TEST01 - Chờ xác nhận - Sân bóng đá mini';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 2: Thanh toán khi có dịch vụ phát sinh (Chờ thanh toán)
-- Khách đã đặt sân cầu lông, sau đó mua thêm vợt và bóng
-- ====================================================
PRINT 'Tạo trường hợp 2: Thanh toán có dịch vụ phát sinh - Sân cầu lông...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST02', DATEADD(HOUR, -3, GETDATE()), CAST(GETDATE() AS DATE), '16:00:00', '18:00:00', N'Online', N'Chờ thanh toán', '16:05:00', 'KH017', 'NV007', 'CS01LS0201');

-- Dịch vụ ban đầu (đặt cùng lúc)
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST03', DATEADD(HOUR, -3, GETDATE()), 2, 20000, 'PDS_TEST02', 'NV007', 'DV05', NULL, 0);  -- 2 chai nước (ban đầu)

-- Dịch vụ phát sinh (mua thêm sau)
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST04', GETDATE(), 2, 200000, 'PDS_TEST02', 'NV003', 'DV02', NULL, 0),  -- 2 vợt cầu lông VIP (phát sinh)
('CT_TEST05', GETDATE(), 3, 150000, 'PDS_TEST02', 'NV003', 'DV03', NULL, 0);  -- 3 quả bóng động lực (phát sinh)

-- Hóa đơn: Sân 300,000 (2h x 150,000) + Dịch vụ 370,000 = 670,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 300000, 370000, 0, 670000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST02', NULL);

PRINT 'Đã tạo: PDS_TEST02 - Chờ thanh toán - Sân cầu lông có dịch vụ phát sinh';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 3: Thanh toán ban đầu có ưu đãi - Sân Tennis
-- Khách hàng có ưu đãi HSSV 10%
-- ====================================================
PRINT 'Tạo trường hợp 3: Thanh toán ban đầu có ưu đãi - Sân Tennis...';

-- Áp dụng ưu đãi cho khách hàng KH018
INSERT INTO ApDung (MaKhachHang, MaUuDai, NgayBatDau, NgayKetThuc, TrangThai)
VALUES 
('KH018', 'UD04', DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, 11, GETDATE()), 1);  -- HSSV 10%

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST03', GETDATE(), CAST(DATEADD(DAY, 2, GETDATE()) AS DATE), '10:00:00', '12:00:00', N'Online', N'Chờ xác nhận', NULL, 'KH018', NULL, 'CS01LS0301');

-- Dịch vụ: Nước uống
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST06', GETDATE(), 4, 40000, 'PDS_TEST03', NULL, 'DV05', NULL, 0);  -- 4 chai nước

-- Hóa đơn: Sân 400,000 + Dịch vụ 40,000 = 440,000, giảm 10% = 44,000, còn 396,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 400000, 40000, 44000, 396000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST03', NULL);

PRINT 'Đã tạo: PDS_TEST03 - Chờ xác nhận - Sân Tennis có ưu đãi HSSV';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 4: Đặt sân bóng rổ có HLV
-- ====================================================
PRINT 'Tạo trường hợp 4: Đặt sân bóng rổ có HLV...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST04', GETDATE(), CAST(DATEADD(DAY, 3, GETDATE()) AS DATE), '18:00:00', '20:00:00', N'Online', N'Chờ xác nhận', NULL, 'KH019', NULL, 'CS01LS0401');

-- Dịch vụ: Nước + HLV bóng rổ
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST07', GETDATE(), 6, 60000, 'PDS_TEST04', NULL, 'DV05', NULL, 0),      -- 6 chai nước
('CT_TEST08', GETDATE(), 2, 560000, 'PDS_TEST04', NULL, 'DV07', 'NV012', 0);  -- 2 giờ HLV (280,000 x 2)

-- Lịch HLV
DECLARE @NgayHLV DATE = DATEADD(DAY, 3, GETDATE());
INSERT INTO DatLichHLV (MaChiTietPDS, MaHLV, GioBatDauDV, GioKetThucDV)
VALUES 
('CT_TEST08', 'NV012', 
 CONVERT(DATETIME, CONVERT(VARCHAR(10), @NgayHLV, 120) + ' 18:00:00'), 
 CONVERT(DATETIME, CONVERT(VARCHAR(10), @NgayHLV, 120) + ' 20:00:00'));

-- Hóa đơn: Sân 400,000 (2h x 200,000) + Dịch vụ 620,000 = 1,020,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 400000, 620000, 0, 1020000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST04', NULL);

PRINT 'Đã tạo: PDS_TEST04 - Chờ xác nhận - Sân bóng rổ có HLV';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 5: Đơn giản - Chỉ thuê sân Futsal
-- ====================================================
PRINT 'Tạo trường hợp 5: Đơn giản - Chỉ thuê sân Futsal...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST05', GETDATE(), CAST(GETDATE() AS DATE), '08:00:00', '10:00:00', N'Tại quầy', N'Chờ xác nhận', NULL, 'KH020', 'NV006', 'CS01LS0501');

-- Không có ChiTietPhieuDatSan (chỉ thuê sân)

-- Hóa đơn: Chỉ tiền sân 1,000,000 (2h x 500,000)
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 1000000, 0, 0, 1000000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST05', NULL);

PRINT 'Đã tạo: PDS_TEST05 - Chờ xác nhận - Sân Futsal (chỉ thuê sân)';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 6: Thanh toán ban đầu - Sân cầu lông giờ tối (có phụ thu)
-- ====================================================
PRINT 'Tạo trường hợp 6: Thanh toán ban đầu - Sân cầu lông giờ tối...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST06', GETDATE(), CAST(GETDATE() AS DATE), '19:00:00', '21:00:00', N'Tại quầy', N'Chờ xác nhận', NULL, 'KH021', 'NV007', 'CS01LS0202');

-- Dịch vụ: Vợt cầu lông
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST09', GETDATE(), 2, 200000, 'PDS_TEST06', 'NV007', 'DV02', NULL, 0);  -- 2 vợt

-- Hóa đơn: Sân 360,000 (2h x (150,000 + 30,000 phụ thu tối)) + Dịch vụ 200,000 = 560,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 360000, 200000, 0, 560000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST06', NULL);

PRINT 'Đã tạo: PDS_TEST06 - Chờ xác nhận - Sân cầu lông giờ tối';
PRINT '';

-- ====================================================
-- TRƯỜNG HỢP 7: Thanh toán có dịch vụ phát sinh - Sân bóng đá mini
-- Khách đặt sân, sau đó thuê thêm áo đồng phục và trọng tài
-- ====================================================
PRINT 'Tạo trường hợp 7: Thanh toán có dịch vụ phát sinh - Sân bóng đá mini...';

INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, ThoiGianCheckin, MaKhachHang, MaNhanVien, MaSan)
VALUES 
('PDS_TEST07', DATEADD(HOUR, -4, GETDATE()), CAST(GETDATE() AS DATE), '17:00:00', '18:30:00', N'Online', N'Chờ thanh toán', '17:00:00', 'KH022', NULL, 'CS01LS0102');

-- Dịch vụ ban đầu
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST10', DATEADD(HOUR, -4, GETDATE()), 10, 100000, 'PDS_TEST07', NULL, 'DV05', NULL, 0);  -- 10 chai nước (ban đầu)

-- Dịch vụ phát sinh
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan)
VALUES 
('CT_TEST11', GETDATE(), 14, 1400000, 'PDS_TEST07', 'NV003', 'DV06', NULL, 0),  -- 14 áo đồng phục (phát sinh)
('CT_TEST12', GETDATE(), 1, 200000, 'PDS_TEST07', 'NV003', 'DV07', NULL, 0);    -- 1 trọng tài (phát sinh)

-- Hóa đơn: Sân 700,000 (90 phút + phụ thu tối) + Dịch vụ 1,700,000 = 2,400,000
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES 
(GETDATE(), 700000, 1700000, 0, 2400000, NULL, N'Chưa thanh toán', 'NV003', 'PDS_TEST07', NULL);

PRINT 'Đã tạo: PDS_TEST07 - Chờ thanh toán - Sân bóng đá mini có dịch vụ phát sinh nhiều';
PRINT '';

-- ====================================================
-- KIỂM TRA KẾT QUẢ
-- ====================================================
PRINT '====================================================';
PRINT 'KIỂM TRA DỮ LIỆU ĐÃ TẠO';
PRINT '====================================================';
PRINT '';

SELECT 
    hd.MaHoaDon,
    hd.NgayXuat,
    hd.TongThanhToan,
    hd.TrangThaiThanhToan,
    pds.MaPhieuDat,
    pds.TrangThaiPhieu,
    kh.HoTen AS TenKhachHang,
    s.TenSan,
    COUNT(ct.MaChiTietPDS) AS SoLuongDichVu
FROM HoaDon hd
INNER JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
INNER JOIN KhachHang kh ON pds.MaKhachHang = kh.MaKhachHang
INNER JOIN San s ON pds.MaSan = s.MaSan
LEFT JOIN ChiTietPhieuDatSan ct ON pds.MaPhieuDat = ct.MaPhieuDat
WHERE pds.MaPhieuDat LIKE 'PDS_TEST%'
GROUP BY hd.MaHoaDon, hd.NgayXuat, hd.TongThanhToan, hd.TrangThaiThanhToan, 
         pds.MaPhieuDat, pds.TrangThaiPhieu, kh.HoTen, s.TenSan
ORDER BY hd.MaHoaDon;

PRINT '';
PRINT 'Chi tiết ChiTietPhieuDatSan:';
SELECT 
    ct.MaChiTietPDS,
    ct.MaPhieuDat,
    ct.SoLuong,
    ct.ThanhTien,
    ct.TrangThaiThanhToan,
    dv.TenDichVu,
    CASE WHEN ct.MaHLV IS NOT NULL THEN N'Có HLV' ELSE N'Không' END AS CoHLV
FROM ChiTietPhieuDatSan ct
INNER JOIN DichVu dv ON ct.MaDichVu = dv.MaDichVu
WHERE ct.MaChiTietPDS LIKE 'CT_TEST%'
ORDER BY ct.MaPhieuDat, ct.MaChiTietPDS;

PRINT '';
PRINT '====================================================';
PRINT 'HOÀN THÀNH TẠO DỮ LIỆU TEST';
PRINT 'Đã tạo 7 trường hợp test cho module thu ngân - CS01';
PRINT '====================================================';
PRINT '';
PRINT 'Tổng kết:';
PRINT '- Trường hợp Chờ xác nhận: 5 phiếu (PDS_TEST01, 03, 04, 05, 06)';
PRINT '- Trường hợp Chờ thanh toán: 2 phiếu (PDS_TEST02, 07)';
PRINT '- Tất cả đều có TrangThaiThanhToan = 0 trong ChiTietPhieuDatSan';
PRINT '- Tất cả hóa đơn đều Chưa thanh toán';
