/* ====================================================
   STORED PROCEDURES - CASHIER MODULE (THU NGÂN)
   ==================================================== */

USE VietSport
GO

-- =============================================
-- 1. Lấy danh sách hóa đơn
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetAllInvoices
    @MaCoSo CHAR(10) = NULL,
    @TrangThai NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        hd.MaHoaDon,
        hd.NgayXuat,
        hd.TongTienSan,
        hd.TongTienDichVu,
        hd.TongTienGiamGia,
        hd.TongThanhToan,
        hd.HinhThucThanhToan,
        hd.TrangThaiThanhToan,
        hd.MaNhanVien,
        hd.MaPhieuDat,
        hd.MaPhieuThue,
        -- Thông tin khách hàng
        kh.MaKhachHang,
        kh.HoTen AS TenKhachHang,
        kh.SoDienThoai,
        kh.Email,
        -- Thông tin ưu đãi (nếu có)
        ud.LoaiUuDai,
        ud.PhanTramGiamGia,
        -- Thông tin phiếu đặt sân (nếu có)
        pds.NgayNhanSan,
        pds.GioBatDau,
        pds.GioKetThuc,
        pds.TrangThaiPhieu,
        s.TenSan,
        ls.TenLoaiSan,
        cs.TenCoSo,
        cs.MaCoSo
    FROM HoaDon hd
    LEFT JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
    LEFT JOIN PhieuThueTaiSan pts ON hd.MaPhieuThue = pts.MaPhieuThue
    LEFT JOIN KhachHang kh ON (pds.MaKhachHang = kh.MaKhachHang OR pts.MaKhachHang = kh.MaKhachHang)
    LEFT JOIN San s ON pds.MaSan = s.MaSan
    LEFT JOIN LoaiSan ls ON s.MaLoaiSan = ls.MaLoaiSan
    LEFT JOIN CoSo cs ON s.MaCoSo = cs.MaCoSo
    LEFT JOIN ApDung ad ON kh.MaKhachHang = ad.MaKhachHang 
        AND ad.TrangThai = 1 
        AND GETDATE() BETWEEN ad.NgayBatDau AND ad.NgayKetThuc
    LEFT JOIN UuDai ud ON ad.MaUuDai = ud.MaUuDai
    WHERE (@MaCoSo IS NULL OR cs.MaCoSo = @MaCoSo)
        AND (@TrangThai IS NULL OR hd.TrangThaiThanhToan = @TrangThai)
    ORDER BY 
        CASE WHEN hd.TrangThaiThanhToan = N'Chưa thanh toán' THEN 0 ELSE 1 END,
        hd.NgayXuat DESC;
END
GO

