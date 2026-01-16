use VietSport
go

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
('UD04', N'HSSV', 10),
('UD05', N'Người Cao Tuổi', 10)

--GoiDichVu
INSERT INTO GoiDichVu (MaGoi, TenGoi, LoaiTaiSan, DonGia, ThoiGianSuDung) VALUES
('GD01', N'Tủ đồ 6 tháng', N'Tủ đồ', 500000, 180),
('GD02', N'Tủ đồ 1 năm', N'Tủ đồ', 900000, 365),
('GD03', N'Phòng tắm VIP 6 tháng', N'Phòng tắm VIP', 1200000, 180),
('GD04', N'Phòng tắm VIP 1 năm', N'Phòng tắm VIP', 2000000, 365);

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
('DV01',N'Áo bib',N'Dụng cụ thể thao',100000,N'Cái'),
('DV02',N'Vợt Cầu Lông VIP',N'Dụng cụ thể thao',100000,N'Cái'),
('DV03',N'Bóng Động Lực',N'Dụng cụ thể thao',50000,N'Quả'),
('DV04',N'Lưới',N'Dụng cụ thể thao',50000,N'Cái'),
('DV05',N'Nước uống',N'Khác',10000,N'Chai'),
('DV06',N'Áo đấu đồng phục',N'Khác',100000,N'Cái'),
('DV07',N'Thuê trọng tài',N'Khác',200000,N'Người')


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

--Cơ sở 1 
INSERT INTO NhanVien VALUES
-- Quản lý
('NV001',N'Nguyễn Văn Minh','1985-05-10',N'Nam','001000000001',N'TP Hồ Chí Minh','0900000001',20000000,5000000,'2015-01-01',N'Đang làm',NULL,'CS01','CV01'),

-- Kỹ thuật
('NV002',N'Trần Quốc Bảo','1990-03-12',N'Nam','001000000002',N'TP Hồ Chí Minh','0900000002',12000000,2000000,'2018-03-01',N'Đang làm','NV001','CS01','CV03'),

-- Thu ngân (3)
('NV003',N'Lê Thị Thu Hà','1998-01-01',N'Nữ','001000000003',N'TP Hồ Chí Minh','0900000003',9000000,1000000,'2020-01-01',N'Đang làm','NV001','CS01','CV04'),
('NV004',N'Phạm Ngọc Ánh','1999-01-01',N'Nữ','001000000004',N'TP Hồ Chí Minh','0900000004',9000000,1000000,'2020-01-01',N'Đang làm','NV001','CS01','CV04'),
('NV005',N'Võ Thị Kim Ngân','1997-01-01',N'Nữ','001000000005',N'TP Hồ Chí Minh','0900000005',9000000,1000000,'2020-01-01',N'Đang làm','NV001','CS01','CV04'),

-- Lễ tân (3)
('NV006',N'Nguyễn Thị Mai Anh','2000-01-01',N'Nữ','001000000006',N'TP Hồ Chí Minh','0900000006',8500000,800000,'2021-01-01',N'Đang làm','NV001','CS01','CV02'),
('NV007',N'Trần Thị Thanh Trúc','2001-01-01',N'Nữ','001000000007',N'TP Hồ Chí Minh','0900000007',8500000,800000,'2021-01-01',N'Đang làm','NV001','CS01','CV02'),
('NV008',N'Lâm Ngọc Bích','1999-01-01',N'Nữ','001000000008',N'TP Hồ Chí Minh','0900000008',8500000,800000,'2021-01-01',N'Đang làm','NV001','CS01','CV02'),

-- Huấn luyện viên (4)
('NV009',N'Phạm Quốc Huy','1992-01-01',N'Nam','001000000009',N'TP Hồ Chí Minh','0900000009',10000000,2000000,'2019-01-01',N'Đang làm','NV001','CS01','CV05'),
('NV010',N'Nguyễn Anh Tuấn','1993-01-01',N'Nam','001000000010',N'TP Hồ Chí Minh','0900000010',10000000,2000000,'2019-01-01',N'Đang làm','NV001','CS01','CV05'),
('NV011',N'Bùi Minh Long','1991-01-01',N'Nam','001000000011',N'TP Hồ Chí Minh','0900000011',10000000,2000000,'2019-01-01',N'Đang làm','NV001','CS01','CV05'),
('NV012',N'Hoàng Văn Phúc','1994-01-01',N'Nam','001000000012',N'TP Hồ Chí Minh','0900000012',10000000,2000000,'2019-01-01',N'Đang làm','NV001','CS01','CV05');

INSERT INTO HuanLuyenVien VALUES
('NV009', N'Bóng đá', 300000, N'5 năm kinh nghiệm'),
('NV010', N'Tennis', 350000, N'7 năm kinh nghiệm'),
('NV011', N'Cầu lông', 250000, N'4 năm kinh nghiệm'),
('NV012', N'Bóng rổ', 280000, N'6 năm kinh nghiệm');


--Cơ sở 2
INSERT INTO NhanVien VALUES
('NV021',N'Đặng Văn Hòa','1984-01-01',N'Nam','002000000021',N'Long An','0910000021',20000000,5000000,'2015-01-01',N'Đang làm',NULL,'CS02','CV01'),
('NV022',N'Ngô Minh Trí','1989-01-01',N'Nam','002000000022',N'Long An','0910000022',12000000,2000000,'2018-01-01',N'Đang làm','NV021','CS02','CV03'),

('NV023',N'Nguyễn Thị Thanh Tuyền','1998-01-01',N'Nữ','002000000023',N'Long An','0910000023',9000000,1000000,'2020-01-01',N'Đang làm','NV021','CS02','CV04'),
('NV024',N'Phạm Thị Bích Ngọc','1999-01-01',N'Nữ','002000000024',N'Long An','0910000024',9000000,1000000,'2020-01-01',N'Đang làm','NV021','CS02','CV04'),
('NV025',N'Lê Thị Hồng Nhung','1997-01-01',N'Nữ','002000000025',N'Long An','0910000025',9000000,1000000,'2020-01-01',N'Đang làm','NV021','CS02','CV04'),

('NV026',N'Trần Ngọc Mai','2000-01-01',N'Nữ','002000000026',N'Long An','0910000026',8500000,800000,'2021-01-01',N'Đang làm','NV021','CS02','CV02'),
('NV027',N'Võ Thị Kim Oanh','2001-01-01',N'Nữ','002000000027',N'Long An','0910000027',8500000,800000,'2021-01-01',N'Đang làm','NV021','CS02','CV02'),
('NV028',N'Nguyễn Thị Thanh Vân','1999-01-01',N'Nữ','002000000028',N'Long An','0910000028',8500000,800000,'2021-01-01',N'Đang làm','NV021','CS02','CV02'),

