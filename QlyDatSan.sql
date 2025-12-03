/* ====================================================
   DATABASE SCHEMA FOR SPORTS CENTER MANAGEMENT
   Based on provided design document
   ==================================================== */

-- 1. GROUP: USER MANAGEMENT (Quản lý người dùng) --

CREATE TABLE TaiKhoan (
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhauMaHoa VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    TrangThai BIT NOT NULL DEFAULT 1, -- 1: Active, 0: Locked
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    MaKhachHang CHAR(5) NULL,
    MaNhanVien CHAR(5) NULL
    -- Foreign keys will be added at the end to prevent circular dependency errors during creation
);

-- 2. GROUP: HUMAN RESOURCES (Quản lý nhân sự) --

CREATE TABLE ChucVu (
    MaChucVu CHAR(5) PRIMARY KEY,
    TenChucVu NVARCHAR(50) CHECK (TenChucVu IN (N'Quản lý', N'Lễ tân', N'Kỹ thuật', N'Thu ngân', N'Huấn luyện viên'))
);

CREATE TABLE NhanVien (
    MaNhanVien CHAR(5) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR(5) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    SoCCCD CHAR(12) NOT NULL UNIQUE,
    DiaChi NVARCHAR(255) NULL,
    SoDienThoai CHAR(10) NOT NULL UNIQUE,
    LuongCoBan INT NOT NULL CHECK (LuongCoBan >= 0),
    PhuCap INT NOT NULL DEFAULT 0 CHECK (PhuCap >= 0),
    NgayVaoLam DATE NOT NULL,
    TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Đang làm việc', N'Đã nghỉ việc')),
    MaQuanLy CHAR(5) NULL, -- Self-reference to NhanVien
    MaCoSo CHAR(5) NOT NULL, -- FK to CoSo
    MaChucVu CHAR(5) NOT NULL -- FK to ChucVu
);

CREATE TABLE HuanLuyenVien (
    MaHLV CHAR(5) PRIMARY KEY, -- FK to NhanVien
    ChuyenMon NVARCHAR(100), -- Example: 'Tennis', 'Bóng rổ'
    MucLuongTheoGio INT NOT NULL CHECK (MucLuongTheoGio >= 0),
    KinhNghiem NVARCHAR(255) NULL
);

CREATE TABLE LichLamViec (
    MaHLV CHAR(5) NOT NULL,
    NgayTrongTuan INT NULL CHECK (NgayTrongTuan BETWEEN 2 AND 8), -- 2=Mon ... 8=Sun
    NgayCuThe DATE NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    TrangThai NVARCHAR(20), -- e.g., 'Sẵn sàng', 'Đã được đặt'
    CONSTRAINT CK_GioLich CHECK (GioKetThuc > GioBatDau),
    CONSTRAINT FK_LichLamViec_HLV FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV)
    -- Note: No explicit PK defined in doc, but usually composite or ID. 
);

CREATE TABLE CaTruc (
    MaCa CHAR(5) PRIMARY KEY,
    TenCa NVARCHAR(50), -- e.g., 'Ca sáng (06:00 - 14:00)'
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL
);

CREATE TABLE PhanCongCaTruc (
    MaCa CHAR(5) NOT NULL,
    MaNhanVien CHAR(5) NOT NULL,
    NgayLamViec DATE NOT NULL,
    MaQuanLy CHAR(5) NULL, -- Manager who assigned
    PRIMARY KEY (MaCa, MaNhanVien, NgayLamViec),
    FOREIGN KEY (MaCa) REFERENCES CaTruc(MaCa),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien)
);

CREATE TABLE DonNghiPhep (
    MaDon CHAR(5) PRIMARY KEY,
    NgayXinNghi DATE NOT NULL,
    LyDo NVARCHAR(255) NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL CHECK (TrangThai IN (N'Chờ duyệt', N'Đã duyệt', N'Từ chối')),
    MaNhanVien CHAR(5) NOT NULL, -- FK requesting employee
    MaQuanLy CHAR(5) NULL, -- FK approving manager
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien)
);

-- 3. GROUP: CUSTOMER & PROMOTIONS (Khách hàng & Ưu đãi) --