-- =============================================
-- 2. Lấy chi tiết hóa đơn
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetInvoiceDetail
    @MaHoaDon INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin hóa đơn chính
    SELECT 
        hd.MaHoaDon,
        hd.NgayXuat,
        hd.TongTienSan,
        hd.TongTienDichVu,
        hd.TongTienGiamGia,
        hd.TongThanhToan,
        hd.HinhThucThanhToan,
        hd.TrangThaiThanhToan,
        hd.MaNhanVien,
        hd.MaPhieuDat,
        hd.MaPhieuThue,
        -- Thông tin khách hàng
        kh.MaKhachHang,
        kh.HoTen AS TenKhachHang,
        kh.SoDienThoai,
        kh.Email,
        kh.NgaySinh,
        -- Thông tin ưu đãi
        ud.LoaiUuDai,
        ud.PhanTramGiamGia,
        -- Thông tin phiếu đặt sân
        pds.NgayDat,
        pds.NgayNhanSan,
        pds.GioBatDau,
        pds.GioKetThuc,
        pds.HinhThucDat,
        pds.TrangThaiPhieu,
        pds.ThoiGianCheckin,
        -- Thông tin sân
        s.MaSan,
        s.TenSan,
        ls.TenLoaiSan,
        ls.GiaGoc AS GiaGocSan,
        ls.DonViTinhTheoPhut,
        -- Thông tin cơ sở
        cs.MaCoSo,
        cs.TenCoSo,
        cs.DiaChi AS DiaChiCoSo
    FROM HoaDon hd
    LEFT JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
    LEFT JOIN PhieuThueTaiSan pts ON hd.MaPhieuThue = pts.MaPhieuThue
    LEFT JOIN KhachHang kh ON (pds.MaKhachHang = kh.MaKhachHang OR pts.MaKhachHang = kh.MaKhachHang)
    LEFT JOIN San s ON pds.MaSan = s.MaSan
    LEFT JOIN LoaiSan ls ON s.MaLoaiSan = ls.MaLoaiSan
    LEFT JOIN CoSo cs ON s.MaCoSo = cs.MaCoSo
    LEFT JOIN ApDung ad ON kh.MaKhachHang = ad.MaKhachHang 
        AND ad.TrangThai = 1 
        AND GETDATE() BETWEEN ad.NgayBatDau AND ad.NgayKetThuc
    LEFT JOIN UuDai ud ON ad.MaUuDai = ud.MaUuDai
    WHERE hd.MaHoaDon = @MaHoaDon;
    
    -- Chi tiết dịch vụ từ phiếu đặt sân
    SELECT 
        ct.MaChiTietPDS,
        ct.SoLuong,
        ct.ThanhTien,
        ct.ThoiDiemTao,
        ct.TrangThaiThanhToan,
        dv.MaDichVu,
        dv.TenDichVu,
        dv.LoaiDichVu,
        dv.DonGia,
        dv.DonViTinh,
        -- Thông tin HLV nếu có
        hlv.MaHLV,
        nv.HoTen AS TenHLV,
        hlv.GiaThuTheoGio,
        dlhlv.GioBatDauDV,
        dlhlv.GioKetThucDV
    FROM HoaDon hd
    INNER JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
    INNER JOIN ChiTietPhieuDatSan ct ON pds.MaPhieuDat = ct.MaPhieuDat
    LEFT JOIN DichVu dv ON ct.MaDichVu = dv.MaDichVu
    LEFT JOIN HuanLuyenVien hlv ON ct.MaHLV = hlv.MaHLV
    LEFT JOIN NhanVien nv ON hlv.MaHLV = nv.MaNhanVien
    LEFT JOIN DatLichHLV dlhlv ON ct.MaChiTietPDS = dlhlv.MaChiTietPDS
    WHERE hd.MaHoaDon = @MaHoaDon;
    
    -- Chi tiết thuê tài sản (nếu có)
    SELECT 
        ct.MaChiTietPTTS,
        ct.NgayBatDau,
        ct.NgayKetThuc,
        ts.MaTaiSan,
        ts.LoaiTaiSan,
        goi.MaGoi,
        goi.TenGoi,
        goi.DonGia,
        goi.ThoiGianSuDung
    FROM HoaDon hd
    INNER JOIN PhieuThueTaiSan pts ON hd.MaPhieuThue = pts.MaPhieuThue
    INNER JOIN ChiTietPhieuThueTaiSan ct ON pts.MaPhieuThue = ct.MaPhieuThue
    LEFT JOIN TaiSanChoThue ts ON ct.MaTaiSan = ts.MaTaiSan
    LEFT JOIN GoiDichVu goi ON ct.MaGoi = goi.MaGoi
    WHERE hd.MaHoaDon = @MaHoaDon;
END
GO