('NV029',N'Phan Quốc Dũng','1992-01-01',N'Nam','002000000029',N'Long An','0910000029',10000000,2000000,'2019-01-01',N'Đang làm','NV021','CS02','CV05'),
('NV030',N'Lê Văn Cường','1993-01-01',N'Nam','002000000030',N'Long An','0910000030',10000000,2000000,'2019-01-01',N'Đang làm','NV021','CS02','CV05'),
('NV031',N'Nguyễn Minh Tài','1991-01-01',N'Nam','002000000031',N'Long An','0910000031',10000000,2000000,'2019-01-01',N'Đang làm','NV021','CS02','CV05'),
('NV032',N'Trần Anh Khoa','1994-01-01',N'Nam','002000000032',N'Long An','0910000032',10000000,2000000,'2019-01-01',N'Đang làm','NV021','CS02','CV05');

-- HLV CS02
INSERT INTO HuanLuyenVien VALUES
('NV029',N'Bóng đá',300000,N'5 năm'),
('NV030',N'Tennis',350000,N'6 năm'),
('NV031',N'Cầu lông',250000,N'4 năm'),
('NV032',N'Bóng rổ',280000,N'5 năm');


--Cơ sở 3
INSERT INTO NhanVien VALUES
('NV041',N'Nguyễn Thành Đạt','1983-01-01',N'Nam','003000000041',N'Cần Thơ','0920000041',20000000,5000000,'2015-01-01',N'Đang làm',NULL,'CS03','CV01'),
('NV042',N'Trần Minh Quân','1989-01-01',N'Nam','003000000042',N'Cần Thơ','0920000042',12000000,2000000,'2018-01-01',N'Đang làm','NV041','CS03','CV03'),

('NV043',N'Lê Thị Mỹ Duyên','1998-01-01',N'Nữ','003000000043',N'Cần Thơ','0920000043',9000000,1000000,'2020-01-01',N'Đang làm','NV041','CS03','CV04'),
('NV044',N'Phạm Thị Ngọc Hân','1999-01-01',N'Nữ','003000000044',N'Cần Thơ','0920000044',9000000,1000000,'2020-01-01',N'Đang làm','NV041','CS03','CV04'),
('NV045',N'Võ Thị Thanh Thảo','1997-01-01',N'Nữ','003000000045',N'Cần Thơ','0920000045',9000000,1000000,'2020-01-01',N'Đang làm','NV041','CS03','CV04'),

('NV046',N'Nguyễn Thị Kim Chi','2000-01-01',N'Nữ','003000000046',N'Cần Thơ','0920000046',8500000,800000,'2021-01-01',N'Đang làm','NV041','CS03','CV02'),
('NV047',N'Trần Thị Thu Uyên','2001-01-01',N'Nữ','003000000047',N'Cần Thơ','0920000047',8500000,800000,'2021-01-01',N'Đang làm','NV041','CS03','CV02'),
('NV048',N'Lâm Ngọc Trinh','1999-01-01',N'Nữ','003000000048',N'Cần Thơ','0920000048',8500000,800000,'2021-01-01',N'Đang làm','NV041','CS03','CV02'),

('NV049',N'Nguyễn Quốc Khánh','1992-01-01',N'Nam','003000000049',N'Cần Thơ','0920000049',10000000,2000000,'2019-01-01',N'Đang làm','NV041','CS03','CV05'),
('NV050',N'Phạm Văn Long','1993-01-01',N'Nam','003000000050',N'Cần Thơ','0920000050',10000000,2000000,'2019-01-01',N'Đang làm','NV041','CS03','CV05'),
('NV051',N'Bùi Minh Đức','1991-01-01',N'Nam','003000000051',N'Cần Thơ','0920000051',10000000,2000000,'2019-01-01',N'Đang làm','NV041','CS03','CV05'),
('NV052',N'Hoàng Thanh Tùng','1994-01-01',N'Nam','003000000052',N'Cần Thơ','0920000052',10000000,2000000,'2019-01-01',N'Đang làm','NV041','CS03','CV05');

INSERT INTO HuanLuyenVien VALUES
('NV049',N'Bóng đá',300000,N'5 năm'),
('NV050',N'Tennis',350000,N'6 năm'),
('NV051',N'Cầu lông',250000,N'4 năm'),
('NV052',N'Bóng rổ',280000,N'5 năm');


--Cơ sở 4
INSERT INTO NhanVien VALUES
-- Quản lý
('NV061',N'Nguyễn Văn Hòa','1984-01-01',N'Nam','004000000061',N'Bến Tre','0930000061',20000000,5000000,'2015-01-01',N'Đang làm',NULL,'CS04','CV01'),

-- Kỹ thuật
('NV062',N'Trần Minh Tuấn','1989-01-01',N'Nam','004000000062',N'Bến Tre','0930000062',12000000,2000000,'2018-01-01',N'Đang làm','NV061','CS04','CV03'),

-- Thu ngân (3)
('NV063',N'Lê Thị Thanh','1998-01-01',N'Nữ','004000000063',N'Bến Tre','0930000063',9000000,1000000,'2020-01-01',N'Đang làm','NV061','CS04','CV04'),
('NV064',N'Phạm Ngọc Diễm','1999-01-01',N'Nữ','004000000064',N'Bến Tre','0930000064',9000000,1000000,'2020-01-01',N'Đang làm','NV061','CS04','CV04'),
('NV065',N'Võ Thị Hồng','1997-01-01',N'Nữ','004000000065',N'Bến Tre','0930000065',9000000,1000000,'2020-01-01',N'Đang làm','NV061','CS04','CV04'),

-- Lễ tân (3)
('NV066',N'Nguyễn Thị Mai','2000-01-01',N'Nữ','004000000066',N'Bến Tre','0930000066',8500000,800000,'2021-01-01',N'Đang làm','NV061','CS04','CV02'),
('NV067',N'Trương Mỹ Linh','2001-01-01',N'Nữ','004000000067',N'Bến Tre','0930000067',8500000,800000,'2021-01-01',N'Đang làm','NV061','CS04','CV02'),
('NV068',N'Lâm Thị Ngọc','1999-01-01',N'Nữ','004000000068',N'Bến Tre','0930000068',8500000,800000,'2021-01-01',N'Đang làm','NV061','CS04','CV02'),

