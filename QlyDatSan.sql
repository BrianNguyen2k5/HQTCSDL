/* ====================================================
   DATABASE SCHEMA - SPORTS CENTER
   ==================================================== */
CREATE DATABASE QLDatSan
GO
USE QLDatSan
Go
-- 1. BẢNG: QUẢN LÝ NGƯỜI DÙNG --

CREATE TABLE TaiKhoan (
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhauMaHoa VARCHAR(255),
    Email VARCHAR(100),
    TrangThai BIT DEFAULT 1,
    NgayTao DATETIME DEFAULT GETDATE(),
    MaKhachHang CHAR(5),
    MaNhanVien CHAR(5)
);

-- 2. BẢNG: QUẢN LÝ NHÂN SỰ --

CREATE TABLE ChucVu (
    MaChucVu CHAR(5) PRIMARY KEY,
    TenChucVu NVARCHAR(50)
);

CREATE TABLE NhanVien (
    MaNhanVien CHAR(5) PRIMARY KEY,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(5),
    SoCCCD CHAR(12),
    DiaChi NVARCHAR(255),
    SoDienThoai CHAR(10),
    LuongCoBan INT,
    PhuCap INT DEFAULT 0,
    NgayVaoLam DATE,
    TrangThai NVARCHAR(20),
    MaQuanLy CHAR(5),
    MaCoSo CHAR(5),
    MaChucVu CHAR(5)
);

CREATE TABLE HuanLuyenVien (
    MaHLV CHAR(5) PRIMARY KEY,
    ChuyenMon NVARCHAR(100),
    MucLuongTheoGio INT,
    KinhNghiem NVARCHAR(255)
);

CREATE TABLE LichLamViec (
    MaHLV CHAR(5),
    NgayTrongTuan INT,
    NgayCuThe DATE,
    GioBatDau TIME,
    GioKetThuc TIME,
    TrangThai NVARCHAR(20)
    -- Lưu ý: Tài liệu không ghi rõ PK cho bảng này, tạm thời để trống PK
);

CREATE TABLE CaTruc (
    MaCa CHAR(5) PRIMARY KEY,
    TenCa NVARCHAR(50),
    GioBatDau TIME,
    GioKetThuc TIME
);

CREATE TABLE PhanCongCaTruc (
    MaCa CHAR(5),
    MaNhanVien CHAR(5),
    NgayLamViec DATE,
    MaQuanLy CHAR(5),
    PRIMARY KEY (MaCa, MaNhanVien, NgayLamViec)
);

CREATE TABLE DonNghiPhep (
    MaDon CHAR(5) PRIMARY KEY,
    NgayXinNghi DATE,
    LyDo NVARCHAR(255),
    TrangThai NVARCHAR(20),
    MaNhanVien CHAR(5),
    MaQuanLy CHAR(5)
);

-- 3. BẢNG: KHÁCH HÀNG & ƯU ĐÃI --

CREATE TABLE KhachHang (
    MaKhachHang CHAR(5) PRIMARY KEY,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    SoCCCD CHAR(12),
    SoDienThoai CHAR(10),
    Email VARCHAR(100)
);

CREATE TABLE UuDai (
    MaUuDai CHAR(5) PRIMARY KEY,
    LoaiUuDai NVARCHAR(100),
    PhanTramGiamGia INT
);

CREATE TABLE ApDung (
    MaKhachHang CHAR(5),
    MaUuDai CHAR(5),
    NgayBatDau DATETIME,
    NgayKetThuc DATETIME,
    PRIMARY KEY (MaKhachHang, MaUuDai)
);

-- 4. BẢNG: CƠ SỞ & SÂN BÃI --

CREATE TABLE CoSo (
    MaCoSo CHAR(5) PRIMARY KEY,
    TenCoSo NVARCHAR(100),
    DiaChi NVARCHAR(255)
);

CREATE TABLE LoaiSan (
    MaLoaiSan CHAR(5) PRIMARY KEY,
    TenLoaiSan NVARCHAR(50),
    DonViTinh NVARCHAR(20),
    GiaGoc INT,
    MoTa NVARCHAR(255)
);

