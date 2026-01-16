USE VietSport
GO

CREATE OR ALTER PROCEDURE SP_LayDanhSachDichVu
    @MaCoSo CHAR(10)
AS
BEGIN
    SELECT 
        dv.MaDichVu,
        dv.TenDichVu,
        dv.LoaiDichVu,
        dv.DonGia,
        dv.DonViTinh,
        ISNULL(tk.SoLuong, 0) AS SoLuongTonKho
    FROM DichVu dv
    LEFT JOIN TonKho tk ON dv.MaDichVu = tk.MaDichVu AND tk.MaCoSo = @MaCoSo
    ORDER BY dv.LoaiDichVu, dv.TenDichVu;
END
GO

CREATE OR ALTER PROCEDURE sp_LeTan_DatSanTrucTiep
    @MaKhachHang CHAR(10),
    @MaNhanVien CHAR(10),
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
            HinhThucDat, TrangThaiPhieu, MaKhachHang, MaNhanVien, MaSan
        )
        VALUES (
            @MaPhieuDat, GETDATE(), @NgayNhanSan, @GioBatDau, @GioKetThuc,
            N'Tại quầy', N'Chờ thanh toán', @MaKhachHang, @MaNhanVien, @MaSan
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

CREATE OR ALTER PROCEDURE sp_LeTan_ThemDichVu
    @MaPhieuDat CHAR(10),
    @MaDichVu CHAR(10),
    @SoLuong INT,
    @MaNhanVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra số lượng hợp lệ
        IF @SoLuong <= 0
        BEGIN
            RAISERROR(N'Số lượng dịch vụ phải lớn hơn 0.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Lấy thông tin phiếu đặt và Cơ sở
        DECLARE @TrangThaiPhieu NVARCHAR(20);
        DECLARE @MaSan CHAR(10);
        DECLARE @MaCoSo CHAR(10);

        SELECT @TrangThaiPhieu = PDS.TrangThaiPhieu, 
               @MaSan = PDS.MaSan,
               @MaCoSo = S.MaCoSo
        FROM PhieuDatSan PDS
        JOIN San S ON PDS.MaSan = S.MaSan
        WHERE PDS.MaPhieuDat = @MaPhieuDat;

        IF @TrangThaiPhieu IS NULL
        BEGIN
            RAISERROR(N'Phiếu đặt sân không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Kiểm tra trạng thái phiếu
        IF @TrangThaiPhieu NOT IN (N'Chờ xác nhận', N'Đang sử dụng')
        BEGIN
            RAISERROR(N'Trạng thái phiếu không hợp lệ để thêm dịch vụ.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Đọc số lượng tồn kho hiện tại (R-Lock được giải phóng ngay sau khi đọc ở mức Read Committed)
        DECLARE @TonKhoHienTai INT;
        SELECT @TonKhoHienTai = SoLuong 
        FROM TonKho 
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo AND TrangThaiKhaDung = 1;

        -- 5. Kiểm tra xem có đáp ứng được số lượng thuê không
        IF @TonKhoHienTai IS NULL OR @TonKhoHienTai < @SoLuong
        BEGIN
            RAISERROR(N'Số lượng trong kho không đủ hoặc dịch vụ không khả dụng.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- GIẢ LẬP TRỄ: Đây là lúc T2 sẽ nhảy vào đọc cùng giá trị @TonKhoHienTai
        WAITFOR DELAY '00:00:10';

        -- 6. Tính toán tồn kho mới trên biến cục bộ
        DECLARE @TonKhoMoi INT;
        SET @TonKhoMoi = @TonKhoHienTai - @SoLuong;

        -- 7. Lấy đơn giá dịch vụ
        DECLARE @DonGia INT;
        SELECT @DonGia = DonGia FROM DichVu WHERE MaDichVu = @MaDichVu;

        -- 8. Sinh MaChiTietPDS
        DECLARE @MaxNumber INT;
        DECLARE @NewMaChiTiet CHAR(10);
        SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(MaChiTietPDS, 5) AS INT)), 0) FROM ChiTietPhieuDatSan;
        SET @MaxNumber = @MaxNumber + 1;
        SET @NewMaChiTiet = 'CTPDS' + RIGHT('00000' + CAST(@MaxNumber AS VARCHAR(5)), 5);

        -- 9. Thêm vào bảng ChiTietPhieuDatSan
        INSERT INTO ChiTietPhieuDatSan (MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, MaPhieuDat, MaNhanVien, MaDichVu, TrangThaiThanhToan)
        VALUES (@NewMaChiTiet, GETDATE(), @SoLuong, @SoLuong * @DonGia, @MaPhieuDat, @MaNhanVien, @MaDichVu, 0);

        -- 10. Cập nhật kho bằng giá trị đã tính toán (Gây lỗi Lost Update)
        UPDATE TonKho
        SET SoLuong = @TonKhoMoi
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo;

        COMMIT TRANSACTION;
        PRINT N'Thêm dịch vụ thành công!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;