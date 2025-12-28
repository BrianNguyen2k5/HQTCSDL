--Chuc Vu
INSERT INTO ChucVu (MaChucVu, TenChucVu) VALUES
('CV01', N'Quản lý'),
('CV02', N'Lễ tân'),
('CV03', N'Kỹ thuật'),
('CV04', N'Thu ngân'),
('CV05', N'Huấn luyện viên');

--CoSo
INSERT INTO CoSo (MaCoSo, TenCoSo, DiaChi) VALUES
('CS01', N'TP Hồ Chí Minh', N'TP Hồ Chí Minh'),
('CS02', N'Long An', N'Long An'),
('CS03', N'Cần Thơ', N'Cần Thơ'),
('CS04', N'Bến Tre', N'Bến Tre'),
('CS05', N'Tiền Giang', N'Tiền Giang');

--LoaiSan
INSERT INTO LoaiSan (MaLoaiSan, TenLoaiSan, DonViTinhTheoPhut, GiaGoc, MoTa) VALUES
('LS01', N'Bóng đá mini', 90, 600000, N'Thuê theo trận 90 phút'),
('LS02', N'Cầu lông', 60, 150000, N'Thuê theo giờ'),
('LS03', N'Tennis', 120, 400000, N'Thuê theo ca 2 giờ'),
('LS04', N'Bóng rổ', 60, 200000, N'Thuê theo giờ'),
('LS05', N'Futsal', 60, 500000, N'Thuê theo giờ');

--KhungGio
INSERT INTO KhungGio (MaKhungGio, GioBatDau, GioKetThuc) VALUES
('KG01', '06:00', '15:59'),  -- Sáng
('KG02', '16:00', '23:59'),  -- Tối
('KG03', '00:00', '05:59');  -- Đêm

--NgayLe
INSERT INTO NgayLe (MaNgayLe, TenNgayLe) VALUES
('2025-01-01', N'Tết Dương Lịch'),
('2025-04-30', N'Giải phóng miền Nam'),
('2025-05-01', N'Quốc tế Lao động'),
('2025-09-02', N'Quốc khánh');

--UuDai
INSERT INTO UuDai (MaUuDai, LoaiUuDai, PhanTramGiamGia) VALUES
('UD01', N'Silver', 5),
('UD02', N'Gold', 10),
('UD03', N'Platinum', 20),
('UD04', N'HSSV', 10);

--GoiDichVu
INSERT INTO GoiDichVu (MaGoi, TenGoi, LoaiTaiSan, DonGia, ThoiGianSuDung) VALUES
('GD01', N'Tủ đồ 6 tháng', N'Tủ đồ', 500000, 180),
('GD02', N'Tủ đồ 1 năm', N'Tủ đồ', 900000, 365),
('GD03', N'Phòng tắm VIP 6 tháng', N'Phòng tắm', 1200000, 180),
('GD04', N'Phòng tắm VIP 1 năm', N'Phòng tắm', 2000000, 365);

-- CA TRỰC 
INSERT INTO CaTruc VALUES
('CA01', N'Ca sáng', '06:00', '14:00'),
('CA02', N'Ca chiều', '14:00', '22:00'),
('CA03', N'Ca đêm', '22:00', '06:00');

--BangGiaTangNgayLe
INSERT INTO BangGiaTangNgayLe VALUES
-- Tết Dương lịch
('LS01','2025-01-01',200000),
('LS02','2025-01-01',50000),
('LS03','2025-01-01',100000),
('LS04','2025-01-01',70000),
('LS05','2025-01-01',150000),

-- 30/4
('LS01','2025-04-30',150000),
('LS02','2025-04-30',40000),
('LS03','2025-04-30',80000),
('LS04','2025-04-30',60000),
('LS05','2025-04-30',120000),

-- 1/5
('LS01','2025-05-01',150000),
('LS02','2025-05-01',40000),
('LS03','2025-05-01',80000),
('LS04','2025-05-01',60000),
('LS05','2025-05-01',120000);

--GiaTangCuoiTuan
INSERT INTO BangGiaTangCuoiTuan VALUES
('LS01',100000),
('LS02',30000),
('LS03',70000),
('LS04',50000),
('LS05',90000);

