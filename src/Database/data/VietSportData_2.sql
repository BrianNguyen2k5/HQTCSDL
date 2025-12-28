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


--Tài Khoản Khách Hàng
DECLARE @MaKhachHang CHAR(10);
DECLARE @Email VARCHAR(100);

DECLARE curKhachHang CURSOR FOR
SELECT MaKhachHang, Email
FROM KhachHang
WHERE MaKhachHang NOT IN (
    SELECT MaKhachHang FROM TaiKhoan WHERE MaKhachHang IS NOT NULL
);

OPEN curKhachHang;
FETCH NEXT FROM curKhachHang INTO @MaKhachHang, @Email;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO TaiKhoan (
        TenDangNhap,
        Salt,
        MatKhauMaHoa,
        Email,
        TrangThai,
        NgayTao,
        MaKhachHang,
        MaNhanVien
    )
    VALUES (
        'kh_' + @MaKhachHang,                 -- tên đăng nhập
        'ABCDEF1234567890ABCDEF1234567890',   -- salt demo
        'E10ADC3949BA59ABBE56E057F20F883E',    -- hash demo
        @Email,                               -- dùng email khách
        1,                                    -- còn hoạt động
        GETDATE(),
        @MaKhachHang,
        NULL
    );

    FETCH NEXT FROM curKhachHang INTO @MaKhachHang, @Email;
END;

CLOSE curKhachHang;
DEALLOCATE curKhachHang;

--Tai Khoan Nhan Vien
DECLARE @MaNhanVien CHAR(10);

DECLARE curNhanVien CURSOR FOR
SELECT MaNhanVien
FROM NhanVien;

OPEN curNhanVien;
FETCH NEXT FROM curNhanVien INTO @MaNhanVien;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO TaiKhoan (
        TenDangNhap,
        Salt,
        MatKhauMaHoa,
        Email,
        TrangThai,
        NgayTao,
        MaKhachHang,
        MaNhanVien
    )
    VALUES (
        'nv_' + RTRIM(@MaNhanVien),
        'ABCDEF1234567890ABCDEF1234567890',
        'E10ADC3949BA59ABBE56E057F20F883E',
        RTRIM(@MaNhanVien) + '@vietsport.vn',
        1,
        GETDATE(),
        NULL,
        @MaNhanVien
    );

    FETCH NEXT FROM curNhanVien INTO @MaNhanVien;
END;

CLOSE curNhanVien;
DEALLOCATE curNhanVien;

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