CREATE TABLE KhachHang (
    MaKhachHang CHAR(5) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE NULL,
    SoCCCD CHAR(12) NOT NULL UNIQUE,
    SoDienThoai CHAR(10) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE UuDai (
    MaUuDai CHAR(5) PRIMARY KEY,
    LoaiUuDai NVARCHAR(100) NOT NULL,
    PhanTramGiamGia INT CHECK (PhanTramGiamGia BETWEEN 0 AND 100)
);

CREATE TABLE ApDung (
    MaKhachHang CHAR(5) NOT NULL,
    MaUuDai CHAR(5) NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NULL,
    PRIMARY KEY (MaKhachHang, MaUuDai),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    FOREIGN KEY (MaUuDai) REFERENCES UuDai(MaUuDai),
    CONSTRAINT CK_ThoiGianApDung CHECK (NgayKetThuc >= NgayBatDau OR NgayKetThuc IS NULL)
);

-- 4. GROUP: FACILITY & COURTS (Cơ sở & Sân bãi) --

CREATE TABLE CoSo (
    MaCoSo CHAR(5) PRIMARY KEY,
    TenCoSo NVARCHAR(100) NOT NULL UNIQUE,
    DiaChi NVARCHAR(255) NOT NULL
);

CREATE TABLE LoaiSan (
    MaLoaiSan CHAR(5) PRIMARY KEY,
    TenLoaiSan NVARCHAR(50) NOT NULL UNIQUE,
    DonViTinh NVARCHAR(20) NOT NULL, -- e.g., "Giờ", "Trận"
    GiaGoc INT NOT NULL CHECK (GiaGoc > 0),
    MoTa NVARCHAR(255) NULL
);

CREATE TABLE San (
    MaSan CHAR(5) PRIMARY KEY,
    TenSan NVARCHAR(50) NOT NULL,
    TinhTrang NVARCHAR(20) NOT NULL CHECK (TinhTrang IN (N'ConTrong', N'DaDat', N'DangSuDung', N'BaoTri')),
    SucChua INT CHECK (SucChua > 0),
    MaCoSo CHAR(5) NOT NULL,
    MaLoaiSan CHAR(5) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo),
    FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan)
);

CREATE TABLE BaoTri (
    MaNhanVien CHAR(5) NOT NULL,
    MaSan CHAR(5) NOT NULL,
    NgayBaoTri DATETIME NOT NULL,
    NgayHoanThanh DATETIME NULL,
    TrangThai NVARCHAR(20) NOT NULL CHECK (TrangThai IN (N'Đang xử lý', N'Hoàn thành')),
    ChiPhi INT NOT NULL DEFAULT 0 CHECK (ChiPhi >= 0),
    MoTa NVARCHAR(255) NULL,
    PRIMARY KEY (MaNhanVien, MaSan), -- Based on doc, but likely implies one active maintenance per pair
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaSan) REFERENCES San(MaSan),
    CONSTRAINT CK_BaoTri_Date CHECK (NgayHoanThanh > NgayBaoTri OR NgayHoanThanh IS NULL)
);

CREATE TABLE KhungGio (
    MaKhungGio CHAR(5) PRIMARY KEY,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    CONSTRAINT CK_KhungGio CHECK (GioKetThuc > GioBatDau)
);

CREATE TABLE NgayLe (
    MaNgayLe DATE PRIMARY KEY, -- Using dummy year 2000 as per doc
    TenNgayLe NVARCHAR(100) NOT NULL
);

-- Pricing Surcharges
CREATE TABLE BangGiaTangKhungGio (
    MaLoaiSan CHAR(5) NOT NULL,
    MaKhungGio CHAR(5) NOT NULL,
    GiaTang INT NOT NULL CHECK (GiaTang >= 0),
    PRIMARY KEY (MaLoaiSan, MaKhungGio),
    FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan),
    FOREIGN KEY (MaKhungGio) REFERENCES KhungGio(MaKhungGio)
);