--Dịch Vụ
INSERT INTO DichVu VALUES
('DV01',N'Nước suối',N'Khác',10000,N'Chai'),
('DV02',N'Nước tăng lực',N'Khác',20000,N'Lon'),
('DV03',N'Khăn lạnh',N'Khác',5000,N'Cái'),
('DV04',N'Bóng đá',N'Dụng cụ thể thao',300000,N'Quả'),
('DV05',N'Bóng tennis',N'Dụng cụ thể thao',80000,N'Quả'),
('DV06',N'Vợt cầu lông',N'Dụng cụ thể thao',400000,N'Cái'),
('DV07',N'Áo thể thao',N'Khác',150000,N'Cái'),
('DV08',N'Găng tay thủ môn',N'Dụng cụ thể thao',250000,N'Đôi');


--Khanh hang
DECLARE @Ho TABLE (Ho NVARCHAR(20));
INSERT INTO @Ho VALUES
(N'Nguyễn'), (N'Trần'), (N'Lê'), (N'Phạm'), (N'Võ'),
(N'Hoàng'), (N'Phan'), (N'Vũ'), (N'Đặng'), (N'Bùi'),
(N'Đỗ'), (N'Ngô'), (N'Dương'), (N'Lý');

DECLARE @TenDem TABLE (TenDem NVARCHAR(20));
INSERT INTO @TenDem VALUES
(N'Văn'), (N'Thị'), (N'Minh'), (N'Hoàng'), (N'Quốc'),
(N'Thanh'), (N'Ngọc'), (N'Anh'), (N'Kim'), (N'Thu'),
(N'Hồng'), (N'Đức');

DECLARE @Ten TABLE (Ten NVARCHAR(20));
INSERT INTO @Ten VALUES
(N'An'), (N'Bình'), (N'Chi'), (N'Dũng'), (N'Hà'),
(N'Hải'), (N'Hạnh'), (N'Hiếu'), (N'Hoàng'), (N'Huy'),
(N'Khánh'), (N'Lan'), (N'Linh'), (N'Long'), (N'Mai'),
(N'Nam'), (N'Nga'), (N'Ngân'), (N'Phong'), (N'Phúc'),
(N'Quân'), (N'Sơn'), (N'Tâm'), (N'Thảo'), (N'Thắng'),
(N'Thuận'), (N'Trang'), (N'Trinh'), (N'Tuấn'), (N'Vy');

DECLARE @i INT = 1;

DECLARE @HoVal NVARCHAR(20);
DECLARE @TenDemVal NVARCHAR(20);
DECLARE @TenVal NVARCHAR(20);

WHILE @i <= 300
BEGIN
    -- Lấy họ
    SELECT @HoVal = Ho
    FROM (
        SELECT Ho, ROW_NUMBER() OVER (ORDER BY Ho) rn FROM @Ho
    ) h
    WHERE rn = ((@i - 1) % (SELECT COUNT(*) FROM @Ho)) + 1;

    -- Lấy tên đệm
    SELECT @TenDemVal = TenDem
    FROM (
        SELECT TenDem, ROW_NUMBER() OVER (ORDER BY TenDem) rn FROM @TenDem
    ) td
    WHERE rn = ((@i - 1) % (SELECT COUNT(*) FROM @TenDem)) + 1;

    -- Lấy tên
    SELECT @TenVal = Ten
    FROM (
        SELECT Ten, ROW_NUMBER() OVER (ORDER BY Ten) rn FROM @Ten
    ) t
    WHERE rn = ((@i - 1) % (SELECT COUNT(*) FROM @Ten)) + 1;

    INSERT INTO KhachHang (
        MaKhachHang,
        HoTen,
        NgaySinh,
        SoCCCD,
        SoDienThoai,
        Email
    )
    VALUES (
        'KH' + RIGHT('000' + CAST(@i AS VARCHAR), 3),
        @HoVal + N' ' + @TenDemVal + N' ' + @TenVal,
        DATEADD(YEAR, -20 - (@i % 15), GETDATE()),  -- tuổi 20–35
        RIGHT('300000000000' + CAST(@i AS VARCHAR), 12),
        RIGHT('0970000000' + CAST(@i AS VARCHAR), 10),
        'kh' + CAST(@i AS VARCHAR) + '@gmail.com'
    );

    SET @i += 1;
END;


