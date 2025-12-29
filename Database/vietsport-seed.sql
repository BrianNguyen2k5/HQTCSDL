USE QLDatSan
GO

-- =============================================
-- 1. DỮ LIỆU CẤU HÌNH HỆ THỐNG & DANH MỤC
-- =============================================

-- 1.1. Chức vụ
INSERT INTO ChucVu (MaChucVu, TenChucVu) VALUES
('CV01', N'Quản lý'),
('CV02', N'Lễ tân'),
('CV03', N'Huấn luyện viên'),
('CV04', N'Thu ngân'),
('CV05', N'Kỹ thuật');

-- 1.2. Cơ sở (3 miền)
INSERT INTO CoSo (MaCoSo, TenCoSo, DiaChi) VALUES
('CS01', N'VietSport Cầu Giấy', N'123 Xuân Thủy, Hà Nội'),
('CS02', N'VietSport Quận 7', N'456 Nguyễn Văn Linh, TP.HCM'),
('CS03', N'VietSport Hải Châu', N'789 Lê Duẩn, Đà Nẵng');

-- 1.3. Loại sân & Giá gốc
INSERT INTO LoaiSan (MaLoaiSan, TenLoaiSan, DonViTinh, GiaGoc, MoTa) VALUES
('LS01', N'Sân Bóng Đá Mini', N'Trận', 300000, N'Cỏ nhân tạo, 90 phút'),
('LS02', N'Sân Cầu Lông', N'Giờ', 60000, N'Sàn gỗ, trong nhà'),
('LS03', N'Sân Tennis', N'Ca', 200000, N'Sân cứng, ca 2 giờ');

-- 1.4. Khung giờ & Ca trực
INSERT INTO CaTruc (MaCa, TenCa, GioBatDau, GioKetThuc) VALUES
('CA_S', N'Ca Sáng', '06:00:00', '14:00:00'),
('CA_C', N'Ca Chiều', '14:00:00', '22:00:00');

INSERT INTO KhungGio (MaKhungGio, GioBatDau, GioKetThuc) VALUES
('KG01', '06:00:00', '16:00:00'), -- Giờ thường
('KG02', '16:00:00', '22:00:00'); -- Giờ cao điểm

-- 1.5. Bảng giá phụ thu (Logic nghiệp vụ: Giờ vàng giá cao hơn)
INSERT INTO BangGiaTangKhungGio (MaLoaiSan, MaKhungGio, GiaTang) VALUES
('LS01', 'KG02', 100000), -- Bóng đá tối +100k
('LS02', 'KG02', 20000),  -- Cầu lông tối +20k
('LS03', 'KG02', 50000);  -- Tennis tối +50k

-- 1.6. Dịch vụ (Lưu ý: sẽ set tồn kho thấp ở phần sau để test đồng thời)
INSERT INTO DichVu (MaDichVu, TenDichVu, LoaiDichVu, DonGia, DonViTinh, TrangThaiKhaDung) VALUES
('DV01', N'Nước khoáng Lavie', N'Giải khát', 10000, N'Chai', 1),
('DV02', N'Thuê Vợt Cầu Lông VIP', N'Dụng cụ', 50000, N'Cái', 1), -- Item hot để test tranh chấp
('DV03', N'Thuê Bóng Động Lực', N'Dụng cụ', 30000, N'Quả', 1),
('DV04', N'Khăn lạnh', N'Khác', 5000, N'Cái', 1);

-- =============================================
-- 2. DỮ LIỆU TÀI NGUYÊN (SÂN, KHO, NHÂN SỰ)
-- =============================================

