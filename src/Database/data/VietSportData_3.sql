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
('DV07','CS01',40,1),
('DV08','CS01',15,1),

-- CS02
('DV01','CS02',120,1),
('DV02','CS02',80,1),
('DV03','CS02',200,1),
('DV04','CS02',15,1),
('DV05','CS02',40,1),
('DV06','CS02',20,1),
('DV07','CS02',30,1),
('DV08','CS02',10,1),

-- CS03
('DV01','CS03',150,1),
('DV02','CS03',100,1),
('DV03','CS03',250,1),
('DV04','CS03',18,1),
('DV05','CS03',45,1),
('DV06','CS03',25,1),
('DV07','CS03',35,1),
('DV08','CS03',12,1),

-- CS04
('DV01','CS04',100,1),
('DV02','CS04',70,1),
('DV03','CS04',180,1),
('DV04','CS04',12,1),
('DV05','CS04',30,1),
('DV06','CS04',18,1),
('DV07','CS04',25,1),
('DV08','CS04',8,1),

-- CS05
('DV01','CS05',110,1),
('DV02','CS05',75,1),
('DV03','CS05',190,1),
('DV04','CS05',14,1),
('DV05','CS05',35,1),
('DV06','CS05',20,1),
('DV07','CS05',28,1),
('DV08','CS05',9,1);


--Phiếu Đặt Sân
INSERT INTO PhieuDatSan VALUES
-- CS01
('PDS06','2025-01-10 08:00','2025-01-22','08:00','10:00',
 N'Online',N'Hoàn thành','08:02','KH006',NULL,'CS01LS0201'),

('PDS07','2025-01-10 15:30','2025-01-22','16:00','18:00',
 N'Tại quầy',N'Hoàn thành','16:01','KH007','NV006','CS01LS0301'),

-- CS02
('PDS08','2025-01-11 09:00','2025-01-23','09:00','11:00',
 N'Online',N'Chờ thanh toán',NULL,'KH008',NULL,'CS02LS0101'),

('PDS09','2025-01-11 18:00','2025-01-24','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:00','KH009','NV023','CS02LS0401'),

-- CS03
('PDS10','2025-01-12 07:00','2025-01-25','07:00','09:00',
 N'Online',N'Hoàn thành','07:05','KH010',NULL,'CS03LS0501'),

('PDS11','2025-01-12 16:30','2025-01-25','16:00','18:00',
 N'Tại quầy',N'Hoàn thành','16:02','KH011','NV026','CS03LS0201'),

-- CS04
('PDS12','2025-01-13 10:00','2025-01-26','10:00','12:00',
 N'Online',N'Hoàn thành','10:01','KH012',NULL,'CS04LS0101'),

('PDS13','2025-01-13 18:30','2025-01-26','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:03','KH013','NV041','CS04LS0301'),

-- CS05
('PDS14','2025-01-14 08:30','2025-01-27','08:00','10:00',
 N'Online',N'Vắng mặt',NULL,'KH014',NULL,'CS05LS0201'),

('PDS15','2025-01-14 17:00','2025-01-27','18:00','20:00',
 N'Tại quầy',N'Hoàn thành','18:01','KH015','NV049','CS05LS0401');

 INSERT INTO PhieuDatSan VALUES
('PDS01','2025-01-05 08:00','2025-01-05','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH001',NULL,'CS01LS0101'),
('PDS02','2025-01-06 08:00','2025-01-06','08:00','10:00',N'Tại quầy',N'Hoàn thành','08:00','KH002','NV001','CS01LS0102'),
('PDS03','2025-01-07 08:00','2025-01-07','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH003',NULL,'CS01LS0201'),
('PDS04','2025-01-08 08:00','2025-01-08','08:00','10:00',N'Tại quầy',N'Hoàn thành','08:00','KH004','NV001','CS01LS0202'),
('PDS05','2025-01-09 08:00','2025-01-09','08:00','10:00',N'Online',N'Hoàn thành','08:00','KH005',NULL,'CS01LS0301');