-- Huấn luyện viên (4)
('NV069',N'Nguyễn Quốc Dũng','1992-01-01',N'Nam','004000000069',N'Bến Tre','0930000069',10000000,2000000,'2019-01-01',N'Đang làm','NV061','CS04','CV05'),
('NV070',N'Phan Văn Khánh','1993-01-01',N'Nam','004000000070',N'Bến Tre','0930000070',10000000,2000000,'2019-01-01',N'Đang làm','NV061','CS04','CV05'),
('NV071',N'Bùi Minh Tài','1991-01-01',N'Nam','004000000071',N'Bến Tre','0930000071',10000000,2000000,'2019-01-01',N'Đang làm','NV061','CS04','CV05'),
('NV072',N'Hoàng Anh Tuấn','1994-01-01',N'Nam','004000000072',N'Bến Tre','0930000072',10000000,2000000,'2019-01-01',N'Đang làm','NV061','CS04','CV05');

-- HLV – CS04
INSERT INTO HuanLuyenVien VALUES
('NV069',N'Bóng đá',300000,N'5 năm kinh nghiệm'),
('NV070',N'Tennis',350000,N'6 năm kinh nghiệm'),
('NV071',N'Cầu lông',250000,N'4 năm kinh nghiệm'),
('NV072',N'Bóng rổ',280000,N'5 năm kinh nghiệm');

--Cơ Sở 5
INSERT INTO NhanVien VALUES
-- Quản lý
('NV081',N'Đặng Văn Phúc','1984-01-01',N'Nam','005000000081',N'Tiền Giang','0940000081',20000000,5000000,'2015-01-01',N'Đang làm',NULL,'CS05','CV01'),

-- Kỹ thuật
('NV082',N'Ngô Minh Trí','1989-01-01',N'Nam','005000000082',N'Tiền Giang','0940000082',12000000,2000000,'2018-01-01',N'Đang làm','NV081','CS05','CV03'),

-- Thu ngân (3)
('NV083',N'Nguyễn Thị Bích','1998-01-01',N'Nữ','005000000083',N'Tiền Giang','0940000083',9000000,1000000,'2020-01-01',N'Đang làm','NV081','CS05','CV04'),
('NV084',N'Phạm Thị Yến','1999-01-01',N'Nữ','005000000084',N'Tiền Giang','0940000084',9000000,1000000,'2020-01-01',N'Đang làm','NV081','CS05','CV04'),
('NV085',N'Vũ Thị Kim','1997-01-01',N'Nữ','005000000085',N'Tiền Giang','0940000085',9000000,1000000,'2020-01-01',N'Đang làm','NV081','CS05','CV04'),

-- Lễ tân (3)
('NV086',N'Lê Thị Thu','2000-01-01',N'Nữ','005000000086',N'Tiền Giang','0940000086',8500000,800000,'2021-01-01',N'Đang làm','NV081','CS05','CV02'),
('NV087',N'Trần Ngọc Hân','2001-01-01',N'Nữ','005000000087',N'Tiền Giang','0940000087',8500000,800000,'2021-01-01',N'Đang làm','NV081','CS05','CV02'),
('NV088',N'Nguyễn Thị Lan','1999-01-01',N'Nữ','005000000088',N'Tiền Giang','0940000088',8500000,800000,'2021-01-01',N'Đang làm','NV081','CS05','CV02'),

-- Huấn luyện viên (4)
('NV089',N'Phạm Quốc Huy','1992-01-01',N'Nam','005000000089',N'Tiền Giang','0940000089',10000000,2000000,'2019-01-01',N'Đang làm','NV081','CS05','CV05'),
('NV090',N'Lê Văn Cường','1993-01-01',N'Nam','005000000090',N'Tiền Giang','0940000090',10000000,2000000,'2019-01-01',N'Đang làm','NV081','CS05','CV05'),
('NV091',N'Nguyễn Minh Long','1991-01-01',N'Nam','005000000091',N'Tiền Giang','0940000091',10000000,2000000,'2019-01-01',N'Đang làm','NV081','CS05','CV05'),
('NV092',N'Đỗ Thanh Bình','1994-01-01',N'Nam','005000000092',N'Tiền Giang','0940000092',10000000,2000000,'2019-01-01',N'Đang làm','NV081','CS05','CV05');

-- HLV – CS05
INSERT INTO HuanLuyenVien VALUES
('NV089',N'Bóng đá',300000,N'5 năm kinh nghiệm'),
('NV090',N'Tennis',350000,N'6 năm kinh nghiệm'),
('NV091',N'Cầu lông',250000,N'4 năm kinh nghiệm'),
('NV092',N'Bóng rổ',280000,N'5 năm kinh nghiệm');



--Lich Làm Việc
--CS1
INSERT INTO LichLamViec VALUES
-- NV009
('NV009',2,'06:00','10:00'),
('NV009',4,'16:00','20:00'),
('NV009',6,'06:00','10:00'),

-- NV010
('NV010',2,'16:00','20:00'),
('NV010',3,'06:00','10:00'),
('NV010',5,'16:00','20:00'),

-- NV011
('NV011',3,'16:00','20:00'),
('NV011',4,'06:00','10:00'),
('NV011',6,'16:00','20:00'),

-- NV012
('NV012',2,'06:00','10:00'),
('NV012',5,'06:00','10:00'),
('NV012',7,'16:00','20:00');

--CS2
INSERT INTO LichLamViec VALUES
-- NV029
('NV029',2,'06:00','10:00'),
('NV029',4,'16:00','20:00'),
('NV029',6,'06:00','10:00'),

-- NV030
('NV030',3,'06:00','10:00'),
('NV030',5,'16:00','20:00'),
('NV030',7,'06:00','10:00'),

-- NV031
('NV031',2,'16:00','20:00'),
('NV031',4,'06:00','10:00'),
('NV031',6,'16:00','20:00'),

-- NV032
('NV032',3,'16:00','20:00'),
('NV032',5,'06:00','10:00'),
('NV032',7,'16:00','20:00');

--CS3
INSERT INTO LichLamViec VALUES
-- NV049
('NV049',2,'06:00','10:00'),
('NV049',4,'16:00','20:00'),
('NV049',6,'06:00','10:00'),

-- NV050
('NV050',3,'06:00','10:00'),
('NV050',5,'16:00','20:00'),
('NV050',7,'06:00','10:00'),

-- NV051
('NV051',2,'16:00','20:00'),
('NV051',4,'06:00','10:00'),
('NV051',6,'16:00','20:00'),

-- NV052
('NV052',3,'16:00','20:00'),
('NV052',5,'06:00','10:00'),
('NV052',7,'16:00','20:00');

--CS4
INSERT INTO LichLamViec VALUES
-- NV069
('NV069',2,'06:00','10:00'),
('NV069',4,'16:00','20:00'),
('NV069',6,'06:00','10:00'),

-- NV070
('NV070',3,'06:00','10:00'),
('NV070',5,'16:00','20:00'),
('NV070',7,'06:00','10:00'),

-- NV071
('NV071',2,'16:00','20:00'),
('NV071',4,'06:00','10:00'),
('NV071',6,'16:00','20:00'),