-- 2.1. Nhân viên (Mỗi cơ sở có đủ bộ sậu)
-- Quản lý
INSERT INTO NhanVien (MaNhanVien, HoTen, NgaySinh, GioiTinh, SoCCCD, SoDienThoai, LuongCoBan, NgayVaoLam, TrangThai, MaCoSo, MaChucVu) VALUES
('NV01', N'Nguyễn Văn Quản', '1985-01-01', N'Nam', '001085000001', '0901000001', 20000000, '2020-01-01', N'Đang làm việc', 'CS01', 'CV01');
-- Lễ tân & Thu ngân (CS01)
INSERT INTO NhanVien (MaNhanVien, HoTen, NgaySinh, GioiTinh, SoCCCD, SoDienThoai, LuongCoBan, NgayVaoLam, TrangThai, MaQuanLy, MaCoSo, MaChucVu) VALUES
('NV02', N'Trần Thị Lễ Tân', '1998-05-05', N'Nữ', '001098000002', '0901000002', 7000000, '2022-01-01', N'Đang làm việc', 'NV01', 'CS01', 'CV02'),
('NV03', N'Lê Văn Thu Ngân', '1995-10-10', N'Nam', '001095000003', '0901000003', 8000000, '2021-06-01', N'Đang làm việc', 'NV01', 'CS01', 'CV04');

-- 2.2. Huấn luyện viên (Để test đặt lịch HLV trùng giờ)
INSERT INTO NhanVien (MaNhanVien, HoTen, NgaySinh, GioiTinh, SoCCCD, SoDienThoai, LuongCoBan, NgayVaoLam, TrangThai, MaQuanLy, MaCoSo, MaChucVu) VALUES
('NV04', N'Phan HLV Pro', '1990-01-01', N'Nam', '001090000004', '0901000004', 10000000, '2023-01-01', N'Đang làm việc', 'NV01', 'CS01', 'CV03');

INSERT INTO HuanLuyenVien (MaHLV, ChuyenMon, MucLuongTheoGio, KinhNghiem) VALUES
('NV04', N'Tennis', 300000, N'Kiện tướng quốc gia');

-- 2.3. Sân bãi
-- Tạo Sân tại CS01 (Hà Nội)
INSERT INTO San (MaSan, TenSan, TinhTrang, SucChua, MaCoSo, MaLoaiSan) VALUES
-- Sân Bóng Đá
('S01', N'Sân Bóng 1 (VIP)', N'ConTrong', 14, 'CS01', 'LS01'),
('S02', N'Sân Bóng 2', N'DangSuDung', 14, 'CS01', 'LS01'),
-- Sân Cầu Lông (Nhiều sân để test tìm kiếm)
('S03', N'Sân Cầu Lông A', N'ConTrong', 4, 'CS01', 'LS02'),
('S04', N'Sân Cầu Lông B', N'BaoTri', 4, 'CS01', 'LS02'), 
-- Sân Tennis (Để test tranh chấp booking duy nhất)
('S05', N'Sân Tennis Trung Tâm', N'ConTrong', 4, 'CS01', 'LS03');

-- 2.4. Tồn kho (QUAN TRỌNG CHO TRANSACTION)
INSERT INTO TonKho (MaDichVu, MaCoSo, SoLuong) VALUES
('DV01', 'CS01', 1000), -- Nước: Thoải mái
('DV02', 'CS01', 1),    -- Vợt VIP: CHỈ CÒN 1 CÁI -> Dùng để test Race Condition (2 người cùng thuê)
('DV03', 'CS01', 10),
('DV04', 'CS01', 50);

-- =============================================
-- 3. DỮ LIỆU KHÁCH HÀNG & TÀI KHOẢN
-- =============================================

INSERT INTO KhachHang (MaKhachHang, HoTen, NgaySinh, SoCCCD, SoDienThoai, Email) VALUES
('KH01', N'Lê A (Khách Thường)', '2000-01-01', '012345678901', '0912345678', 'lea@test.com'),
('KH02', N'Trần B (Đại Gia)', '1990-01-01', '012345678902', '0912345679', 'tranb@test.com'),
('KH03', N'Nguyễn C (Hủy Kèo)', '2002-01-01', '012345678903', '0912345680', 'nguyenc@test.com');

INSERT INTO TaiKhoan (TenDangNhap, MatKhauMaHoa, Email, TrangThai, MaKhachHang, MaNhanVien) VALUES
('khach01', 'pass123', 'lea@test.com', 1, 'KH01', NULL),
('khach02', 'pass123', 'tranb@test.com', 1, 'KH02', NULL),
('staff01', 'pass123', 'letan@test.com', 1, NULL, 'NV02');