-- =============================================
-- 3. Xử lý thanh toán
-- =============================================
CREATE OR ALTER PROCEDURE sp_ProcessPayment
    @MaHoaDon INT,
    @HinhThucThanhToan NVARCHAR(50),
    @MaNhanVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Kiểm tra hóa đơn tồn tại
        IF NOT EXISTS (SELECT 1 FROM HoaDon WHERE MaHoaDon = @MaHoaDon)
        BEGIN
            RAISERROR(N'Hóa đơn không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra hóa đơn đã thanh toán chưa
        IF EXISTS (SELECT 1 FROM HoaDon WHERE MaHoaDon = @MaHoaDon AND TrangThaiThanhToan = N'Đã thanh toán')
        BEGIN
            RAISERROR(N'Hóa đơn đã được thanh toán trước đó', 16, 1);
            RETURN;
        END
        
        -- Lấy thông tin phiếu đặt sân (nếu có)
        DECLARE @MaPhieuDat CHAR(10);
        DECLARE @MaPhieuThue CHAR(10);
        DECLARE @TrangThaiPhieuHienTai NVARCHAR(20);
        DECLARE @paystatus bit;
        
        SELECT 
            @MaPhieuDat = MaPhieuDat,
            @MaPhieuThue = MaPhieuThue
        FROM HoaDon 
        WHERE MaHoaDon = @MaHoaDon;
        
        
            -- Cập nhật trạng thái hóa đơn
        UPDATE HoaDon
        SET TrangThaiThanhToan = N'Đã thanh toán',
            HinhThucThanhToan = @HinhThucThanhToan,
            MaNhanVien = @MaNhanVien
        WHERE MaHoaDon = @MaHoaDon;
        
       
        if @HinhThucThanhToan = N'Ví điện tử' 
        --Giả sử kết quả của thanh toán ví điện tử bị lỗi
        BEGIN
            WAITFOR DELAY '00:00:10';
            SET @paystatus = 0;
        END
        
        if @paystatus = 0
        BEGIN
            ROLLBACK;
            RAISERROR(N'Thanh toán thất bại', 16, 1);
            RETURN;
        END

        -- Xử lý phiếu đặt sân (nếu có)
        IF @MaPhieuDat IS NOT NULL
        BEGIN
            -- Lấy trạng thái hiện tại của phiếu đặt sân
            SELECT @TrangThaiPhieuHienTai = TrangThaiPhieu
            FROM PhieuDatSan
            WHERE MaPhieuDat = @MaPhieuDat;
            
            -- Trường hợp 1: Thanh toán ban đầu (Chờ xác nhận -> Đã xác nhận)
            -- Trường hợp 2: Thanh toán khi có dịch vụ phát sinh (Chờ thanh toán -> Hoàn thành)
            IF @TrangThaiPhieuHienTai = N'Chờ xác nhận'
            BEGIN
                -- Thanh toán ban đầu
                UPDATE PhieuDatSan
                SET TrangThaiPhieu = N'Đã xác nhận'
                WHERE MaPhieuDat = @MaPhieuDat;
                
                -- Cập nhật tất cả chi tiết phiếu đặt sân thành đã thanh toán
                UPDATE ChiTietPhieuDatSan
                SET TrangThaiThanhToan = 1
                WHERE MaPhieuDat = @MaPhieuDat;
            END
            ELSE IF @TrangThaiPhieuHienTai = N'Chờ thanh toán'
            BEGIN
                -- Thanh toán khi có dịch vụ phát sinh
                UPDATE PhieuDatSan
                SET TrangThaiPhieu = N'Hoàn thành'
                WHERE MaPhieuDat = @MaPhieuDat;
                
                -- Cập nhật chi tiết phiếu đặt sân thành đã thanh toán
                UPDATE ChiTietPhieuDatSan
                SET TrangThaiThanhToan = 1
                WHERE MaPhieuDat = @MaPhieuDat;
            END
        END
        
        -- Cập nhật trạng thái phiếu thuê tài sản (nếu có)
        IF @MaPhieuThue IS NOT NULL
        BEGIN
            UPDATE PhieuThueTaiSan
            SET TrangThai = N'Hoàn thành'
            WHERE MaPhieuThue = @MaPhieuThue;
        END
        
        COMMIT TRANSACTION;
        
        -- Trả về thông tin hóa đơn đã cập nhật
        SELECT 
            MaHoaDon,
            TrangThaiThanhToan,
            HinhThucThanhToan,
            NgayXuat,
            TongThanhToan
        FROM HoaDon
        WHERE MaHoaDon = @MaHoaDon;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT N'Đã tạo thành công các stored procedures cho module thu ngân!';
GO