--Chi tiết phiếu đặt sân
INSERT INTO ChiTietPhieuDatSan VALUES
-- ===== PDS06 (CS01) =====
('CTPDS16',1,10000,N'Nước suối','PDS06',NULL,'DV01',NULL),
('CTPDS17',1,20000,N'Nước tăng lực','PDS06',NULL,'DV02',NULL),

-- ===== PDS07 (CS01) =====
('CTPDS18',2,160000,N'Bóng tennis','PDS07','NV006','DV05',NULL),
('CTPDS19',1,5000,N'Khăn lạnh','PDS07','NV006','DV03',NULL),

-- ===== PDS08 (CS02) =====
('CTPDS20',2,20000,N'Nước suối','PDS08',NULL,'DV01',NULL),

-- ===== PDS09 (CS02) =====
('CTPDS21',1,300000,N'Thuê bóng đá','PDS09','NV023','DV04',NULL),
('CTPDS22',2,10000,N'Khăn lạnh','PDS09','NV023','DV03',NULL),

-- ===== PDS10 (CS03) =====
('CTPDS23',1,20000,N'Nước tăng lực','PDS10',NULL,'DV02',NULL),

-- ===== PDS11 (CS03) =====
('CTPDS24',1,400000,N'Thuê vợt cầu lông','PDS11','NV026','DV06',NULL),
('CTPDS25',1,150000,N'Áo thể thao','PDS11','NV026','DV07',NULL),

-- ===== PDS12 (CS04) =====
('CTPDS26',2,20000,N'Nước suối','PDS12',NULL,'DV01',NULL),

-- ===== PDS13 (CS04) – THUÊ HLV =====
('CTPDS27',1,500000,N'Thuê HLV nâng cao','PDS13','NV041','DV04','NV050'),

-- ===== PDS14 (CS05) =====
('CTPDS28',1,80000,N'Bóng tennis','PDS14',NULL,'DV05',NULL),

-- ===== PDS15 (CS05) =====
('CTPDS29',2,40000,N'Nước tăng lực','PDS15','NV049','DV02',NULL),
('CTPDS30',1,10000,N'Khăn lạnh','PDS15','NV049','DV03',NULL);

INSERT INTO ChiTietPhieuDatSan VALUES
('CTPDS01',1,300000,N'Thuê HLV','PDS01','NV049','DV04','NV049'),
('CTPDS02',1,300000,N'Thuê HLV','PDS01','NV049','DV04','NV049'),
('CTPDS03',1,150000,N'Dịch vụ hủy','PDS02',NULL,'DV01',NULL), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS04',1,300000,N'Thuê HLV','PDS02','NV050','DV04','NV050'),
('CTPDS05',1,20000,N'Nước uống','PDS03',NULL,'DV01',NULL),
('CTPDS06',1,300000,N'Thuê HLV','PDS03','NV049','DV04','NV049'),
('CTPDS07',1,80000,N'Dịch vụ hủy','PDS03',NULL,'DV05',NULL), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS08',1,300000,N'Thuê HLV','PDS04','NV050','DV04','NV050'),
('CTPDS09',1,300000,N'Thuê HLV','PDS04','NV050','DV04','NV050'),
('CTPDS10',1,20000,N'Dịch vụ hủy','PDS05',NULL,'DV02',NULL), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS11',1,300000,N'Thuê HLV','PDS05','NV049','DV04','NV049'),
('CTPDS12',1,300000,N'Thuê HLV','PDS05','NV050','DV04','NV050'),
('CTPDS13',1,150000,N'Dịch vụ hủy','PDS05',NULL,'DV07',NULL), -- Được tham chiếu bởi LichSuHuyDichVu
('CTPDS14',1,20000,N'Nước suối','PDS05',NULL,'DV01',NULL),
('CTPDS15',1,300000,N'Thuê HLV','PDS05','NV049','DV04','NV049');

