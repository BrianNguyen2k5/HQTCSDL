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