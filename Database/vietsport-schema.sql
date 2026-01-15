/* ====================================================
DATABASE SCHEMA - SPORTS CENTER
==================================================== */
--USE master
--ALTER DATABASE VietSport SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DROP DATABASE VietSport;

--CREATE DATABASE VietSport

USE VietSport
-- 1. BẢNG: QUẢN LÝ NGƯỜI DÙNG --

CREATE TABLE TaiKhoan (
    id INT IDENTITY (1, 1) PRIMARY KEY,
    TenDangNhap VARCHAR(50) UNIQUE,
    MatKhauMaHoa CHAR(64) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    TrangThai BIT DEFAULT 1, -- Trạng thái: 1: là còn hoạt động, 0: bị khóa 
    NgayTao DATETIME DEFAULT GETDATE (),
    MaKhachHang CHAR(10),
    MaNhanVien CHAR(10)
);

-- 2. BẢNG: QUẢN LÝ NHÂN SỰ --

CREATE TABLE ChucVu (
    MaChucVu CHAR(10) PRIMARY KEY,
    TenChucVu NVARCHAR (50) NOT NULL -- TenChucVu =  'Quản lý' hoặc 'Lễ tân' hoặc 'Kỹ thuật' hoặc 'Thu ngân' hoặc ‘Huấn luyện viên’.
);

CREATE TABLE NhanVien (
    MaNhanVien CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR (100) NOT NULL,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR (5) NOT NULL, -- GioiTinh = ‘Nam’ hoặc ‘Nữ’.
    SoCCCD CHAR(12) NOT NULL UNIQUE,
    DiaChi NVARCHAR (255) NOT NULL,
    SoDienThoai CHAR(10) NOT NULL,
    LuongCoBan INT NOT NULL,
    PhuCap INT DEFAULT 0,
    NgayVaoLam DATE NOT NULL,
    TrangThai NVARCHAR (20) NOT NULL, -- Trạng thái: 'Đang làm', 'Nghỉ việc'
    MaQuanLy CHAR(10),
    MaCoSo CHAR(10) NOT NULL,
    MaChucVu CHAR(10) NOT NULL
);

CREATE TABLE HuanLuyenVien (
    MaHLV CHAR(10) PRIMARY KEY,
    ChuyenMon NVARCHAR (100) NOT NULL,
    GiaThuTheoGio INT NOT NULL,
    KinhNghiem NVARCHAR (255) NOT NULL
);

CREATE TABLE LichLamViec (
    MaHLV CHAR(10),
    NgayTrongTuan INT,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    PRIMARY KEY (MaHLV, NgayTrongTuan)
);

CREATE TABLE CaTruc (
    MaCa CHAR(10) PRIMARY KEY,
    TenCa NVARCHAR (50) NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL
);

CREATE TABLE PhanCongCaTruc (
    MaCa CHAR(10),
    MaNhanVien CHAR(10),
    NgayLamViec DATE,
    MaQuanLy CHAR(10) NOT NULL,
    PRIMARY KEY (MaCa, MaNhanVien, NgayLamViec)
);

CREATE TABLE DonNghiPhep (
    MaDon CHAR(10) PRIMARY KEY,
    NgayXinNghi DATE NOT NULL,
    LyDo NVARCHAR (255),
    TrangThai NVARCHAR (20), --Trạng thái: 'Đang chờ duyệt', 'Đã Duyệt', 'Hủy'
    MaNhanVienLap CHAR(10) NOT NULL,
    MaQuanLy CHAR(10) NOT NULL,
    MaNhanVienThayThe CHAR(10)
);

-- 3. BẢNG: KHÁCH HÀNG & ƯU ĐÃI --

CREATE TABLE KhachHang (
    MaKhachHang CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR (100),
    NgaySinh DATE,
    SoCCCD CHAR(12) UNIQUE,
    SoDienThoai CHAR(10),
    Email VARCHAR(100)
);