CREATE TABLE San (
    MaSan CHAR(5) PRIMARY KEY,
    TenSan NVARCHAR(50),
    TinhTrang NVARCHAR(20),
    SucChua INT,
    MaCoSo CHAR(5),
    MaLoaiSan CHAR(5)
);

CREATE TABLE BaoTri (
    MaNhanVien CHAR(5),
    MaSan CHAR(5),
    NgayBaoTri DATETIME,
    NgayHoanThanh DATETIME,
    TrangThai NVARCHAR(20),
    ChiPhi INT DEFAULT 0,
    MoTa NVARCHAR(255),
    PRIMARY KEY (MaNhanVien, MaSan)
);

CREATE TABLE KhungGio (
    MaKhungGio CHAR(5) PRIMARY KEY,
    GioBatDau TIME,
    GioKetThuc TIME
);

CREATE TABLE NgayLe (
    MaNgayLe DATE PRIMARY KEY,
    TenNgayLe NVARCHAR(100)
);

-- Bảng giá phụ thu
CREATE TABLE BangGiaTangKhungGio (
    MaLoaiSan CHAR(5),
    MaKhungGio CHAR(5),
    GiaTang INT,
    PRIMARY KEY (MaLoaiSan, MaKhungGio)
);

CREATE TABLE BangGiaTangNgayLe (
    MaLoaiSan CHAR(5),
    MaNgayLe DATE,
    GiaTang INT,
    PRIMARY KEY (MaLoaiSan, MaNgayLe)
);

CREATE TABLE BangGiaTangCuoiTuan (
    MaLoaiSan CHAR(5) PRIMARY KEY,
    GiaTang INT
);

-- 5. BẢNG: GIAO DỊCH & DỊCH VỤ --

CREATE TABLE PhieuDatSan (
    MaPhieuDat CHAR(5) PRIMARY KEY,
    NgayDat DATETIME,
    NgayNhanSan DATE,
    GioBatDau TIME,
    GioKetThuc TIME,
    HinhThucDat NVARCHAR(50),
    TrangThaiPhieu NVARCHAR(20),
    MaKhachHang CHAR(5),
    MaNhanVien CHAR(5),
    MaSan CHAR(5)
);

CREATE TABLE DatLichHLV (
    MaChiTietPDS CHAR(5) PRIMARY KEY,
    MaHLV CHAR(5),
    GioBatDauDV DATETIME,
    GioKetThucDV DATETIME
);

CREATE TABLE DichVu (
    MaDichVu CHAR(5) PRIMARY KEY,
    TenDichVu NVARCHAR(100),
    LoaiDichVu NVARCHAR(20),
    DonGia INT,
    DonViTinh NVARCHAR(10),
    TrangThaiKhaDung BIT
);

CREATE TABLE TonKho (
    MaDichVu CHAR(5),
    MaCoSo CHAR(5),
    SoLuong INT,
    PRIMARY KEY (MaDichVu, MaCoSo)
);

CREATE TABLE ChiTietPhieuDatSan (
    MaChiTietPDS CHAR(5) PRIMARY KEY,
    SoLuong INT,
    ThanhTien INT,
    LoaiYeuCau NVARCHAR(100),
    MaPhieuDat CHAR(5),
    MaNhanVien CHAR(5),
    MaDichVu CHAR(5),
    MaHLV CHAR(5)
);

CREATE TABLE LichSuThayDoi (
    MaPhieuDat CHAR(5),
    ThoiDiemThayDoi DATETIME,
    LoaiThayDoi NVARCHAR(100),
    SoTienPhat INT,
    LyDo NVARCHAR(255),
    SoTienHoanTra INT,
    MaPhieuDatThayDoi CHAR(5)
);

CREATE TABLE LichSuHuyDichVu (
    MaChiTietPDS CHAR(5),
    ThoiGianHuy DATETIME,
    LyDoHuy NVARCHAR(255),
    TrangThaiDichVu NVARCHAR(50),
    DuocHoanTien BIT,
    SoTienHoan INT
);