--Lich Sử Thay Đổi
INSERT INTO LichSuThayDoi VALUES
('PDS06','2025-01-10 09:00',N'Đổi hình thức thanh toán',0,
 N'Khách chuyển từ online sang tiền mặt',0),

('PDS07','2025-01-10 16:00',N'Đổi dịch vụ kèm theo',0,
 N'Khách thêm dịch vụ trong quá trình sử dụng',0),

('PDS08','2025-01-11 10:30',N'Hủy sát giờ',200000,
 N'Khách hủy trong vòng 2 giờ trước khi nhận sân',0),

('PDS09','2025-01-11 18:30',N'Đổi giờ đặt sân',0,
 N'Dời sang khung giờ buổi tối',0),

('PDS10','2025-01-12 07:30',N'Gia hạn thời gian',50000,
 N'Khách chơi thêm 30 phút',0),

('PDS11','2025-01-12 17:00',N'Đổi sân',0,
 N'Sân ban đầu bảo trì đột xuất',0),

('PDS12','2025-01-13 10:30',N'Đổi giờ đặt sân',0,
 N'Khách yêu cầu đổi khung giờ',0),

('PDS13','2025-01-13 19:00',N'Thuê thêm HLV',0,
 N'Khách yêu cầu HLV trình độ cao hơn',0),

('PDS14','2025-01-14 08:30',N'Vắng mặt',100000,
 N'Khách không đến đúng giờ nhận sân',0),

('PDS15','2025-01-14 18:30',N'Đổi dịch vụ kèm theo',0,
 N'Khách hủy một phần dịch vụ đã đặt',0);


--LichSuHuyDichVu
INSERT INTO LichSuHuyDichVu VALUES
('CTPDS03','2025-01-07 11:30',N'Khách không sử dụng dịch vụ',150000),
('CTPDS07','2025-01-10 16:10',N'Hết hàng tại quầy',80000),
('CTPDS10','2025-01-12 07:30',N'Khách đổi ý',20000),
('CTPDS13','2025-01-13 10:20',N'Sai loại dịch vụ',150000),
('CTPDS18','2025-01-23 08:30',N'Hủy thuê dụng cụ',160000),
('CTPDS21','2025-01-24 18:20',N'Dịch vụ không còn nhu cầu',300000);


--Tài Sản Cho Thuê
INSERT INTO TaiSanChoThue VALUES
-- CS01
('TS01',N'Tủ đồ',N'Trống','CS01'),
('TS02',N'Tủ đồ',N'Trống','CS01'),
('TS03',N'Phòng tắm',N'Trống','CS01'),
('TS04',N'Phòng tắm',N'Bảo trì','CS01'),

-- CS02
('TS05',N'Tủ đồ',N'Trống','CS02'),
('TS06',N'Tủ đồ',N'Trống','CS02'),
('TS07',N'Phòng tắm',N'Trống','CS02'),

-- CS03
('TS08',N'Tủ đồ',N'Trống','CS03'),
('TS09',N'Phòng tắm',N'Trống','CS03'),

-- CS04
('TS10',N'Tủ đồ',N'Trống','CS04'),
('TS11',N'Phòng tắm',N'Trống','CS04'),

-- CS05
('TS12',N'Tủ đồ',N'Trống','CS05'),
('TS13',N'Phòng tắm',N'Trống','CS05');


--Phiếu Thuê Tài Sản
INSERT INTO PhieuThueTaiSan VALUES
('PTS01','KH001','NV006',N'Hoàn thành'),
('PTS02','KH002','NV003',N'Hoàn thành'),
('PTS03','KH003','NV006',N'Chờ thanh toán'),
('PTS04','KH004','NV023',N'Hoàn thành'),
('PTS05','KH005','NV041',N'Đã hủy'),
('PTS06','KH006','NV026',N'Hoàn thành'),
('PTS07','KH007','NV049',N'Hoàn thành');

--Chi Tiết Phiếu Thuê Tài Sản
INSERT INTO ChiTietPhieuThueTaiSan VALUES
('CTPTTS01','PTS01','TS01','GD01','2025-01-01','2025-06-30'),
('CTPTTS02','PTS01','TS03','GD03','2025-01-01','2025-06-30'),