CREATE UNIQUE INDEX IX_KhachHang_SoCCCD
ON KhachHang(SoCCCD)
WHERE soCCCD IS NOT NULL; -- Chỉ unique những thằng khác NULL

CREATE TABLE UuDai (
    MaUuDai CHAR(10) PRIMARY KEY,
    LoaiUuDai NVARCHAR (100) NOT NULL, --LoaiUuDai = ‘Silver’ hoặc ‘Gold’  hoặc ‘Platinum’ hoặc ‘HSSV’ hoặc ‘Người cao tuổi’.
    PhanTramGiamGia INT NOT NULL
);

CREATE TABLE ApDung (
    MaKhachHang CHAR(10),
    MaUuDai CHAR(10),
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
    TrangThai BIT NOT NULL,
    PRIMARY KEY (MaKhachHang, MaUuDai)
);

-- 4. BẢNG: CƠ SỞ & SÂN BÃI --

CREATE TABLE CoSo (
    MaCoSo CHAR(10) PRIMARY KEY,
    TenCoSo NVARCHAR (100) NOT NULL,
    DiaChi NVARCHAR (255) NOT NULL
);

CREATE TABLE LoaiSan (
    MaLoaiSan CHAR(10) PRIMARY KEY,
    TenLoaiSan NVARCHAR (50) NOT NULL, --TenloaiSan =  ‘Bóng đá mini’ hoặc ‘Cầu lông’ hoặc ‘Tennis’ hoặc ‘Bóng rổ’ hoặc ‘Futsal’.
    DonViTinhTheoPhut INT NOT NULL,
    GiaGoc INT NOT NULL,
    MoTa NVARCHAR (255)
    -- sân cầu lông và bóng rổ cho thuê giờ: 60 phút, sân tennis cho thuê theo ca 120 phút , sân 
    -- bóng đá mini cho thuê theo trận (90 phút).
);

CREATE TABLE San (
    MaSan CHAR(10) PRIMARY KEY,
    TenSan NVARCHAR (50) NOT NULL,
    TinhTrang NVARCHAR (20) NOT NULL, -- Trạng thái: 'Trống', 'Đã đặt', 'Đang sử dụng', 'Bảo trì'
    SucChua INT NOT NULL,
    MaCoSo CHAR(10) NOT NULL,
    MaLoaiSan CHAR(10) NOT NULL
);

CREATE TABLE BaoTri (
    MaNhanVien CHAR(10),
    MaSan CHAR(10),
    NgayBaoTri DATETIME NOT NULL,
    NgayHoanThanh DATETIME,
    TrangThai NVARCHAR (20) NOT NULL, -- Trạng thái = 'Đang bảo trì', 'Hoàn thành'
    ChiPhi INT DEFAULT 0,
    MoTa NVARCHAR (255),
    PRIMARY KEY (MaNhanVien, MaSan)
);

CREATE TABLE KhungGio (
    MaKhungGio CHAR(10) PRIMARY KEY,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL
);

CREATE TABLE NgayLe (
    MaNgayLe DATE PRIMARY KEY,
    TenNgayLe NVARCHAR (100) NOT NULL
);

-- Bảng giá phụ thu
CREATE TABLE BangGiaTangKhungGio (
    MaLoaiSan CHAR(10),
    MaKhungGio CHAR(10),
    GiaTang INT NOT NULL,
    PRIMARY KEY (MaLoaiSan, MaKhungGio)
);

CREATE TABLE BangGiaTangNgayLe (
    MaLoaiSan CHAR(10),
    MaNgayLe DATE,
    GiaTang INT NOT NULL,
    PRIMARY KEY (MaLoaiSan, MaNgayLe)
);

CREATE TABLE BangGiaTangCuoiTuan (
    MaLoaiSan CHAR(10) PRIMARY KEY,
    GiaTang INT NOT NULL
);