-- 6. BẢNG: THUÊ TÀI SẢN & GÓI --

CREATE TABLE GoiDichVu (
    MaGoi CHAR(5) PRIMARY KEY,
    TenGoi NVARCHAR(100),
    LoaiTaiSan NVARCHAR(20),
    DonGia INT,
    ThoiGianSuDung INT
);

CREATE TABLE TaiSanChoThue (
    MaTaiSan CHAR(5) PRIMARY KEY,
    LoaiTaiSan NVARCHAR(20),
    TrangThai NVARCHAR(50),
    MaCoSo CHAR(5)
);

-- Bảng này được tham chiếu trong Hóa Đơn và Chi Tiết, cần tạo để tránh lỗi FK
CREATE TABLE PhieuThueTaiSan (
    MaPhieuThue CHAR(5) PRIMARY KEY,
    NgayThue DATETIME,
    MaKhachHang CHAR(5),
    MaNhanVien CHAR(5)
);

CREATE TABLE ChiTietPhieuThueTaiSan (
    MaChiTietPTTS CHAR(5) PRIMARY KEY,
    MaPhieuThue CHAR(5),
    MaTaiSan CHAR(5),
    MaGoi CHAR(5)
);

-- 7. BẢNG: HÓA ĐƠN & HỆ THỐNG --

CREATE TABLE HoaDon (
    MaHoaDon CHAR(5) PRIMARY KEY,
    NgayXuat DATETIME,
    TongTienSan INT,
    TongTienDichVu INT,
    TongTienGiamGia INT,
    TongThanhToan INT,
    HinhThucThanhToan NVARCHAR(50),
    TrangThaiThanhToan NVARCHAR(50),
    MaNhanVien CHAR(5),
    MaPhieuDat CHAR(5),
    MaPhieuThue CHAR(5)
);

CREATE TABLE ThamSoHeThong (
    MaThamSo CHAR(5) PRIMARY KEY,
    TenThamSo VARCHAR(50),
    GiaTri INT,
    DonVi NVARCHAR(50),
    MoTa VARCHAR(100),
    CapNhatLanCuoi DATE
);

/* ====================================================
   TRIỂN KHAI KHÓA NGOẠI (FOREIGN KEYS)
   ==================================================== */

-- TaiKhoan
ALTER TABLE TaiKhoan ADD CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);
ALTER TABLE TaiKhoan ADD CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);

-- NhanVien & HuanLuyenVien
ALTER TABLE NhanVien ADD CONSTRAINT FK_NhanVien_QuanLy FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE NhanVien ADD CONSTRAINT FK_NhanVien_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo);
ALTER TABLE NhanVien ADD CONSTRAINT FK_NhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES ChucVu(MaChucVu);
ALTER TABLE HuanLuyenVien ADD CONSTRAINT FK_HLV_NhanVien FOREIGN KEY (MaHLV) REFERENCES NhanVien(MaNhanVien);

-- LichLamViec
ALTER TABLE LichLamViec ADD CONSTRAINT FK_LichLamViec_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV);

-- PhanCongCaTruc
ALTER TABLE PhanCongCaTruc ADD CONSTRAINT FK_PhanCong_Ca FOREIGN KEY (MaCa) REFERENCES CaTruc(MaCa);
ALTER TABLE PhanCongCaTruc ADD CONSTRAINT FK_PhanCong_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE PhanCongCaTruc ADD CONSTRAINT FK_PhanCong_QL FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien);

-- DonNghiPhep
ALTER TABLE DonNghiPhep ADD CONSTRAINT FK_NghiPhep_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE DonNghiPhep ADD CONSTRAINT FK_NghiPhep_QL FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien);

-- ApDung UuDai
ALTER TABLE ApDung ADD CONSTRAINT FK_ApDung_KH FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);
ALTER TABLE ApDung ADD CONSTRAINT FK_ApDung_UuDai FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai);