-- -- =============================================
-- -- 4. DỮ LIỆU GIAO DỊCH (ĐỂ TEST ĐỒNG THỜI)
-- -- =============================================

-- /* 
--    KỊCH BẢN TEST 1: DOUBLE BOOKING (Phantom Read / Lost Update)
--    Mục tiêu: 2 Khách cùng đặt Sân S05 (Tennis) vào khung giờ 18:00 - 20:00 ngày mai.
--    Dữ liệu chuẩn bị: Sân S05 đang trạng thái 'ConTrong'. Chưa có phiếu đặt nào trùng giờ này.
-- */
-- -- (Không cần insert thêm, S05 đã sẵn sàng)


-- /* 
--    KỊCH BẢN TEST 2: DEADLOCK (Cập nhật chéo)
--    Mục tiêu: 
--    - Trans A: Khóa Phiếu PDS_DL_01 để cập nhật trạng thái -> Cần khóa Kho để trả đồ.
--    - Trans B: Khóa Kho để xuất đồ -> Cần khóa Phiếu PDS_DL_01 để thêm chi tiết dịch vụ.
-- */
-- -- Tạo sẵn 1 phiếu đặt đang trạng thái 'Đã xác nhận'
-- INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, MaKhachHang, MaNhanVien, MaSan) VALUES
-- ('PDS_D', GETDATE(), DATEADD(day, 1, GETDATE()), '18:00:00', '20:00:00', N'Online', N'Đã xác nhận', 'KH01', NULL, 'S03');


-- /* 
--    KỊCH BẢN TEST 3: UNREPEATABLE READ (Đọc không lặp lại)
--    Mục tiêu: Nhân viên đang xem báo cáo doanh thu thì có hóa đơn mới được thanh toán chèn vào.
-- */
-- -- Tạo dữ liệu lịch sử hóa đơn tháng này
-- INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, MaKhachHang, MaNhanVien, MaSan) VALUES
-- ('POLD1', '2023-10-01', '2023-10-01', '08:00:00', '10:00:00', N'Online', N'Hoàn thành', 'KH02', 'NV02', 'S01'),
-- ('POLD2', '2023-10-02', '2023-10-02', '18:00:00', '19:30:00', N'Tại quầy', N'Hoàn thành', 'KH01', 'NV02', 'S02');

-- INSERT INTO HoaDon (MaHoaDon, NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat) VALUES
-- ('HD01', '2023-10-01 10:15:00', 300000, 50000, 0, 350000, N'Chuyển khoản', N'Đã thanh toán', 'NV03', 'POLD1'),
-- ('HD02', '2023-10-02 19:45:00', 450000, 20000, 0, 470000, N'Tiền mặt', N'Đã thanh toán', 'NV03', 'POLD2');


-- /* 
--    KỊCH BẢN TEST 4: LOST UPDATE (Kho hàng)
--    Mục tiêu: 2 Khách hàng cùng đặt dịch vụ "Thuê Vợt VIP" (DV02) mà kho chỉ còn 1 cái.
--    Dữ liệu chuẩn bị: DV02 tại CS01 có SoLuong = 1.
-- */
-- -- (Không cần insert thêm, DV02 đã set SoLuong = 1 ở trên)


-- /*
--    KỊCH BẢN TEST 5: TIMEOUT / HỦY TỰ ĐỘNG
--    Mục tiêu: Kiểm tra job quét các phiếu chưa thanh toán quá 30 phút.
-- */
-- INSERT INTO PhieuDatSan (MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, HinhThucDat, TrangThaiPhieu, MaKhachHang, MaNhanVien, MaSan) VALUES
-- ('P_EXP', DATEADD(minute, -35, GETDATE()), DATEADD(day, 2, GETDATE()), '09:00:00', '10:00:00', N'Tại quầy', N'Chờ thanh toán', 'KH03', 'NV02', 'S01');
-- -- Phiếu này đã đặt cách đây 35 phút nhưng chưa thanh toán -> Khi chạy Trans kiểm tra sẽ phải chuyển sang 'Đã hủy'.

GO