-- NV072
('NV072',3,'16:00','20:00'),
('NV072',5,'06:00','10:00'),
('NV072',7,'16:00','20:00');

--CS5
INSERT INTO LichLamViec VALUES
-- NV089
('NV089',2,'06:00','10:00'),
('NV089',4,'16:00','20:00'),
('NV089',6,'06:00','10:00'),

-- NV090
('NV090',3,'06:00','10:00'),
('NV090',5,'16:00','20:00'),
('NV090',7,'06:00','10:00'),

-- NV091
('NV091',2,'16:00','20:00'),
('NV091',4,'06:00','10:00'),
('NV091',6,'16:00','20:00'),

-- NV092
('NV092',3,'16:00','20:00'),
('NV092',5,'06:00','10:00'),
('NV092',7,'16:00','20:00');

--Phân Công Ca Trực
--CS1
INSERT INTO PhanCongCaTruc VALUES
-- Kỹ thuật
('CA01','NV002','2025-01-10','NV001'),
('CA02','NV002','2025-01-12','NV001'),

-- Thu ngân
('CA01','NV003','2025-01-10','NV001'),
('CA02','NV003','2025-01-11','NV001'),
('CA03','NV003','2025-01-13','NV001'),

('CA02','NV004','2025-01-10','NV001'),
('CA03','NV004','2025-01-12','NV001'),

('CA03','NV005','2025-01-10','NV001'),
('CA01','NV005','2025-01-11','NV001'),
('CA02','NV005','2025-01-13','NV001'),

-- Lễ tân
('CA01','NV006','2025-01-10','NV001'),
('CA02','NV006','2025-01-12','NV001'),

('CA02','NV007','2025-01-10','NV001'),
('CA03','NV007','2025-01-11','NV001'),

('CA03','NV008','2025-01-10','NV001'),
('CA01','NV008','2025-01-12','NV001'),
('CA02','NV008','2025-01-13','NV001');

--CS2
INSERT INTO PhanCongCaTruc VALUES
-- Kỹ thuật
('CA01','NV022','2025-01-10','NV021'),
('CA02','NV022','2025-01-12','NV021'),

-- Thu ngân
('CA01','NV023','2025-01-10','NV021'),
('CA02','NV023','2025-01-11','NV021'),

('CA02','NV024','2025-01-10','NV021'),
('CA03','NV024','2025-01-12','NV021'),

('CA03','NV025','2025-01-11','NV021'),
('CA01','NV025','2025-01-13','NV021'),

-- Lễ tân
('CA01','NV026','2025-01-10','NV021'),
('CA02','NV026','2025-01-12','NV021'),

('CA02','NV027','2025-01-11','NV021'),
('CA03','NV027','2025-01-13','NV021'),

('CA03','NV028','2025-01-10','NV021'),
('CA01','NV028','2025-01-12','NV021');

--CS3
INSERT INTO PhanCongCaTruc VALUES
-- Kỹ thuật
('CA01','NV042','2025-01-10','NV041'),
('CA02','NV042','2025-01-12','NV041'),

-- Thu ngân
('CA01','NV043','2025-01-10','NV041'),
('CA02','NV043','2025-01-11','NV041'),

('CA02','NV044','2025-01-10','NV041'),
('CA03','NV044','2025-01-12','NV041'),

('CA03','NV045','2025-01-11','NV041'),
('CA01','NV045','2025-01-13','NV041'),

-- Lễ tân
('CA01','NV046','2025-01-10','NV041'),
('CA02','NV046','2025-01-12','NV041'),

('CA02','NV047','2025-01-11','NV041'),
('CA03','NV047','2025-01-13','NV041'),

('CA03','NV048','2025-01-10','NV041'),
('CA01','NV048','2025-01-12','NV041');

--CS4
INSERT INTO PhanCongCaTruc VALUES
-- Kỹ thuật
('CA01','NV062','2025-01-10','NV061'),
('CA02','NV062','2025-01-12','NV061'),

-- Thu ngân
('CA01','NV063','2025-01-10','NV061'),
('CA02','NV063','2025-01-11','NV061'),

('CA02','NV064','2025-01-10','NV061'),
('CA03','NV064','2025-01-12','NV061'),

('CA03','NV065','2025-01-11','NV061'),
('CA01','NV065','2025-01-13','NV061'),

-- Lễ tân
('CA01','NV066','2025-01-10','NV061'),
('CA02','NV066','2025-01-12','NV061'),

('CA02','NV067','2025-01-11','NV061'),
('CA03','NV067','2025-01-13','NV061'),

('CA03','NV068','2025-01-10','NV061'),
('CA01','NV068','2025-01-12','NV061');

--CS5
INSERT INTO PhanCongCaTruc VALUES
-- Kỹ thuật
('CA01','NV082','2025-01-10','NV081'),
('CA02','NV082','2025-01-12','NV081'),

-- Thu ngân
('CA01','NV083','2025-01-10','NV081'),
('CA02','NV083','2025-01-11','NV081'),

('CA02','NV084','2025-01-10','NV081'),
('CA03','NV084','2025-01-12','NV081'),

('CA03','NV085','2025-01-11','NV081'),
('CA01','NV085','2025-01-13','NV081'),

-- Lễ tân
('CA01','NV086','2025-01-10','NV081'),
('CA02','NV086','2025-01-12','NV081'),

('CA02','NV087','2025-01-11','NV081'),
('CA03','NV087','2025-01-13','NV081'),

('CA03','NV088','2025-01-10','NV081'),
('CA01','NV088','2025-01-12','NV081');

--DonNghiPhep
INSERT INTO DonNghiPhep VALUES
-- CS01
('DN01','2025-01-05',N'Nghỉ ốm',N'Đã Duyệt','NV003','NV001','NV004'),
('DN02','2025-01-07',N'Việc gia đình',N'Đã Duyệt','NV006','NV001','NV007'),
('DN03','2025-01-10',N'Nghỉ cá nhân',N'Đang chờ duyệt','NV005','NV001',NULL),

-- CS02
('DN04','2025-01-06',N'Nghỉ ốm',N'Đã Duyệt','NV023','NV021','NV024'),
('DN05','2025-01-08',N'Việc riêng',N'Hủy','NV026','NV021',NULL),
('DN06','2025-01-12',N'Nghỉ cưới người thân',N'Đã Duyệt','NV027','NV021','NV028'),

-- CS03
('DN07','2025-01-05',N'Nghỉ thai sản ngắn hạn',N'Đã Duyệt','NV046','NV041','NV047'),
('DN08','2025-01-09',N'Việc gia đình',N'Đang chờ duyệt','NV044','NV041',NULL),
('DN09','2025-01-11',N'Nghỉ cá nhân',N'Hủy','NV045','NV041',NULL),