-- San & BaoTri
ALTER TABLE San ADD CONSTRAINT FK_San_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo);
ALTER TABLE San ADD CONSTRAINT FK_San_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan);
ALTER TABLE BaoTri ADD CONSTRAINT FK_BaoTri_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE BaoTri ADD CONSTRAINT FK_BaoTri_San FOREIGN KEY (MaSan) REFERENCES San(MaSan);

-- Bang Gia
ALTER TABLE BangGiaTangKhungGio ADD CONSTRAINT FK_BGTKG_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan);
ALTER TABLE BangGiaTangKhungGio ADD CONSTRAINT FK_BGTKG_KhungGio FOREIGN KEY (MaKhungGio) REFERENCES KhungGio(MaKhungGio);
ALTER TABLE BangGiaTangNgayLe ADD CONSTRAINT FK_BGTNL_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan);
ALTER TABLE BangGiaTangNgayLe ADD CONSTRAINT FK_BGTNL_NgayLe FOREIGN KEY (MaNgayLe) REFERENCES NgayLe(MaNgayLe);
ALTER TABLE BangGiaTangCuoiTuan ADD CONSTRAINT FK_BGTCT_LoaiSan FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan);

-- PhieuDatSan & ChiTiet
ALTER TABLE PhieuDatSan ADD CONSTRAINT FK_PDS_KH FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);
ALTER TABLE PhieuDatSan ADD CONSTRAINT FK_PDS_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE PhieuDatSan ADD CONSTRAINT FK_PDS_San FOREIGN KEY (MaSan) REFERENCES San(MaSan);

ALTER TABLE ChiTietPhieuDatSan ADD CONSTRAINT FK_CTPDS_Phieu FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat);
ALTER TABLE ChiTietPhieuDatSan ADD CONSTRAINT FK_CTPDS_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE ChiTietPhieuDatSan ADD CONSTRAINT FK_CTPDS_DichVu FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu);
ALTER TABLE ChiTietPhieuDatSan ADD CONSTRAINT FK_CTPDS_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV);

-- LichSuThayDoi & Huy
ALTER TABLE LichSuThayDoi ADD CONSTRAINT FK_LSTD_PDS FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat);
ALTER TABLE LichSuThayDoi ADD CONSTRAINT FK_LSTD_PDS_Moi FOREIGN KEY (MaPhieuDatThayDoi) REFERENCES PhieuDatSan(MaPhieuDat);
ALTER TABLE LichSuHuyDichVu ADD CONSTRAINT FK_LSHDV_CTPDS FOREIGN KEY (MaChiTietPDS) REFERENCES ChiTietPhieuDatSan(MaChiTietPDS);

-- DatLichHLV
ALTER TABLE DatLichHLV ADD CONSTRAINT FK_DLHLV_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV);
ALTER TABLE DatLichHLV ADD CONSTRAINT FK_DLHLV_CTPDS FOREIGN KEY (MaChiTietPDS) REFERENCES ChiTietPhieuDatSan(MaChiTietPDS);


-- Kho & TaiSan
ALTER TABLE TonKho ADD CONSTRAINT FK_TonKho_DV FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu);
ALTER TABLE TonKho ADD CONSTRAINT FK_TonKho_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo);
ALTER TABLE TaiSanChoThue ADD CONSTRAINT FK_TSCT_CoSo FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo);

-- Thue Tai San
ALTER TABLE ChiTietPhieuThueTaiSan ADD CONSTRAINT FK_CTPTTS_Phieu FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan(MaPhieuThue);
ALTER TABLE ChiTietPhieuThueTaiSan ADD CONSTRAINT FK_CTPTTS_TaiSan FOREIGN KEY (MaTaiSan) REFERENCES TaiSanChoThue(MaTaiSan);
ALTER TABLE ChiTietPhieuThueTaiSan ADD CONSTRAINT FK_CTPTTS_Goi FOREIGN KEY (MaGoi) REFERENCES GoiDichVu(MaGoi);

-- HoaDon
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDon_NV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDon_PDS FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat);
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDon_PTS FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan(MaPhieuThue);

-- USE master
-- ALTER DATABASE QLDatSan SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- DROP DATABASE QLDatSan;