('CTPTTS03','PTS02','TS02','GD02','2025-01-05','2026-01-04'),

('CTPTTS04','PTS03','TS05','GD01','2025-01-10','2025-07-08'),

('CTPTTS05','PTS04','TS08','GD02','2025-01-12','2026-01-11'),
('CTPTTS06','PTS04','TS09','GD04','2025-01-12','2026-01-11'),

('CTPTTS07','PTS06','TS10','GD01','2025-01-15','2025-07-13'),
('CTPTTS08','PTS07','TS12','GD03','2025-01-18','2025-07-16');

--Đặt Lịch HLV
INSERT INTO DatLichHLV VALUES
('CTPDS01','NV049','2025-01-10 08:00','2025-01-10 10:00'),
('CTPDS02','NV049','2025-01-10 10:00','2025-01-10 12:00'),
('CTPDS04','NV050','2025-01-12 18:00','2025-01-12 20:00'),
('CTPDS06','NV049','2025-01-22 08:00','2025-01-22 10:00'),
('CTPDS08','NV050','2025-01-23 09:00','2025-01-23 11:00'),
('CTPDS09','NV050','2025-01-24 18:00','2025-01-24 20:00'),
('CTPDS11','NV049','2025-01-25 16:00','2025-01-25 18:00'),
('CTPDS12','NV050','2025-01-26 10:00','2025-01-26 12:00'),
('CTPDS15','NV049','2025-01-27 18:00','2025-01-27 20:00'),
('CTPDS27','NV050','2025-01-13 18:30','2025-01-13 20:30');


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
INSERT INTO HoaDon VALUES
-- ===== PDS06 =====
('HD001','2025-01-10 10:00',200000,30000,0,230000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD002','2025-01-10 10:30',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),
('HD003','2025-01-10 11:00',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD004','2025-01-10 11:30',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),
('HD005','2025-01-10 12:00',0,30000,0,30000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD006','2025-01-10 12:30',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),

-- ===== PDS07 =====
('HD007','2025-01-10 18:00',300000,165000,0,465000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD008','2025-01-10 18:20',0,5000,0,5000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),
('HD009','2025-01-10 18:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD010','2025-01-10 19:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),
('HD011','2025-01-10 19:20',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD012','2025-01-10 19:40',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),

-- ===== PDS08 (chờ thanh toán) =====
('HD013','2025-01-11 11:00',200000,20000,0,220000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD014','2025-01-11 11:20',0,20000,0,20000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD015','2025-01-11 11:40',0,10000,0,10000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD016','2025-01-11 12:00',0,15000,0,15000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD017','2025-01-11 12:20',0,20000,0,20000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD018','2025-01-11 12:40',0,10000,0,10000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),

-- ===== PDS09 =====
('HD019','2025-01-11 20:00',400000,310000,0,710000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD020','2025-01-11 20:20',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),
('HD021','2025-01-11 20:40',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD022','2025-01-11 21:00',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),
('HD023','2025-01-11 21:20',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD024','2025-01-11 21:40',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),

-- ===== PDS10 =====
('HD025','2025-01-12 09:30',300000,20000,0,320000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD026','2025-01-12 10:00',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),
('HD027','2025-01-12 10:30',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD028','2025-01-12 11:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),
('HD029','2025-01-12 11:30',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD030','2025-01-12 12:00',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),

-- ===== PDS11 =====
('HD031','2025-01-12 18:00',300000,550000,0,850000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD032','2025-01-12 18:30',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),
('HD033','2025-01-12 19:00',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD034','2025-01-12 19:30',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),
('HD035','2025-01-12 20:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD036','2025-01-12 20:30',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),

-- ===== PDS12 =====
('HD037','2025-01-13 12:30',250000,20000,0,270000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD038','2025-01-13 13:00',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),
('HD039','2025-01-13 13:30',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD040','2025-01-13 14:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),
('HD041','2025-01-13 14:30',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD042','2025-01-13 15:00',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),

-- ===== PDS13 =====
('HD043','2025-01-13 20:30',350000,500000,0,850000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD044','2025-01-13 21:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),
('HD045','2025-01-13 21:30',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD046','2025-01-13 22:00',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),
('HD047','2025-01-13 22:30',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD048','2025-01-13 23:00',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),

-- ===== PDS14 (vắng mặt – phạt) =====
('HD049','2025-01-14 10:00',200000,0,0,200000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD050','2025-01-14 10:30',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),
('HD051','2025-01-14 11:00',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD052','2025-01-14 11:30',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),
('HD053','2025-01-14 12:00',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD054','2025-01-14 12:30',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),

-- ===== PDS15 =====
('HD055','2025-01-14 20:00',300000,40000,0,340000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD056','2025-01-14 20:20',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL),
('HD057','2025-01-14 20:40',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD058','2025-01-14 21:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL),
('HD059','2025-01-14 21:20',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD060','2025-01-14 21:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL);

INSERT INTO HoaDon VALUES
-- ===== PDS06 =====
('HD061','2025-01-10 13:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD062','2025-01-10 13:20',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),
('HD063','2025-01-10 13:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD064','2025-01-10 14:00',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),
('HD065','2025-01-10 14:20',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS06',NULL),
('HD066','2025-01-10 14:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS06',NULL),

-- ===== PDS07 =====
('HD067','2025-01-10 20:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD068','2025-01-10 20:20',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),
('HD069','2025-01-10 20:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD070','2025-01-10 21:00',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),
('HD071','2025-01-10 21:20',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV006','PDS07',NULL),
('HD072','2025-01-10 21:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV006','PDS07',NULL),

-- ===== PDS08 (chưa thanh toán) =====
('HD073','2025-01-11 13:00',0,20000,0,20000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD074','2025-01-11 13:20',0,15000,0,15000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD075','2025-01-11 13:40',0,10000,0,10000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD076','2025-01-11 14:00',0,30000,0,30000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD077','2025-01-11 14:20',0,20000,0,20000,N'Ví điện tử',N'Chưa thanh toán','NV023','PDS08',NULL),
('HD078','2025-01-11 14:40',0,15000,0,15000,N'Tiền mặt',N'Chưa thanh toán','NV023','PDS08',NULL),

-- ===== PDS09 =====
('HD079','2025-01-11 22:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD080','2025-01-11 22:20',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),
('HD081','2025-01-11 22:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD082','2025-01-11 23:00',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),
('HD083','2025-01-11 23:20',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV023','PDS09',NULL),
('HD084','2025-01-11 23:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV023','PDS09',NULL),

-- ===== PDS10 =====
('HD085','2025-01-12 13:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD086','2025-01-12 13:20',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),
('HD087','2025-01-12 13:40',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD088','2025-01-12 14:00',0,30000,0,30000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),
('HD089','2025-01-12 14:20',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS10',NULL),
('HD090','2025-01-12 14:40',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS10',NULL),

-- ===== PDS11 =====
('HD091','2025-01-12 21:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD092','2025-01-12 21:20',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),
('HD093','2025-01-12 21:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD094','2025-01-12 22:00',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),
('HD095','2025-01-12 22:20',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV026','PDS11',NULL),
('HD096','2025-01-12 22:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV026','PDS11',NULL),

-- ===== PDS12 =====
('HD097','2025-01-13 16:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD098','2025-01-13 16:20',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),
('HD099','2025-01-13 16:40',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD100','2025-01-13 17:00',0,30000,0,30000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),
('HD101','2025-01-13 17:20',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS12',NULL),
('HD102','2025-01-13 17:40',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS12',NULL),

-- ===== PDS13 =====
('HD103','2025-01-13 23:30',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD104','2025-01-13 23:50',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),
('HD105','2025-01-14 00:10',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD106','2025-01-14 00:30',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),
('HD107','2025-01-14 00:50',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV041','PDS13',NULL),
('HD108','2025-01-14 01:10',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV041','PDS13',NULL),

-- ===== PDS14 =====
('HD109','2025-01-14 13:00',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD110','2025-01-14 13:20',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),
('HD111','2025-01-14 13:40',0,10000,0,10000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD112','2025-01-14 14:00',0,30000,0,30000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),
('HD113','2025-01-14 14:20',0,20000,0,20000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS14',NULL),
('HD114','2025-01-14 14:40',0,15000,0,15000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS14',NULL),

-- ===== PDS15 =====
('HD115','2025-01-14 22:00',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD116','2025-01-14 22:20',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL),
('HD117','2025-01-14 22:40',0,10000,0,10000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD118','2025-01-14 23:00',0,30000,0,30000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL),
('HD119','2025-01-14 23:20',0,20000,0,20000,N'Tiền mặt',N'Đã thanh toán','NV049','PDS15',NULL),
('HD120','2025-01-14 23:40',0,15000,0,15000,N'Ví điện tử',N'Đã thanh toán','NV049','PDS15',NULL);

INSERT INTO HoaDon (MaHoaDon, NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
VALUES
('HD_TS01','2025-01-01 10:00',0,1700000,0,1700000,N'Tiền mặt',N'Đã thanh toán','NV006',NULL,'PTS01'),
('HD_TS02','2025-01-05 14:00',0,900000,0,900000,N'Ví điện tử',N'Đã thanh toán','NV003',NULL,'PTS02'),
('HD_TS03','2025-01-10 16:00',0,500000,0,500000,N'Tiền mặt',N'Chưa thanh toán','NV006',NULL,'PTS03'),
('HD_TS04','2025-01-12 09:00',0,2900000,0,2900000,N'Ví điện tử',N'Đã thanh toán','NV023',NULL,'PTS04'),
('HD_TS06','2025-01-15 08:00',0,500000,0,500000,N'Tiền mặt',N'Đã thanh toán','NV026',NULL,'PTS06'),
('HD_TS07','2025-01-18 18:00',0,1200000,0,1200000,N'Ví điện tử',N'Đã thanh toán','NV049',NULL,'PTS07');


INSERT INTO ApDung (MaKhachHang, MaUuDai, NgayBatDau, NgayKetThuc, TrangThai) VALUES
-- Silver (UD01 - 5%)
('KH001','UD01','2024-01-01','2024-12-31',1),
('KH002','UD01','2023-01-01','2023-12-31',0), -- hết hạn
('KH003','UD01','2024-01-01','2024-12-31',1),
('KH004','UD01','2024-01-01','2024-06-30',0), -- bị khóa giữa chừng
('KH005','UD01','2024-01-01','2025-12-31',1),

-- Gold (UD02 - 10%)
('KH006','UD02','2024-01-01','2024-12-31',1),
('KH007','UD02','2024-01-01','2025-12-31',1),
('KH008','UD02','2023-01-01','2023-12-31',0),
('KH009','UD02','2024-01-01','2024-12-31',1),
('KH010','UD02','2024-01-01','2024-06-30',0),

-- Platinum (UD03 - 20%)
('KH011','UD03','2024-01-01','2025-12-31',1),
('KH012','UD03','2024-01-01','2024-12-31',1),
('KH013','UD03','2023-01-01','2023-12-31',0),
('KH014','UD03','2024-01-01','2024-06-30',0),

-- HSSV (UD04 - 10%)
('KH015','UD04','2024-09-01','2025-06-30',1), -- năm học
('KH016','UD04','2024-09-01','2025-06-30',1),
('KH017','UD04','2023-09-01','2024-06-30',0),
('KH018','UD04','2024-09-01','2025-06-30',1),

-- 1 KH có nhiều ưu đãi (để test chọn ưu đãi)
('KH019','UD01','2024-01-01','2024-12-31',1),
('KH019','UD04','2024-09-01','2025-06-30',1);