-- 5. BẢNG: GIAO DỊCH & DỊCH VỤ --

CREATE TABLE PhieuDatSan (
    MaPhieuDat CHAR(10) PRIMARY KEY,
    NgayDat DATETIME NOT NULL,
    NgayNhanSan DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    HinhThucDat NVARCHAR (50) NOT NULL, --Hình thức: 'Online', 'Tại quầy'
    TrangThaiPhieu NVARCHAR (20) NOT NULL, --Trạng thái: 'Chờ xác nhận', 'Đã xác nhận', 'Đang sử dụng', 'Chờ thanh toán', 'Hoàn thành', 'Đã hủy', 'Vắng mặt'
    ThoiGianCheckin TIME,
    MaKhachHang CHAR(10) NOT NULL,
    MaNhanVien CHAR(10),
    MaSan CHAR(10) NOT NULL
);

CREATE TABLE DatLichHLV (
    MaChiTietPDS CHAR(10) PRIMARY KEY,
    MaHLV CHAR(10) NOT NULL,
    GioBatDauDV DATETIME NOT NULL,
    GioKetThucDV DATETIME NOT NULL
);

CREATE TABLE DichVu (
    MaDichVu CHAR(10) PRIMARY KEY,
    TenDichVu NVARCHAR (100) NOT NULL,
    LoaiDichVu NVARCHAR (20) NOT NULL, -- LoaiDichVu = 'Dụng cụ thể thao' hoặc 'Khác'
    DonGia INT NOT NULL,
    DonViTinh NVARCHAR (10) NOT NULL,
);

CREATE TABLE TonKho (
    MaDichVu CHAR(10),
    MaCoSo CHAR(10),
    SoLuong INT NOT NULL,
    PRIMARY KEY (MaDichVu, MaCoSo),
    TrangThaiKhaDung BIT --TrangThaiKhaDung = 0 -> Không khả dụng, TrangThaiKhaDung = 1 -> Khả dụng
);

CREATE TABLE ChiTietPhieuDatSan (
    MaChiTietPDS CHAR(10) PRIMARY KEY,
    ThoiDiemTao DATETIME,
    SoLuong INT NOT NULL,
    ThanhTien INT NOT NULL,
    MaPhieuDat CHAR(10) NOT NULL,
    MaNhanVien CHAR(10),
    MaDichVu CHAR(10) NOT NULL,
    MaHLV CHAR(10),
    TrangThaiThanhToan BIT NOT NULL
);

CREATE TABLE LichSuThayDoi (
    MaPhieuDat CHAR(10) PRIMARY KEY,
    ThoiDiemThayDoi DATETIME NOT NULL,
    LoaiThayDoi NVARCHAR (100) NOT NULL,
    SoTienPhat INT NOT NULL,
    LyDo NVARCHAR (255),
    SoTienHoanTra INT NOT NULL
);

CREATE TABLE LichSuHuyDichVu (
    MaChiTietPDS CHAR(10) PRIMARY KEY,
    ThoiGianHuy DATETIME NOT NULL,
    LyDoHuy NVARCHAR (255),
    SoTienHoan INT NOT NULL
);

-- 6. BẢNG: THUÊ TÀI SẢN & GÓI --

CREATE TABLE GoiDichVu (
    MaGoi CHAR(10) PRIMARY KEY,
    TenGoi NVARCHAR (100) NOT NULL,
    LoaiTaiSan NVARCHAR (20) NOT NULL, -- LoaiTaiSan = 'Phòng tắm VIP', 'Tủ đồ'
    DonGia INT NOT NULL,
    ThoiGianSuDung INT NOT NULL
);

CREATE TABLE TaiSanChoThue (
    MaTaiSan CHAR(10) PRIMARY KEY,
    LoaiTaiSan NVARCHAR (20) NOT NULL, -- LoaiTaiSan = 'Phòng tắm VIP', 'Tủ đồ'
    TrangThai NVARCHAR (50) NOT NULL, --Trạng thái = 'Trống', 'Đang thuê', 'Bảo trì'
    MaCoSo CHAR(10) NOT NULL
);