CREATE TABLE BangGiaTangNgayLe (
    MaLoaiSan CHAR(5) NOT NULL,
    MaNgayLe DATE NOT NULL,
    GiaTang INT NOT NULL CHECK (GiaTang >= 0),
    PRIMARY KEY (MaLoaiSan, MaNgayLe),
    FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan),
    FOREIGN KEY (MaNgayLe) REFERENCES NgayLe(MaNgayLe)
);

CREATE TABLE BangGiaTangCuoiTuan (
    MaLoaiSan CHAR(5) NOT NULL,
    GiaTang INT NOT NULL CHECK (GiaTang >= 0), -- Surcharge for Sunday
    PRIMARY KEY (MaLoaiSan),
    FOREIGN KEY (MaLoaiSan) REFERENCES LoaiSan(MaLoaiSan)
);

-- 5. GROUP: CORE TRANSACTIONS (Giao dịch cốt lõi) --

CREATE TABLE PhieuDatSan (
    MaPhieuDat CHAR(5) PRIMARY KEY,
    NgayDat DATETIME NOT NULL,
    NgayNhanSan DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    HinhThucDat NVARCHAR(50) NULL, -- 'Online', 'Tại quầy'
    TrangThaiPhieu NVARCHAR(20) NULL,
    MaKhachHang CHAR(5) NOT NULL,
    MaNhanVien CHAR(5) NULL, -- Staff who confirmed
    MaSan CHAR(5) NOT NULL,
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaSan) REFERENCES San(MaSan)
);

CREATE TABLE DatLichHLV (
    MaHLV CHAR(5) NOT NULL,
    GioBatDauDV DATETIME NOT NULL,
    GioKetThucDV DATETIME NOT NULL,
    FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV)
    -- This table seems to link specific time slots to HLV, context suggests it might relate to PhieuDatSan via details
);

-- 6. GROUP: SERVICES & PRICES (Dịch vụ & Giá) --

CREATE TABLE DichVu (
    MaDichVu CHAR(5) PRIMARY KEY,
    TenDichVu NVARCHAR(100) NOT NULL,
    LoaiDichVu NVARCHAR(20) NULL, -- 'Thuê đồ', 'Thuê HLV', 'Khác'
    DonGia INT NOT NULL CHECK (DonGia >= 0),
    DonViTinh NVARCHAR(10) NOT NULL, -- 'Bộ', 'Giờ'
    TrangThaiKhaDung BIT NULL -- 1 or 0
);

CREATE TABLE TonKho (
    MaDichVu CHAR(5) NOT NULL,
    MaCoSo CHAR(5) NOT NULL,
    SoLuong INT CHECK (SoLuong >= 0),
    PRIMARY KEY (MaDichVu, MaCoSo),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu),
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

-- 7. GROUP: BOOKING DETAILS & HISTORY --

CREATE TABLE ChiTietPhieuDatSan (
    MaChiTietPDS CHAR(5) PRIMARY KEY,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    ThanhTien INT NOT NULL CHECK (ThanhTien >= 0),
    LoaiYeuCau NVARCHAR(100) NULL,
    MaPhieuDat CHAR(5) NOT NULL,
    MaNhanVien CHAR(5) NULL, -- Staff adding this detail
    MaDichVu CHAR(5) NULL,
    MaHLV CHAR(5) NULL,
    FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu),
    FOREIGN KEY (MaHLV) REFERENCES HuanLuyenVien(MaHLV)
);

CREATE TABLE LichSuThayDoi (
    MaPhieuDat CHAR(5) NOT NULL,
    ThoiDiemThayDoi DATETIME NOT NULL,
    LoaiThayDoi NVARCHAR(100) NULL,
    SoTienPhat INT CHECK (SoTienPhat >= 0),
    LyDo NVARCHAR(255) NULL,
    SoTienHoanTra INT CHECK (SoTienHoanTra >= 0),
    MaPhieuDatThayDoi CHAR(5) NULL, -- FK to new PhieuDatSan
    FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat),
    FOREIGN KEY (MaPhieuDatThayDoi) REFERENCES PhieuDatSan(MaPhieuDat)
);