-- CS04
('DN10','2025-01-06',N'Nghỉ ốm',N'Đã Duyệt','NV063','NV061','NV064'),
('DN11','2025-01-10',N'Việc gia đình',N'Đã Duyệt','NV066','NV061','NV067'),
('DN12','2025-01-13',N'Nghỉ cá nhân',N'Đang chờ duyệt','NV068','NV061',NULL),

-- CS05
('DN13','2025-01-07',N'Nghỉ ốm',N'Đã Duyệt','NV083','NV081','NV084'),
('DN14','2025-01-09',N'Việc riêng',N'Hủy','NV086','NV081',NULL),
('DN15','2025-01-12',N'Nghỉ gia đình',N'Đã Duyệt','NV087','NV081','NV088');


--CS01 – TP HỒ CHÍ MINH (12 SÂN)
INSERT INTO San VALUES
('CS01LS0101',N'Sân Bóng đá mini 1 - CS01',N'Trống',14,'CS01','LS01'),
('CS01LS0102',N'Sân Bóng đá mini 2 - CS01',N'Trống',14,'CS01','LS01'),

('CS01LS0201',N'Sân Cầu lông 1 - CS01',N'Trống',6,'CS01','LS02'),
('CS01LS0202',N'Sân Cầu lông 2 - CS01',N'Trống',6,'CS01','LS02'),

('CS01LS0301',N'Sân Tennis 1 - CS01',N'Trống',4,'CS01','LS03'),
('CS01LS0302',N'Sân Tennis 2 - CS01',N'Trống',4,'CS01','LS03'),

('CS01LS0401',N'Sân Bóng rổ 1 - CS01',N'Trống',10,'CS01','LS04'),
('CS01LS0402',N'Sân Bóng rổ 2 - CS01',N'Trống',10,'CS01','LS04'),

('CS01LS0501',N'Sân Futsal 1 - CS01',N'Trống',10,'CS01','LS05'),
('CS01LS0502',N'Sân Futsal 2 - CS01',N'Trống',10,'CS01','LS05'),

('CS01LS0103',N'Sân Bóng đá mini 3 - CS01',N'Trống',14,'CS01','LS01'),
('CS01LS0104',N'Sân Bóng đá mini 4 - CS01',N'Trống',14,'CS01','LS01');

--CS02 – LONG AN (10 SÂN)
INSERT INTO San VALUES
('CS02LS0101',N'Sân Bóng đá mini 1 - CS02',N'Trống',14,'CS02','LS01'),
('CS02LS0102',N'Sân Bóng đá mini 2 - CS02',N'Trống',14,'CS02','LS01'),

('CS02LS0201',N'Sân Cầu lông 1 - CS02',N'Trống',6,'CS02','LS02'),
('CS02LS0202',N'Sân Cầu lông 2 - CS02',N'Trống',6,'CS02','LS02'),

('CS02LS0301',N'Sân Tennis 1 - CS02',N'Trống',4,'CS02','LS03'),
('CS02LS0302',N'Sân Tennis 2 - CS02',N'Trống',4,'CS02','LS03'),

('CS02LS0401',N'Sân Bóng rổ 1 - CS02',N'Trống',10,'CS02','LS04'),
('CS02LS0402',N'Sân Bóng rổ 2 - CS02',N'Trống',10,'CS02','LS04'),

('CS02LS0501',N'Sân Futsal 1 - CS02',N'Trống',10,'CS02','LS05'),
('CS02LS0502',N'Sân Futsal 2 - CS02',N'Trống',10,'CS02','LS05');

--CS03 – CẦN THƠ (10 SÂN)
INSERT INTO San VALUES
('CS03LS0101',N'Sân Bóng đá mini 1 - CS03',N'Trống',14,'CS03','LS01'),
('CS03LS0102',N'Sân Bóng đá mini 2 - CS03',N'Trống',14,'CS03','LS01'),

('CS03LS0201',N'Sân Cầu lông 1 - CS03',N'Trống',6,'CS03','LS02'),
('CS03LS0202',N'Sân Cầu lông 2 - CS03',N'Trống',6,'CS03','LS02'),

('CS03LS0301',N'Sân Tennis 1 - CS03',N'Trống',4,'CS03','LS03'),
('CS03LS0302',N'Sân Tennis 2 - CS03',N'Trống',4,'CS03','LS03'),

('CS03LS0401',N'Sân Bóng rổ 1 - CS03',N'Trống',10,'CS03','LS04'),
('CS03LS0402',N'Sân Bóng rổ 2 - CS03',N'Trống',10,'CS03','LS04'),

('CS03LS0501',N'Sân Futsal 1 - CS03',N'Trống',10,'CS03','LS05'),
('CS03LS0502',N'Sân Futsal 2 - CS03',N'Trống',10,'CS03','LS05');

--CS04 – BẾN TRE (10 SÂN)
INSERT INTO San VALUES
('CS04LS0101',N'Sân Bóng đá mini 1 - CS04',N'Trống',14,'CS04','LS01'),
('CS04LS0102',N'Sân Bóng đá mini 2 - CS04',N'Trống',14,'CS04','LS01'),

('CS04LS0201',N'Sân Cầu lông 1 - CS04',N'Trống',6,'CS04','LS02'),
('CS04LS0202',N'Sân Cầu lông 2 - CS04',N'Trống',6,'CS04','LS02'),

('CS04LS0301',N'Sân Tennis 1 - CS04',N'Trống',4,'CS04','LS03'),
('CS04LS0302',N'Sân Tennis 2 - CS04',N'Trống',4,'CS04','LS03'),

('CS04LS0401',N'Sân Bóng rổ 1 - CS04',N'Trống',10,'CS04','LS04'),
('CS04LS0402',N'Sân Bóng rổ 2 - CS04',N'Trống',10,'CS04','LS04'),

('CS04LS0501',N'Sân Futsal 1 - CS04',N'Trống',10,'CS04','LS05'),
('CS04LS0502',N'Sân Futsal 2 - CS04',N'Trống',10,'CS04','LS05');

--CS05 – TIỀN GIANG (10 SÂN)
INSERT INTO San VALUES
('CS05LS0101',N'Sân Bóng đá mini 1 - CS05',N'Trống',14,'CS05','LS01'),
('CS05LS0102',N'Sân Bóng đá mini 2 - CS05',N'Trống',14,'CS05','LS01'),

('CS05LS0201',N'Sân Cầu lông 1 - CS05',N'Trống',6,'CS05','LS02'),
('CS05LS0202',N'Sân Cầu lông 2 - CS05',N'Trống',6,'CS05','LS02'),