-- Bảng này được tham chiếu trong Hóa Đơn và Chi Tiết, cần tạo để tránh lỗi FK
CREATE TABLE PhieuThueTaiSan (
    MaPhieuThue CHAR(10) PRIMARY KEY,
    ThoiDiemTao DATETIME,
    MaKhachHang CHAR(10) NOT NULL,
    MaNhanVien CHAR(10) NOT NULL,
    TrangThai NCHAR (20) NOT NULL, --TrangThai ('Chờ thanh toán', 'Hoàn thành', 'Đã hủy')
);

CREATE TABLE ChiTietPhieuThueTaiSan (
    MaChiTietPTTS CHAR(10) PRIMARY KEY,
    MaPhieuThue CHAR(10) NOT NULL,
    MaTaiSan CHAR(10) NOT NULL,
    MaGoi CHAR(10) NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
);

-- 7. BẢNG: HÓA ĐƠN & HỆ THỐNG --

CREATE TABLE HoaDon (
    MaHoaDon INT IDENTITY (1, 1) PRIMARY KEY,
    NgayXuat DATETIME NOT NULL,
    TongTienSan INT NOT NULL,
    TongTienDichVu INT NOT NULL,
    TongTienGiamGia INT NOT NULL,
    TongThanhToan INT NOT NULL,
    HinhThucThanhToan NVARCHAR (50), -- HinhThucThanhToan = 'Ví điện tử', 'Tiền mặt'
    TrangThaiThanhToan NVARCHAR (50), -- TrangThaiThanhToan = 'Chưa thanh toán', 'Đã thanh toán'
    MaNhanVien CHAR(10),
    MaPhieuDat CHAR(10),
    MaPhieuThue CHAR(10)
);

CREATE TABLE ThamSoHeThong (
    MaThamSo CHAR(10) PRIMARY KEY,
    TenThamSo VARCHAR(50) NOT NULL,
    GiaTri INT NOT NULL,
    DonVi NVARCHAR (50) NOT NULL,
    MoTa VARCHAR(100),
    CapNhatLanCuoi DATE NOT NULL
);

/* ====================================================
TRIỂN KHAI KHÓA NGOẠI (FOREIGN KEYS)
==================================================== */

-- TaiKhoan
ALTER TABLE TaiKhoan
ADD CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang (MaKhachHang);

ALTER TABLE TaiKhoan
ADD CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

-- NhanVien & HuanLuyenVien
ALTER TABLE NhanVien
ADD CONSTRAINT FK_NhanVien_QuanLy FOREIGN KEY (MaQuanLy) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE NhanVien
ADD CONSTRAINT FK_NhanVien_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo (MaCoSo);

ALTER TABLE NhanVien
ADD CONSTRAINT FK_NhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES ChucVu (MaChucVu);

ALTER TABLE HuanLuyenVien
ADD CONSTRAINT FK_HLV_NhanVien FOREIGN KEY (MaHLV) REFERENCES NhanVien (MaNhanVien);

-- LichLamViec
ALTER TABLE LichLamViec
ADD CONSTRAINT FK_LichLamViec_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien (MaHLV);

-- PhanCongCaTruc
ALTER TABLE PhanCongCaTruc
ADD CONSTRAINT FK_PhanCong_Ca FOREIGN KEY (MaCa) REFERENCES CaTruc (MaCa);

ALTER TABLE PhanCongCaTruc
ADD CONSTRAINT FK_PhanCong_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE PhanCongCaTruc
ADD CONSTRAINT FK_PhanCong_QL FOREIGN KEY (MaQuanLy) REFERENCES NhanVien (MaNhanVien);

