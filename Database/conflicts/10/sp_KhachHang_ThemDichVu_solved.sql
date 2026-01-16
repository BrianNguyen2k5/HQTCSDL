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

        -- 3. Kiểm tra tồn kho tại chi nhánh và đọc số lượng hiện tại
        DECLARE @TonKhoHienTai INT;
        SELECT @TonKhoHienTai = SoLuong, @TrangThaiKhaDung = TrangThaiKhaDung
        FROM TonKho WITH (UPDLOCK)
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo;

        IF @TonKhoHienTai IS NULL
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

        IF @TonKhoHienTai < @SoLuong
        BEGIN
            RAISERROR(N'Số lượng trong kho không đủ! Chỉ còn %d sản phẩm.', 16, 1, @TonKhoHienTai);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Tính toán tồn kho mới trên biến cục bộ (giống sp_LeTan_ThemDichVu)
        DECLARE @TonKhoMoi INT;
        SET @TonKhoMoi = @TonKhoHienTai - @SoLuong;

        -- 5. Tính thành tiền
        SET @ThanhTien = @SoLuong * @DonGia;

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

        -- 6. Thêm chi tiết phiếu đặt sân
        INSERT INTO ChiTietPhieuDatSan (
            MaChiTietPDS, ThoiDiemTao, SoLuong, ThanhTien, 
            MaPhieuDat, MaNhanVien, MaDichVu, TrangThaiThanhToan
        )
        VALUES (
            @MaChiTietPDS, GETDATE(), @SoLuong, @ThanhTien,
            @MaPhieuDat, @MaNhanVien, @MaDichVu, 0
        );

        -- 7. Cập nhật kho bằng giá trị đã tính toán (giống sp_LeTan_ThemDichVu)
        UPDATE TonKho
        SET SoLuong = @TonKhoMoi
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