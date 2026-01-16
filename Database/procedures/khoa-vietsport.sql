CREATE PROCEDURE SP_LayDanhSachChiNhanh
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MaCoSo, TenCoSo, DiaChi FROM CoSo
END
GO

CREATE PROCEDURE SP_LayDanhSachLoaiSan
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MaLoaiSan, TenLoaiSan, DonViTinhTheoPhut, GiaGoc, MoTa FROM LoaiSan
END
GO

CREATE PROCEDURE SP_LayDanhSachSan
    @MaCoSo CHAR(10),
    @MaLoaiSan CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MaSan, TenSan, TinhTrang, SucChua, MaCoSo, MaLoaiSan
    FROM San
    WHERE MaCoSo = @MaCoSo AND MaLoaiSan = @MaLoaiSan
END
GO

CREATE OR ALTER PROCEDURE sp_KhachHang_DatSanOnline
    @MaKhachHang CHAR(10),
    @MaSan CHAR(10),
    @NgayNhanSan DATE,
    @GioBatDau TIME,
    @GioKetThuc TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @MaPhieuDat CHAR(10);
        -- Tạo mã phiếu đặt tự động 
        DECLARE @MaxMaPhieuDat VARCHAR(10);
        DECLARE @NextNum INT;

        SELECT @MaxMaPhieuDat = MAX(MaPhieuDat) 
        FROM PhieuDatSan 
        WHERE MaPhieuDat LIKE 'PDS%';

        IF @MaxMaPhieuDat IS NULL
        BEGIN
            SET @MaPhieuDat = 'PDS0000001';
        END
        ELSE
        BEGIN
            -- Lấy phần số (bỏ 3 ký tự đầu 'PDS') và cộng 1
            SET @NextNum = CAST(SUBSTRING(@MaxMaPhieuDat, 4, 7) AS INT) + 1;
            -- Format lại thành chuỗi 7 chữ số (ví dụ: 1 -> '0000001')
            SET @MaPhieuDat = 'PDS' + RIGHT('0000000' + CAST(@NextNum AS VARCHAR(7)), 7);
        END

        -- 1. Kiểm tra lịch bảo trì trong tương lai (Dựa vào bảng BaoTri)
        -- Nếu sân đang hoặc sẽ bảo trì trong khoảng thời gian khách chọn
        IF EXISTS (
            SELECT 1 FROM BaoTri 
            WHERE MaSan = @MaSan 
              AND TrangThai = N'Đang bảo trì'
              AND (
                  (@NgayNhanSan >= CAST(NgayBaoTri AS DATE) 
                  AND (NgayHoanThanh IS NULL 
                  OR @NgayNhanSan <= CAST(NgayHoanThanh AS DATE)))
              )
        )
        BEGIN
            RAISERROR(N'Sân đang hoặc đã có lịch bảo trì vào ngày này!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Kiểm tra sân có ai đặt chưa 
        IF EXISTS (
            SELECT 1 FROM PhieuDatSan 
            WHERE MaSan = @MaSan 
              AND NgayNhanSan = @NgayNhanSan
              AND TrangThaiPhieu NOT IN (N'Đã hủy', N'Vắng mặt')
              AND (
                  (@GioBatDau >= GioBatDau AND @GioBatDau < GioKetThuc) OR
                  (@GioKetThuc > GioBatDau AND @GioKetThuc <= GioKetThuc) OR
                  (GioBatDau >= @GioBatDau AND GioBatDau < @GioKetThuc)
              )
        )
        BEGIN
            RAISERROR(N'Sân đã có người khác đặt trong khung giờ này!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Ghi nhận thông tin vào bảng PhieuDatSan
        INSERT INTO PhieuDatSan (
            MaPhieuDat, NgayDat, NgayNhanSan, GioBatDau, GioKetThuc, 
            HinhThucDat, TrangThaiPhieu, MaKhachHang, MaSan
        )
        VALUES (
            @MaPhieuDat, GETDATE(), @NgayNhanSan, @GioBatDau, @GioKetThuc,
            N'Online', N'Chờ thanh toán', @MaKhachHang, @MaSan
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE SP_LayLichDatSan
    @NgayNhanSan DATE,
    @MaCoSo CHAR(10),
    @MaLoaiSan CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pds.MaPhieuDat,
        pds.GioBatDau,
        pds.GioKetThuc,
        pds.MaSan
    FROM PhieuDatSan pds
    INNER JOIN San s ON pds.MaSan = s.MaSan
    WHERE pds.NgayNhanSan = @NgayNhanSan
        AND s.MaCoSo = @MaCoSo
        AND s.MaLoaiSan = @MaLoaiSan
        AND pds.TrangThaiPhieu NOT IN (N'Đã hủy', N'Vắng mặt')
    ORDER BY pds.GioBatDau
END
GO

GO

CREATE OR ALTER PROCEDURE sp_ThemDichVuVaoPhieuDat
    @MaPhieuDat CHAR(10),
    @MaDichVu CHAR(10),
    @SoLuong INT,
    @MaNhanVien CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @MaChiTietPDS CHAR(10);
        DECLARE @MaCoSo CHAR(10);
        DECLARE @DonGia INT;
        DECLARE @ThanhTien INT;
        DECLARE @SoLuongTonKho INT;
        DECLARE @TrangThaiKhaDung BIT;

        -- Tạo mã chi tiết phiếu đặt sân tự động
        DECLARE @MaxMaChiTietPDS VARCHAR(10);
        DECLARE @NextNum INT;

        SELECT @MaxMaChiTietPDS = MAX(MaChiTietPDS) 
        FROM ChiTietPhieuDatSan 
        WHERE MaChiTietPDS LIKE 'CTPDS%';

        IF @MaxMaChiTietPDS IS NULL
        BEGIN
            SET @MaChiTietPDS = 'CTPDS00001';
        END
        ELSE
        BEGIN
            SET @NextNum = CAST(SUBSTRING(@MaxMaChiTietPDS, 6, 5) AS INT) + 1;
            SET @MaChiTietPDS = 'CTPDS' + RIGHT('00000' + CAST(@NextNum AS VARCHAR(5)), 5);
        END

        -- 1. Lấy thông tin chi nhánh từ phiếu đặt sân
        SELECT @MaCoSo = s.MaCoSo
        FROM PhieuDatSan pds
        INNER JOIN San s ON pds.MaSan = s.MaSan
        WHERE pds.MaPhieuDat = @MaPhieuDat;

        IF @MaCoSo IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy thông tin phiếu đặt sân!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Lấy đơn giá dịch vụ
        SELECT @DonGia = DonGia
        FROM DichVu
        WHERE MaDichVu = @MaDichVu;

        IF @DonGia IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy thông tin dịch vụ!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Kiểm tra tồn kho tại chi nhánh
        SELECT @SoLuongTonKho = SoLuong, @TrangThaiKhaDung = TrangThaiKhaDung
        FROM TonKho
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo;

        IF @SoLuongTonKho IS NULL
        BEGIN
            RAISERROR(N'Dịch vụ không có trong kho của chi nhánh này!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @TrangThaiKhaDung = 0
        BEGIN
            RAISERROR(N'Dịch vụ hiện không khả dụng!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @SoLuongTonKho < @SoLuong
        BEGIN
            RAISERROR(N'Số lượng trong kho không đủ! Chỉ còn %d sản phẩm.', 16, 1, @SoLuongTonKho);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Tính thành tiền
        SET @ThanhTien = @SoLuong * @DonGia;

        -- 5. Thêm chi tiết phiếu đặt sân
        INSERT INTO ChiTietPhieuDatSan (
            MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, 
            MaPhieuDat, MaNhanVien, MaDichVu, TrangThaiThanhToan
        )
        VALUES (
            @MaChiTietPDS, GETDATE(), @SoLuong, @ThanhTien,
            @MaPhieuDat, @MaNhanVien, @MaDichVu, 0
        );

        -- 6. Cập nhật tồn kho
        UPDATE TonKho
        SET SoLuong = SoLuong - @SoLuong
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo;

        COMMIT TRANSACTION;
        
        -- Trả về mã chi tiết vừa tạo
        SELECT @MaChiTietPDS AS MaChiTietPDS;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_LayLichDatCuaToi
    @MaKhachHang CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pds.MaPhieuDat,
        pds.NgayDat,
        pds.NgayNhanSan,
        pds.GioBatDau,
        pds.GioKetThuc,
        s.TenSan,
        ls.TenLoaiSan,
        cs.TenCoSo,
        pds.TrangThaiPhieu
    FROM PhieuDatSan pds
    INNER JOIN San s ON pds.MaSan = s.MaSan
    INNER JOIN LoaiSan ls ON s.MaLoaiSan = ls.MaLoaiSan
    INNER JOIN CoSo cs ON s.MaCoSo = cs.MaCoSo
    WHERE pds.MaKhachHang = @MaKhachHang
    ORDER BY pds.NgayDat DESC
END
GO

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


CREATE OR ALTER PROCEDURE sp_LayDanhSachUuDai
AS
BEGIN
    SELECT MaUuDai, LoaiUuDai, PhanTramGiamGia
    FROM UuDai
END
GO