-- DonNghiPhep
ALTER TABLE DonNghiPhep
ADD CONSTRAINT FK_NghiPhep_NVLap FOREIGN KEY (MaNhanVienLap) REFERENCES NhanVien (MaNhanVien);

alter table DonNghiPhep
add constraint FK_NghiPhep_NVTT foreign key (MaNhanVienThayThe) references NhanVien (MaNhanVien);

ALTER TABLE DonNghiPhep
ADD CONSTRAINT FK_NghiPhep_QL FOREIGN KEY (MaQuanLy) REFERENCES NhanVien (MaNhanVien);

-- ApDung UuDai
ALTER TABLE ApDung
ADD CONSTRAINT FK_ApDung_KH FOREIGN KEY (MaKhachHang) REFERENCES KhachHang (MaKhachHang);

ALTER TABLE ApDung
ADD CONSTRAINT FK_ApDung_UuDai FOREIGN KEY (MaUuDai) REFERENCES UuDai (MaUuDai);

-- San & BaoTri
ALTER TABLE San
ADD CONSTRAINT FK_San_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo (MaCoSo);

ALTER TABLE San
ADD CONSTRAINT FK_San_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan (MaLoaiSan);

ALTER TABLE BaoTri
ADD CONSTRAINT FK_BaoTri_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE BaoTri
ADD CONSTRAINT FK_BaoTri_San FOREIGN KEY (MaSan) REFERENCES San (MaSan);

-- Bang Gia
ALTER TABLE BangGiaTangKhungGio
ADD CONSTRAINT FK_BGTKG_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan (MaLoaiSan);

ALTER TABLE BangGiaTangKhungGio
ADD CONSTRAINT FK_BGTKG_KhungGio FOREIGN KEY (MaKhungGio) REFERENCES KhungGio (MaKhungGio);

ALTER TABLE BangGiaTangNgayLe
ADD CONSTRAINT FK_BGTNL_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan (MaLoaiSan);

ALTER TABLE BangGiaTangNgayLe
ADD CONSTRAINT FK_BGTNL_NgayLe FOREIGN KEY (MaNgayLe) REFERENCES NgayLe (MaNgayLe);

ALTER TABLE BangGiaTangCuoiTuan
ADD CONSTRAINT FK_BGTCT_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan (MaLoaiSan);

-- PhieuDatSan & ChiTiet
ALTER TABLE PhieuDatSan
ADD CONSTRAINT FK_PDS_KH FOREIGN KEY (MaKhachHang) REFERENCES KhachHang (MaKhachHang);

ALTER TABLE PhieuDatSan
ADD CONSTRAINT FK_PDS_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE PhieuDatSan
ADD CONSTRAINT FK_PDS_San FOREIGN KEY (MaSan) REFERENCES San (MaSan);

ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT FK_CTPDS_Phieu FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan (MaPhieuDat);

ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT FK_CTPDS_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT FK_CTPDS_DichVu FOREIGN KEY (MaDichVu) REFERENCES DichVu (MaDichVu);

ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT FK_CTPDS_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien (MaHLV);

-- LichSuThayDoi & Huy
ALTER TABLE LichSuThayDoi
ADD CONSTRAINT FK_LSTD_PDS FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan (MaPhieuDat);

ALTER TABLE LichSuHuyDichVu
ADD CONSTRAINT FK_LSHDV_CTPDS FOREIGN KEY (MaChiTietPDS) REFERENCES ChiTietPhieuDatSan (MaChiTietPDS);

-- DatLichHLV
ALTER TABLE DatLichHLV
ADD CONSTRAINT FK_DLHLV_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien (MaHLV);

ALTER TABLE DatLichHLV
ADD CONSTRAINT FK_DLHLV_CTPDS FOREIGN KEY (MaChiTietPDS) REFERENCES ChiTietPhieuDatSan (MaChiTietPDS);