('CS05LS0301',N'Sân Tennis 1 - CS05',N'Trống',4,'CS05','LS03'),
('CS05LS0302',N'Sân Tennis 2 - CS05',N'Trống',4,'CS05','LS03'),

('CS05LS0401',N'Sân Bóng rổ 1 - CS05',N'Trống',10,'CS05','LS04'),
('CS05LS0402',N'Sân Bóng rổ 2 - CS05',N'Trống',10,'CS05','LS04'),

('CS05LS0501',N'Sân Futsal 1 - CS05',N'Trống',10,'CS05','LS05'),
('CS05LS0502',N'Sân Futsal 2 - CS05',N'Trống',10,'CS05','LS05');


--BangGiaTangKhungGio
INSERT INTO BangGiaTangKhungGio VALUES
-- Bóng đá mini
('LS01','KG01',0),
('LS01','KG02',100000),

-- Cầu lông
('LS02','KG01',0),
('LS02','KG02',30000),

-- Tennis
('LS03','KG01',0),
('LS03','KG02',70000),

-- Bóng rổ
('LS04','KG01',0),
('LS04','KG02',40000),

-- Futsal
('LS05','KG01',0),
('LS05','KG02',80000);

--Ton Kho
INSERT INTO TonKho VALUES
-- CS01
('DV01','CS01',200,1),
('DV02','CS01',150,1),
('DV03','CS01',300,1),
('DV04','CS01',20,1),
('DV05','CS01',50,1),
('DV06','CS01',30,1),


-- CS02
('DV01','CS02',120,1),
('DV02','CS02',80,1),
('DV03','CS02',200,1),
('DV04','CS02',15,1),
('DV05','CS02',40,1),
('DV06','CS02',20,1),

-- CS03
('DV01','CS03',150,1),
('DV02','CS03',100,1),
('DV03','CS03',250,1),
('DV04','CS03',18,1),
('DV05','CS03',45,1),
('DV06','CS03',25,1),


-- CS04
('DV01','CS04',100,1),
('DV02','CS04',70,1),
('DV03','CS04',180,1),
('DV04','CS04',12,1),
('DV05','CS04',30,1),
('DV06','CS04',18,1),


-- CS05
('DV01','CS05',110,1),
('DV02','CS05',75,1),
('DV03','CS05',190,1),
('DV04','CS05',14,1),
('DV05','CS05',35,1),
('DV06','CS05',20,1)


--Phiếu Đặt Sân
INSERT INTO PhieuDatSan VALUES
-- CS01
('PDS0000006','2025-01-10 08:00','2025-01-22','08:00','10:00',
 N'Online',N'Hoàn thành','08:02','KH006',NULL,'CS01LS0201'),

('PDS0000007','2025-01-10 15:30','2025-01-22','16:00','18:00',
 N'Tại quầy',N'Hoàn thành','16:01','KH007','NV006','CS01LS0301'),

-- CS02
('PDS0000008','2025-01-11 09:00','2025-01-23','09:00','11:00',
 N'Online',N'Chờ thanh toán',NULL,'KH008',NULL,'CS02LS0101'),

('PDS0000009','2025-01-11 18:00','2025-01-24','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:00','KH009','NV023','CS02LS0401'),

-- CS03
('PDS0000010','2025-01-12 07:00','2025-01-25','07:00','09:00',
 N'Online',N'Hoàn thành','07:05','KH010',NULL,'CS03LS0501'),

('PDS0000011','2025-01-12 16:30','2025-01-25','16:00','18:00',
 N'Tại quầy',N'Hoàn thành','16:02','KH011','NV026','CS03LS0201'),

-- CS04
('PDS0000012','2025-01-13 10:00','2025-01-26','10:00','12:00',
 N'Online',N'Hoàn thành','10:01','KH012',NULL,'CS04LS0101'),

('PDS0000013','2025-01-13 18:30','2025-01-26','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:03','KH013','NV041','CS04LS0301'),

-- CS05
('PDS0000014','2025-01-14 08:30','2025-01-27','08:00','10:00',
 N'Online',N'Vắng mặt',NULL,'KH014',NULL,'CS05LS0201'),

('PDS0000015','2025-01-14 17:00','2025-01-27','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:01','KH015','NV049','CS05LS0401');

 INSERT INTO PhieuDatSan VALUES
('PDS0000001','2025-01-05 08:00','2025-01-05','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH001',NULL,'CS01LS0101'),
('PDS0000002','2025-01-06 08:00','2025-01-06','08:00','10:00',N'Tại quầy',N'Hoàn thành','08:00','KH002','NV001','CS01LS0102'),
('PDS0000003','2025-01-07 08:00','2025-01-07','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH003',NULL,'CS01LS0201'),
('PDS0000004','2025-01-08 08:00','2025-01-08','08:00','10:00',N'Tại quầy',N'Hoàn thành','08:00','KH004','NV001','CS01LS0202'),
('PDS0000005','2025-01-09 08:00','2025-01-09','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH005',NULL,'CS01LS0301');

--Chi tiết phiếu đặt sân
INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, MaHLV, TrangThaiThanhToan) VALUES
-- ===== PDS06 (CS01) =====
('CTPDS00016','2025-01-10 08:00',1,10000,'PDS0000006',NULL,'DV01',NULL,1),
('CTPDS00017','2025-01-10 08:00',1,20000,'PDS0000006',NULL,'DV02',NULL,1),

-- ===== PDS07 (CS01) =====
('CTPDS00018','2025-01-10 15:30',2,160000,'PDS0000007','NV006','DV05',NULL,1),
('CTPDS00019','2025-01-10 15:30',1,5000,'PDS0000007','NV006','DV03',NULL,1),

-- ===== PDS08 (CS02) =====
('CTPDS00020','2025-01-11 09:00',2,20000,'PDS0000008',NULL,'DV01',NULL,0),

-- ===== PDS09 (CS02) =====
('CTPDS00021','2025-01-11 18:00',1,300000,'PDS0000009','NV023','DV04',NULL,1),
('CTPDS00022','2025-01-11 18:00',2,10000,'PDS0000009','NV023','DV03',NULL,1),

-- ===== PDS10 (CS03) =====
('CTPDS00023','2025-01-12 07:00',1,20000,'PDS0000010',NULL,'DV02',NULL,1),

-- ===== PDS11 (CS03) =====
('CTPDS00024','2025-01-12 16:30',1,400000,'PDS0000011','NV026','DV06',NULL,1),
('CTPDS00025','2025-01-12 16:30',1,150000,'PDS0000011','NV026','DV07',NULL,1),

-- ===== PDS12 (CS04) =====
('CTPDS00026','2025-01-13 10:00',2,20000,'PDS0000012',NULL,'DV01',NULL,1),

