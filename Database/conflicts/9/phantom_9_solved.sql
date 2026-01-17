CREATE OR ALTER PROCEDURE sp_HuyLichDatSan
    @MaPhieuDat CHAR(10),
    @LyDoHuy NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra phiếu đặt có tồn tại không
        DECLARE @TrangThaiHienTai NVARCHAR(20);
        DECLARE @NgayNhanSan DATE;
        DECLARE @GioBatDau TIME;
        
        SELECT @TrangThaiHienTai = TrangThaiPhieu,
               @NgayNhanSan = NgayNhanSan,
               @GioBatDau = GioBatDau
        FROM PhieuDatSan
        WHERE MaPhieuDat = @MaPhieuDat;

        IF @TrangThaiHienTai IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy phiếu đặt sân!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra trạng thái có được phép hủy không
        IF @TrangThaiHienTai IN (N'Đã hủy', N'Hoàn thành', N'Vắng mặt')
        BEGIN
            RAISERROR(N'Phiếu đặt này không thể hủy!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Kiểm tra thời gian hủy (có thể thêm logic kiểm tra thời gian hủy tối thiểu)
        DECLARE @NgayGioHienTai DATETIME = GETDATE();
        DECLARE @NgayGioNhanSan DATETIME = CAST(@NgayNhanSan AS DATETIME) + CAST(@GioBatDau AS DATETIME);
        
        -- Ví dụ: không cho phép hủy nếu còn dưới 2 tiếng
        IF DATEDIFF(HOUR, @NgayGioHienTai, @NgayGioNhanSan) < 2
        BEGIN
            RAISERROR(N'Không thể hủy lịch đặt trong vòng 2 giờ trước giờ nhận sân!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Cập nhật trạng thái phiếu đặt
        UPDATE PhieuDatSan
        SET TrangThaiPhieu = N'Đã hủy'
        WHERE MaPhieuDat = @MaPhieuDat;

        -- Hoàn trả dịch vụ vào tồn kho (nếu có)
        UPDATE tk
        SET tk.SoLuong = tk.SoLuong + ct.SoLuong
        FROM TonKho tk
        INNER JOIN ChiTietPhieuDatSan ct ON tk.MaDichVu = ct.MaDichVu
        INNER JOIN PhieuDatSan pds ON ct.MaPhieuDat = pds.MaPhieuDat
        INNER JOIN San s ON pds.MaSan = s.MaSan
        WHERE ct.MaPhieuDat = @MaPhieuDat
          AND tk.MaCoSo = s.MaCoSo
          AND ct.MaDichVu IS NOT NULL;

        -- Ghi lại lịch sử thay đổi (nếu có bảng LichSuThayDoi)
        IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'LichSuThayDoi')
        BEGIN
            INSERT INTO LichSuThayDoi (MaPhieuDat, ThoiDiemThayDoi, LoaiThayDoi, SoTienPhat, LyDo, SoTienHoanTra)
            VALUES (@MaPhieuDat, GETDATE(), N'Hủy lịch đặt', 0, @LyDoHuy, 0);
        END

        COMMIT TRANSACTION;
        
        SELECT 1 AS Success, N'Hủy lịch đặt thành công!' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        SELECT 0 AS Success, @ErrorMessage AS Message;
    END CATCH
END;
GO

CREATE OR ALTER PROC sp_ChiTietThongKePhieuHuy
    @nam INT
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
    BEGIN TRAN
        --B1: Đếm số phiếu huỷ 
        SELECT COUNT(*) AS SoLuong
        FROM PhieuDatSan
        WHERE YEAR(NgayNhanSan) = @nam
            AND TrangThaiPhieu = N'Đã hủy'

        WAITFOR DELAY '00:00:05'

        SELECT p.MaPhieuDat, p.NgayDat, p.NgayNhanSan, p.HinhThucDat
        FROM PhieuDatSan p
        WHERE YEAR(p.NgayNhanSan) = @nam
            AND TrangThaiPhieu = N'Đã hủy'
    COMMIT TRAN
END