-- Kho & TaiSan
ALTER TABLE TonKho
ADD CONSTRAINT FK_TonKho_DV FOREIGN KEY (MaDichVu) REFERENCES DichVu (MaDichVu);

ALTER TABLE TonKho
ADD CONSTRAINT FK_TonKho_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo (MaCoSo);

ALTER TABLE TaiSanChoThue
ADD CONSTRAINT FK_TSCT_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo (MaCoSo);

-- Thue Tai San
ALTER TABLE ChiTietPhieuThueTaiSan
ADD CONSTRAINT FK_CTPTTS_Phieu FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan (MaPhieuThue);

ALTER TABLE ChiTietPhieuThueTaiSan
ADD CONSTRAINT FK_CTPTTS_TaiSan FOREIGN KEY (MaTaiSan) REFERENCES TaiSanChoThue (MaTaiSan);

ALTER TABLE ChiTietPhieuThueTaiSan
ADD CONSTRAINT FK_CTPTTS_Goi FOREIGN KEY (MaGoi) REFERENCES GoiDichVu (MaGoi);

-- HoaDon
ALTER TABLE HoaDon
ADD CONSTRAINT FK_HoaDon_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien (MaNhanVien);

ALTER TABLE HoaDon
ADD CONSTRAINT FK_HoaDon_PDS FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan (MaPhieuDat);

ALTER TABLE HoaDon
ADD CONSTRAINT FK_HoaDon_PTS FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan (MaPhieuThue);

--Ràng buộc check
--1. Bảng ChucVu
ALTER TABLE ChucVu
ADD CONSTRAINT CK_ChucVu_Ten CHECK (
    TenChucVu IN (
        N'Quản lý',
        N'Lễ tân',
        N'Kỹ thuật',
        N'Thu ngân',
        N'Huấn luyện viên'
    )
);

--2. Bảng NhanVien
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NhanVien_GioiTinh CHECK (GioiTinh IN (N'Nam', N'Nữ'));

ALTER TABLE NhanVien
ADD CONSTRAINT CK_NhanVien_TrangThai CHECK (
    TrangThai IN (N'Đang làm', N'Nghỉ việc')
);

ALTER TABLE NhanVien
ADD CONSTRAINT CK_NhanVien_Luong CHECK (LuongCoBan >= 0);

--3. Bảng DonNghiPhep
ALTER TABLE DonNghiPhep
ADD CONSTRAINT CK_DonNghiPhep_TrangThai CHECK (
    TrangThai IN (
        N'Đang chờ duyệt',
        N'Đã Duyệt',
        N'Hủy'
    )
);

--4. Bảng UuDai
ALTER TABLE UuDai
ADD CONSTRAINT CK_UuDai_Loai CHECK (
    LoaiUuDai IN (
        N'Silver',
        N'Gold',
        N'Platinum',
        N'HSSV',
        N'Người cao tuổi'
    )
);

ALTER TABLE UuDai
ADD CONSTRAINT CK_UuDai_PhanTram CHECK (
    PhanTramGiamGia >= 0
    AND PhanTramGiamGia <= 100
);

--5. Bảng LoaiSan
ALTER TABLE LoaiSan
ADD CONSTRAINT CK_LoaiSan_Ten CHECK (
    TenLoaiSan IN (
        N'Bóng đá mini',
        N'Cầu lông',
        N'Tennis',
        N'Bóng rổ',
        N'Futsal'
    )
);

--6. Bảng San
ALTER TABLE San
ADD CONSTRAINT CK_San_TinhTrang CHECK (
    TinhTrang IN (
        N'Trống',
        N'Đã đặt',
        N'Đang sử dụng',
        N'Bảo trì'
    )
);

ALTER TABLE San ADD CONSTRAINT CK_San_SucChua CHECK (SucChua > 0);

--7. Bảng BaoTri
ALTER TABLE BaoTri
ADD CONSTRAINT CK_BaoTri_TrangThai CHECK (
    TrangThai IN (
        N'Đang bảo trì',
        N'Hoàn thành'
    )
);