-- ===== PDS13 (CS04) – THUÊ HLV =====
('CTPDS00027','2025-01-13 18:30',1,500000,'PDS0000013','NV041','DV04','NV050',1),

-- ===== PDS14 (CS05) =====
('CTPDS00028','2025-01-14 08:30',1,80000,'PDS0000014',NULL,'DV05',NULL,1),

-- ===== PDS15 (CS05) =====
('CTPDS00029','2025-01-14 17:00',2,40000,'PDS0000015','NV049','DV02',NULL,1),
('CTPDS00030','2025-01-14 17:00',1,10000,'PDS0000015','NV049','DV03',NULL,1),

('CTPDS00001','2025-01-05 08:00',1,300000,'PDS0000001','NV049','DV04','NV049',1),
('CTPDS00002','2025-01-05 08:00',1,300000,'PDS0000001','NV049','DV04','NV049',1),
('CTPDS00003','2025-01-06 08:00',1,150000,'PDS0000002',NULL,'DV01',NULL,1), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS00004','2025-01-06 08:00',1,300000,'PDS0000002','NV050','DV04','NV050',1),
('CTPDS00005','2025-01-07 08:00',1,20000,'PDS0000003',NULL,'DV01',NULL,1),
('CTPDS00006','2025-01-07 08:00',1,300000,'PDS0000003','NV049','DV04','NV049',1),
('CTPDS00007','2025-01-07 08:00',1,80000,'PDS0000003',NULL,'DV05',NULL,1), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS00008','2025-01-08 08:00',1,300000,'PDS0000004','NV050','DV04','NV050',1),
('CTPDS00009','2025-01-08 08:00',1,300000,'PDS0000004','NV050','DV04','NV050',1),
('CTPDS00010','2025-01-09 08:00',1,20000,'PDS0000005',NULL,'DV02',NULL,1), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS00011','2025-01-09 08:00',1,300000,'PDS0000005','NV049','DV04','NV049',1),
('CTPDS00012','2025-01-09 08:00',1,300000,'PDS0000005','NV050','DV04','NV050',1),
('CTPDS00013','2025-01-09 08:00',1,150000,'PDS0000005',NULL,'DV07',NULL,1), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS00014','2025-01-09 08:00',1,20000,'PDS0000005',NULL,'DV01',NULL,1),
('CTPDS00015','2025-01-09 08:00',1,300000,'PDS0000005','NV049','DV04','NV049',1);

--Lich Sử Thay Đổi
INSERT INTO LichSuThayDoi VALUES
('PDS0000006','2025-01-10 09:00',N'Đổi hình thức thanh toán',0,
 N'Khách chuyển từ online sang tiền mặt',0),

('PDS0000007','2025-01-10 16:00',N'Đổi dịch vụ kèm theo',0,
 N'Khách thêm dịch vụ trong quá trình sử dụng',0),

('PDS0000008','2025-01-11 10:30',N'Hủy sát giờ',200000,
 N'Khách hủy trong vòng 2 giờ trước khi nhận sân',0),

('PDS0000009','2025-01-11 18:30',N'Đổi giờ đặt sân',0,
 N'Dời sang khung giờ buổi tối',0),

('PDS0000010','2025-01-12 07:30',N'Gia hạn thời gian',50000,
 N'Khách chơi thêm 30 phút',0),

('PDS0000011','2025-01-12 17:00',N'Đổi sân',0,
 N'Sân ban đầu bảo trì đột xuất',0),

('PDS0000012','2025-01-13 10:30',N'Đổi giờ đặt sân',0,
 N'Khách yêu cầu đổi khung giờ',0),

('PDS0000013','2025-01-13 19:00',N'Thuê thêm HLV',0,
 N'Khách yêu cầu HLV trình độ cao hơn',0),

('PDS0000014','2025-01-14 08:30',N'Vắng mặt',100000,
 N'Khách không đến đúng giờ nhận sân',0),

('PDS0000015','2025-01-14 18:30',N'Đổi dịch vụ kèm theo',0,
 N'Khách hủy một phần dịch vụ đã đặt',0);


--LichSuHuyDichVu
INSERT INTO LichSuHuyDichVu VALUES
('CTPDS00003','2025-01-07 11:30',N'Khách không sử dụng dịch vụ',150000),
('CTPDS00007','2025-01-10 16:10',N'Hết hàng tại quầy',80000),
('CTPDS00010','2025-01-12 07:30',N'Khách đổi ý',20000),
('CTPDS00013','2025-01-13 10:20',N'Sai loại dịch vụ',150000),
('CTPDS00018','2025-01-23 08:30',N'Hủy thuê dụng cụ',160000),
('CTPDS00021','2025-01-24 18:20',N'Dịch vụ không còn nhu cầu',300000);


--Tài Sản Cho Thuê
INSERT INTO TaiSanChoThue VALUES
-- CS01
('TS01',N'Tủ đồ',N'Trống','CS01'),
('TS02',N'Tủ đồ',N'Trống','CS01'),
('TS03',N'Phòng tắm VIP',N'Trống','CS01'),
('TS04',N'Phòng tắm VIP',N'Bảo trì','CS01'),

-- CS02
('TS05',N'Tủ đồ',N'Trống','CS02'),
('TS06',N'Tủ đồ',N'Trống','CS02'),
('TS07',N'Phòng tắm VIP',N'Trống','CS02'),

-- CS03
('TS08',N'Tủ đồ',N'Trống','CS03'),
('TS09',N'Phòng tắm VIP',N'Trống','CS03'),

-- CS04
('TS10',N'Tủ đồ',N'Trống','CS04'),
('TS11',N'Phòng tắm VIP',N'Trống','CS04'),

-- CS05
('TS12',N'Tủ đồ',N'Trống','CS05'),
('TS13',N'Phòng tắm VIP',N'Trống','CS05');

--Phiếu Thuê Tài Sản
INSERT INTO PhieuThueTaiSan (MaPhieuThue, ThoiDiemTao, MaKhachHang, MaNhanVien, TrangThai) VALUES
('PT00000001','2025-01-01 09:00','KH001','NV006',N'Hoàn thành'),
('PT00000002','2025-01-05 13:00','KH002','NV003',N'Hoàn thành'),
('PT00000003','2025-01-10 09:30','KH003','NV006',N'Chờ thanh toán'),
('PT00000004','2025-01-12 08:30','KH004','NV023',N'Hoàn thành'),
('PT00000005','2025-01-12 10:00','KH005','NV041',N'Đã hủy'),
('PT00000006','2025-01-15 07:45','KH006','NV026',N'Hoàn thành'),
('PT00000007','2025-01-18 17:30','KH007','NV049',N'Hoàn thành');