CREATE TABLE LichSuHuyDichVu (
    MaChiTietPDS CHAR(5) NOT NULL,
    ThoiGianHuy DATETIME NOT NULL,
    LyDoHuy NVARCHAR(255) NULL,
    TrangThaiDichVu NVARCHAR(50) NULL,
    DuocHoanTien BIT CHECK (DuocHoanTien IN (0, 1)),
    SoTienHoan INT CHECK (SoTienHoan >= 0),
    FOREIGN KEY (MaChiTietPDS) REFERENCES ChiTietPhieuDatSan(MaChiTietPDS)
);

-- 8. GROUP: ASSET RENTAL & PACKAGES (Thuê tài sản & Gói) --

CREATE TABLE GoiDichVu (
    MaGoi CHAR(5) PRIMARY KEY,
    TenGoi NVARCHAR(100),
    LoaiTaiSan NVARCHAR(20), -- 'Tủ đồ', 'Phòng tắm VIP'
    DonGia INT CHECK (DonGia >= 0),
    ThoiGianSuDung INT -- 1 or 30 (days/shifts)
);

CREATE TABLE TaiSanChoThue (
    MaTaiSan CHAR(5) PRIMARY KEY,
    LoaiTaiSan NVARCHAR(20),
    TrangThai NVARCHAR(50), -- 'Trống', 'Được sử dụng'
    MaCoSo CHAR(5) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

-- Assumed Table based on usage in "ChiTietPhieuThueTaiSan" and "HoaDon" FKs
-- Note: Definition was not explicitly clear in snippets, inferred from relationships.
CREATE TABLE PhieuThueTaiSan (
    MaPhieuThue CHAR(5) PRIMARY KEY,
    -- Assuming basic fields based on context
    NgayThue DATETIME,
    MaKhachHang CHAR(5),
    MaNhanVien CHAR(5)
    -- Add FKs if table created strictly
);

CREATE TABLE ChiTietPhieuThueTaiSan (
    MaChiTietPTTS CHAR(5) PRIMARY KEY,
    MaPhieuThue CHAR(5) NOT NULL,
    MaTaiSan CHAR(5) NOT NULL,
    MaGoi CHAR(5) NULL,
    FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan(MaPhieuThue),
    FOREIGN KEY (MaTaiSan) REFERENCES TaiSanChoThue(MaTaiSan),
    FOREIGN KEY (MaGoi) REFERENCES GoiDichVu(MaGoi)
);

-- 9. GROUP: INVOICE (Hóa đơn) --

CREATE TABLE HoaDon (
    MaHoaDon CHAR(5) PRIMARY KEY,
    NgayXuat DATETIME NOT NULL,
    TongTienSan INT CHECK (TongTienSan >= 0),
    TongTienDichVu INT CHECK (TongTienDichVu >= 0),
    TongTienGiamGia INT CHECK (TongTienGiamGia >= 0),
    TongThanhToan INT NOT NULL,
    HinhThucThanhToan NVARCHAR(50) NULL,
    TrangThaiThanhToan NVARCHAR(50) NOT NULL,
    MaNhanVien CHAR(5) NOT NULL,
    MaPhieuDat CHAR(5) NULL,
    MaPhieuThue CHAR(5) NULL,
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaPhieuDat) REFERENCES PhieuDatSan(MaPhieuDat),
    FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueTaiSan(MaPhieuThue)
);

-- 10. GROUP: SYSTEM PARAMETERS (Hệ thống) --

CREATE TABLE ThamSoHeThong (
    MaThamSo CHAR(5) PRIMARY KEY,
    TenThamSo VARCHAR(50) NOT NULL,
    GiaTri INT NOT NULL,
    DonVi NVARCHAR(50) NOT NULL,
    MoTa VARCHAR(100),
    CapNhatLanCuoi DATE NOT NULL
);

-- ADDING FOREIGN KEYS FOR TAIKHOAN (Delayed to ensure tables exist) --
ALTER TABLE TaiKhoan ADD CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);
ALTER TABLE TaiKhoan ADD CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
ALTER TABLE HuanLuyenVien ADD CONSTRAINT FK_HLV_NhanVien FOREIGN KEY (MaHLV) REFERENCES NhanVien(MaNhanVien);