--8. Bảng PhieuDatSan
ALTER TABLE PhieuDatSan
ADD CONSTRAINT CK_PDS_HinhThuc CHECK (
    HinhThucDat IN (N'Online', N'Tại quầy')
);

ALTER TABLE PhieuDatSan
ADD CONSTRAINT CK_PDS_TrangThai CHECK (
    TrangThaiPhieu IN (
        N'Chờ xác nhận',
        N'Đã xác nhận',
        N'Đang sử dụng',
        N'Chờ thanh toán',
        N'Hoàn thành',
        N'Đã hủy',
        N'Vắng mặt'
    )
);

--9. Bảng DichVu
ALTER TABLE DichVu
ADD CONSTRAINT CK_DichVu_Loai CHECK (
    LoaiDichVu IN (N'Dụng cụ thể thao', N'Khác')
);

ALTER TABLE DichVu
ADD CONSTRAINT CK_DichVu_DonGia CHECK (DonGia >= 0);

--10. Bảng TaiSanChoThue
ALTER TABLE TaiSanChoThue
ADD CONSTRAINT CK_TaiSan_TrangThai CHECK (
    TrangThai IN (
        N'Trống',
        N'Đang thuê',
        N'Bảo trì'
    )
);

alter table TaiSanChoThue
add check (
    LoaiTaiSan in (N'Phòng tắm VIP', N'Tủ đồ')
);

--11. Bảng HoaDon
ALTER TABLE HoaDon
ADD CONSTRAINT CK_HoaDon_HinhThucTT CHECK (
    HinhThucThanhToan IN (N'Ví điện tử', N'Tiền mặt')
);

ALTER TABLE HoaDon
ADD CONSTRAINT CK_HoaDon_TrangThaiTT CHECK (
    TrangThaiThanhToan IN (
        N'Chưa thanh toán',
        N'Đã thanh toán'
    )
);

ALTER TABLE HoaDon
ADD CONSTRAINT CK_HoaDon_TongTien CHECK (TongThanhToan >= 0);

ALTER TABLE HoaDon
ADD CONSTRAINT CK_HoaDon_CacKhoan CHECK (
    TongTienSan >= 0
    AND TongTienDichVu >= 0
    AND TongTienGiamGia >= 0
);

--12. Bảng BangGiaTang...
ALTER TABLE BangGiaTangKhungGio
ADD CONSTRAINT CK_BGTKG_Gia CHECK (GiaTang >= 0);

ALTER TABLE BangGiaTangNgayLe
ADD CONSTRAINT CK_BGTNL_Gia CHECK (GiaTang >= 0);

ALTER TABLE BangGiaTangCuoiTuan
ADD CONSTRAINT CK_BGTCT_Gia CHECK (GiaTang >= 0);

--13. TonKho
ALTER TABLE TonKho
ADD CONSTRAINT CK_TonKho_SoLuong CHECK (SoLuong >= 0);

--14. Bảng ChiTietPhieuDatSan
ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT CK_CTPDS_SoLuong CHECK (SoLuong > 0);

ALTER TABLE ChiTietPhieuDatSan
ADD CONSTRAINT CK_CTPDS_ThanhTien CHECK (ThanhTien >= 0);

-- 15. PhieuThueTaiSan
ALTER TABLE PhieuThueTaiSan
ADD CONSTRAINT CK_PTS_TrangThai CHECK (
    TrangThai IN (
        N'Chờ thanh toán',
        N'Hoàn thành',
        N'Đã hủy'
    )
);

-- 16. GoiDichVu
alter table GoiDichVu add check (DonGia >= 0);

alter table GoiDichVu add check (ThoiGianSuDung > 0);

alter table GoiDichVu
add check (
    LoaiTaiSan in (N'Phòng tắm VIP', N'Tủ đồ')
);