--Chi Tiết Phiếu Thuê Tài Sản
INSERT INTO ChiTietPhieuThueTaiSan VALUES
('CTPT000001','PT00000001','TS01','GD01','2025-01-01','2025-06-30'),
('CTPT000002','PT00000001','TS03','GD03','2025-01-01','2025-06-30'),

('CTPT000003','PT00000002','TS02','GD02','2025-01-05','2026-01-04'),

('CTPT000004','PT00000003','TS05','GD01','2025-01-10','2025-07-08'),

('CTPT000005','PT00000004','TS08','GD02','2025-01-12','2026-01-11'),
('CTPT000006','PT00000004','TS09','GD04','2025-01-12','2026-01-11'),

('CTPT000007','PT00000006','TS10','GD01','2025-01-15','2025-07-13'),
('CTPT000008','PT00000007','TS12','GD03','2025-01-18','2025-07-16');

--Đặt Lịch HLV
INSERT INTO DatLichHLV VALUES
('CTPDS00001','NV049','2025-01-10 08:00','2025-01-10 10:00'),
('CTPDS00002','NV049','2025-01-10 10:00','2025-01-10 12:00'),
('CTPDS00004','NV050','2025-01-12 18:00','2025-01-12 20:00'),
('CTPDS00006','NV049','2025-01-22 08:00','2025-01-22 10:00'),
('CTPDS00008','NV050','2025-01-23 09:00','2025-01-23 11:00'),
('CTPDS00009','NV050','2025-01-24 18:00','2025-01-24 20:00'),
('CTPDS00011','NV049','2025-01-25 16:00','2025-01-25 18:00'),
('CTPDS00012','NV050','2025-01-26 10:00','2025-01-26 12:00'),
('CTPDS00015','NV049','2025-01-27 18:00','2025-01-27 20:00'),
('CTPDS00027','NV050','2025-01-13 18:30','2025-01-13 20:30');


-- Tham SỐ hệ thống
INSERT INTO ThamSoHeThong VALUES
('TS01', 'PHAT_VANG_MAT', 100000, N'VND', N'Phạt khách không đến đúng giờ', '2025-01-01'),
('TS02', 'PHAT_HUY_SAT_GIO', 200000, N'VND', N'Phạt hủy sân trong vòng 2 giờ', '2025-01-01'),
('TS03', 'THOI_GIAN_GIU_SAN', 15, N'Phút', N'Thời gian giữ sân khi khách chưa check-in', '2025-01-01'),
('TS04', 'GIO_GIAM_GIA_SANG', 0, N'%', N'Giảm giá khung giờ sáng', '2025-01-01'),
('TS05', 'PHU_THU_CUOI_TUAN', 10, N'%', N'Phụ thu cuối tuần', '2025-01-01'),
('TS06', 'PHU_THU_NGAY_LE', 20, N'%', N'Phụ thu ngày lễ', '2025-01-01'),
('TS07', 'THUE_HLV_THEO_GIO', 250000, N'VND', N'Giá thuê HLV theo giờ', '2025-01-01');

--Hóa đơn
INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan,
                    HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue) VALUES
-- ===== Hóa đơn cho Phiếu Đặt Sân =====
('2025-01-10 10:00',200000,30000,0,230000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS0000006',NULL),
('2025-01-10 18:00',300000,165000,0,465000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS0000007',NULL),
('2025-01-11 11:00',200000,20000,0,220000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS0000008',NULL),
('2025-01-11 20:00',400000,310000,0,710000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS0000009',NULL),
('2025-01-12 09:30',300000,20000,0,320000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS0000010',NULL),
('2025-01-12 18:00',300000,550000,0,850000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS0000011',NULL),
('2025-01-13 12:30',250000,20000,0,270000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS0000012',NULL),
('2025-01-13 20:30',350000,500000,0,850000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS0000013',NULL),
('2025-01-14 10:00',200000,0,0,200000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS0000014',NULL),
('2025-01-14 20:00',300000,40000,0,340000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS0000015',NULL),

-- ===== Hóa đơn cho Phiếu Thuê Tài Sản =====
('2025-01-01 10:00',0,1700000,0,1700000,N'Tiền mặt',N'Đã thanh toán','NV006',NULL,'PT00000001'),
('2025-01-05 14:00',0,900000,0,900000,N'Ví điện tử',N'Đã thanh toán','NV003',NULL,'PT00000002'),
('2025-01-10 16:00',0,500000,0,500000,N'Tiền mặt',N'Chưa thanh toán','NV006',NULL,'PT00000003'),
('2025-01-12 09:00',0,2900000,0,2900000,N'Ví điện tử',N'Đã thanh toán','NV023',NULL,'PT00000004'),
('2025-01-15 08:00',0,500000,0,500000,N'Tiền mặt',N'Đã thanh toán','NV026',NULL,'PT00000006'),
('2025-01-18 18:00',0,1200000,0,1200000,N'Ví điện tử',N'Đã thanh toán','NV049',NULL,'PT00000007');


INSERT INTO ApDung (MaKhachHang, MaUuDai, NgayBatDau, NgayKetThuc, TrangThai) VALUES
-- Silver (UD01 - 5%)
('KH001','UD01','2026-01-01','2026-12-31',1),
('KH002','UD01','2023-01-01','2023-12-31',0), -- hết hạn
('KH003','UD01','2024-01-01','2024-12-31',0),
('KH004','UD01','2024-01-01','2024-06-30',0), -- bị khóa giữa chừng
('KH005','UD01','2024-01-01','2025-12-31',0),

-- Gold (UD02 - 10%)
('KH006','UD02','2024-01-01','2024-12-31',0),
('KH007','UD02','2024-01-01','2025-12-31',0),
('KH008','UD02','2023-01-01','2023-12-31',0),
('KH009','UD02','2024-01-01','2024-12-31',0),
('KH010','UD02','2024-01-01','2024-06-30',0),

-- Platinum (UD03 - 20%)
('KH011','UD03','2024-01-01','2025-12-31',0),
('KH012','UD03','2024-01-01','2024-12-31',0),
('KH013','UD03','2023-01-01','2023-12-31',0),
('KH014','UD03','2024-01-01','2024-06-30',0),

-- HSSV (UD04 - 10%)
('KH015','UD04','2024-09-01','2025-06-30',0), -- năm học
('KH016','UD04','2024-09-01','2025-06-30',0),
('KH017','UD04','2023-09-01','2024-06-30',0),
('KH018','UD04','2024-09-01','2025-06-30',0),

-- 1 KH có nhiều ưu đãi (để test chọn ưu đãi)
('KH019','UD01','2024-01-01','2024-12-31',0),
('KH019','UD04','2024-09-01','2025-06-30',0);
