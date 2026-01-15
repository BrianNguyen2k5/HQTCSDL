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

CREATE PROCEDURE sp_LeTan_CheckIn
    @MaPhieuDat CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra phiếu đặt có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PhieuDatSan WHERE MaPhieuDat = @MaPhieuDat)
        BEGIN
            RAISERROR(N'Mã phiếu đặt không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Kiểm tra trạng thái phiếu
        DECLARE @TrangThaiHienTai NVARCHAR(20);
        DECLARE @MaSan CHAR(10);
        DECLARE @NgayNhanSan DATE;

        SELECT @TrangThaiHienTai = TrangThaiPhieu, 
               @MaSan = MaSan,
               @NgayNhanSan = NgayNhanSan
        FROM PhieuDatSan 
        WHERE MaPhieuDat = @MaPhieuDat;

        IF @TrangThaiHienTai NOT IN (N'Đã xác nhận')
        BEGIN
            RAISERROR(N'Trạng thái phiếu không hợp lệ để Check-in (Phải là Đã xác nhận).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Kiểm tra ngày nhận sân (Phải là ngày hiện tại)
        IF CAST(@NgayNhanSan AS DATE) <> CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR(N'Ngày nhận sân không phải là hôm nay.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Cập nhật thông tin phiếu đặt
        UPDATE PhieuDatSan
        SET ThoiGianCheckin = CAST(GETDATE() AS TIME),
            TrangThaiPhieu = N'Đang sử dụng'
        WHERE MaPhieuDat = @MaPhieuDat;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
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

CREATE PROCEDURE sp_LeTan_ThemDichVu
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

        -- 2. Lấy thông tin phiếu đặt và Cơ sở (để trừ kho đúng chỗ)
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

        -- 3. VALIDATION: Chỉ được thêm khi trạng thái là 'Chờ xác nhận' hoặc 'Đang sử dụng'
        IF @TrangThaiPhieu NOT IN (N'Chờ xác nhận', N'Đang sử dụng')
        BEGIN
            RAISERROR(N'Chỉ được thêm dịch vụ khi phiếu đang ở trạng thái Chờ xác nhận hoặc Đang sử dụng.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Lấy đơn giá dịch vụ
        DECLARE @DonGia INT;
        SELECT @DonGia = DonGia FROM DichVu WHERE MaDichVu = @MaDichVu;

        IF @DonGia IS NULL
        BEGIN
            RAISERROR(N'Mã dịch vụ không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Kiểm tra Tồn Kho
        DECLARE @TonKhoHienTai INT;
        SELECT @TonKhoHienTai = SoLuong 
        FROM TonKho 
        WHERE MaDichVu = @MaDichVu AND MaCoSo = @MaCoSo AND TrangThaiKhaDung = 1;

        IF @TonKhoHienTai IS NULL OR @TonKhoHienTai < @SoLuong
        BEGIN
            RAISERROR(N'Số lượng trong kho không đủ hoặc dịch vụ không khả dụng tại cơ sở này.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 6. Sinh MaChiTietPDS theo format: CTPDS + 5 số (tổng 10 ký tự)
        -- Lấy mã lớn nhất hiện tại và tăng lên 1
        DECLARE @MaxNumber INT;
        DECLARE @NewMaChiTiet CHAR(10);
        
        SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(MaChiTietPDS, 5) AS INT)), 0)
        FROM ChiTietPhieuDatSan
        WHERE MaChiTietPDS LIKE 'CTPDS%';
        
        SET @MaxNumber = @MaxNumber + 1;
        SET @NewMaChiTiet = 'CTPDS' + RIGHT('00000' + CAST(@MaxNumber AS VARCHAR(5)), 5);

        -- 7. Thêm vào bảng ChiTietPhieuDatSan
        INSERT INTO ChiTietPhieuDatSan (
            MaChiTietPDS, 
            ThoiDiemTao, 
            SoLuong, 
            ThanhTien, 
            MaPhieuDat, 
            MaNhanVien, 
            MaDichVu, 
            MaHLV, -- Null vì đây là thêm dịch vụ, không phải HLV
            TrangThaiThanhToan
        )
        VALUES (
            @NewMaChiTiet,
            GETDATE(),
            @SoLuong,
            @SoLuong * @DonGia, -- Thành tiền
            @MaPhieuDat,
            @MaNhanVien,
            @MaDichVu,
            NULL, 
            0 -- Mặc định chưa thanh toán (sẽ thanh toán khi xuất hóa đơn tổng)
        );

        -- 8. Trừ Tồn Kho
        UPDATE TonKho
        SET SoLuong = SoLuong - @SoLuong
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

CREATE OR ALTER PROCEDURE sp_TaoHoaDon
    @MaPhieuDat CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Khai báo các biến để tính tiền
        DECLARE @TongTienSan INT = 0;
        DECLARE @TongTienDichVu INT = 0;
        DECLARE @TongTienGiamGia INT = 0;
        DECLARE @TongThanhToan INT = 0;
        
        DECLARE @TrangThaiPhieu NVARCHAR(20);
        DECLARE @MaKhachHang CHAR(10);
        DECLARE @MaSan CHAR(10);
        DECLARE @MaLoaiSan CHAR(10);
        DECLARE @NgayNhanSan DATE;
        DECLARE @GioBatDau TIME;
        DECLARE @GioKetThuc TIME;

        -- 2. Lấy thông tin cơ bản của phiếu đặt
        SELECT @TrangThaiPhieu = P.TrangThaiPhieu,
               @MaKhachHang = P.MaKhachHang,
               @MaSan = P.MaSan,
               @MaLoaiSan = S.MaLoaiSan,
               @NgayNhanSan = P.NgayNhanSan,
               @GioBatDau = P.GioBatDau,
               @GioKetThuc = P.GioKetThuc
        FROM PhieuDatSan P
        JOIN San S ON P.MaSan = S.MaSan
        WHERE P.MaPhieuDat = @MaPhieuDat;

        IF @TrangThaiPhieu IS NULL
        BEGIN
            RAISERROR(N'Phiếu đặt sân không tồn tại.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. TÍNH TIỀN DỊCH VỤ (Luôn tính dù trạng thái nào)
        -- Query từ ChiTietPhieuDatSan
        SELECT @TongTienDichVu = ISNULL(SUM(ThanhTien), 0)
        FROM ChiTietPhieuDatSan
        WHERE MaPhieuDat = @MaPhieuDat;

        -- 4. PHÂN NHÁNH LOGIC THEO TRẠNG THÁI
        
        ---------------------------------------------------------
        -- TRƯỜNG HỢP A: CHỜ XÁC NHẬN -> TÍNH TIỀN SÂN + PHỤ THU + GIẢM GIÁ
        ---------------------------------------------------------
        IF @TrangThaiPhieu = N'Chờ xác nhận'
        BEGIN
            -- A1. Tính tiền gốc theo thời gian đá
            DECLARE @SoPhut INT;
            DECLARE @GiaGoc INT;
            DECLARE @DonViTinhPhut INT;

            SET @SoPhut = DATEDIFF(MINUTE, @GioBatDau, @GioKetThuc);
            
            SELECT @GiaGoc = GiaGoc, @DonViTinhPhut = DonViTinhTheoPhut
            FROM LoaiSan WHERE MaLoaiSan = @MaLoaiSan;

            -- Công thức: (Số phút / Đơn vị tính) * Giá gốc
            SET @TongTienSan = (@SoPhut / @DonViTinhPhut) * @GiaGoc;

            -- A2. Tính phụ thu Cuối Tuần (Thứ 7, CN)
            -- DATEPART(dw, Date): 1 là CN, 7 là Thứ 7 
            IF DATEPART(dw, @NgayNhanSan) IN (1, 7)
            BEGIN
                DECLARE @PhuThuCuoiTuan INT = 0;
                SELECT @PhuThuCuoiTuan = ISNULL(GiaTang, 0)
                FROM BangGiaTangCuoiTuan
                WHERE MaLoaiSan = @MaLoaiSan;
                
                SET @TongTienSan = @TongTienSan + @PhuThuCuoiTuan;
            END

            -- A3. Tính phụ thu Ngày Lễ
            DECLARE @PhuThuLe INT = 0;
            SELECT @PhuThuLe = ISNULL(GiaTang, 0)
            FROM BangGiaTangNgayLe
            WHERE MaLoaiSan = @MaLoaiSan AND MaNgayLe = @NgayNhanSan;

            SET @TongTienSan = @TongTienSan + @PhuThuLe;

            -- A4. Tính phụ thu Khung Giờ (Buổi tối, giờ vàng...)
            -- Logic: Cộng dồn giá tăng nếu khung giờ đặt có giao thoa với khung giờ tăng giá
            DECLARE @PhuThuKhungGio INT = 0;
            
            SELECT @PhuThuKhungGio = ISNULL(SUM(bg.GiaTang), 0)
            FROM BangGiaTangKhungGio bg
            JOIN KhungGio kg ON bg.MaKhungGio = kg.MaKhungGio
            WHERE bg.MaLoaiSan = @MaLoaiSan
            AND (
                (@GioBatDau < kg.GioKetThuc) AND (@GioKetThuc > kg.GioBatDau)
            );

            SET @TongTienSan = @TongTienSan + @PhuThuKhungGio;

            -- A5. Tính Giảm Giá (Nếu có áp dụng ưu đãi)
            DECLARE @PhanTramGiam INT = 0;
            
            -- Lấy ưu đãi đang áp dụng và còn hạn
            SELECT TOP 1 @PhanTramGiam = U.PhanTramGiamGia
            FROM ApDung AD
            JOIN UuDai U ON AD.MaUuDai = U.MaUuDai
            WHERE AD.MaKhachHang = @MaKhachHang
              AND AD.TrangThai = 1
              AND GETDATE() BETWEEN AD.NgayBatDau AND AD.NgayKetThuc
            ORDER BY U.PhanTramGiamGia DESC; -- Lấy ưu đãi cao nhất nếu có nhiều

            -- Tính tiền giảm giá (Áp dụng trên tổng tiền sân)
            SET @TongTienGiamGia = (@TongTienSan * @PhanTramGiam) / 100;
        END
        
        ---------------------------------------------------------
        -- TRƯỜNG HỢP B: CHỜ THANH TOÁN -> CHỈ TÍNH DỊCH VỤ (TIỀN SÂN = 0)
        ---------------------------------------------------------
        ELSE IF @TrangThaiPhieu = N'Chờ thanh toán'
        BEGIN
            -- Theo yêu cầu: Nếu chờ thanh toán thì chỉ query chi tiết (dịch vụ)
            -- Giả định tiền sân đã được xử lý ở đơn khác hoặc cọc, ở đây set = 0
            SET @TongTienSan = 0;
            SET @TongTienGiamGia = 0;
            -- @TongTienDichVu đã tính ở bước 3
        END
        ELSE
        BEGIN
            RAISERROR(N'Trạng thái phiếu không hợp lệ để xuất hóa đơn (Phải là Chờ xác nhận, hoặc Chờ thanh toán).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 5. Tổng kết tiền
        SET @TongThanhToan = (@TongTienSan + @TongTienDichVu) - @TongTienGiamGia;
        
        IF @TongThanhToan < 0 SET @TongThanhToan = 0;

        -- 6. Tạo Hóa Đơn
        INSERT INTO HoaDon (
            NgayXuat, 
            TongTienSan, 
            TongTienDichVu, 
            TongTienGiamGia, 
            TongThanhToan, 
            HinhThucThanhToan, 
            TrangThaiThanhToan, 
            MaNhanVien, 
            MaPhieuDat, 
            MaPhieuThue
        )
        VALUES (
            GETDATE(),
            @TongTienSan,
            @TongTienDichVu,
            @TongTienGiamGia,
            @TongThanhToan,
            NULL,
            N'Chờ thanh toán',
            NULL,
            @MaPhieuDat,
            NULL -- Ở đây chỉ xử lý phiếu đặt sân
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

CREATE OR ALTER PROCEDURE sp_CapNhatHoaDon
    @MaPhieuDat CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra hóa đơn tồn tại và chưa thanh toán
        DECLARE @MaHoaDon INT;
        DECLARE @TongTienSan INT;
        DECLARE @TongTienGiamGia INT;
        
        -- Lấy hóa đơn mới nhất của phiếu đặt này 
        SELECT TOP 1 
               @MaHoaDon = MaHoaDon, 
               @TongTienSan = TongTienSan, 
               @TongTienGiamGia = TongTienGiamGia
        FROM HoaDon
        WHERE MaPhieuDat = @MaPhieuDat 
          AND TrangThaiThanhToan = N'Chờ thanh toán'
        ORDER BY MaHoaDon DESC;

        IF @MaHoaDon IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy hóa đơn chờ thanh toán cho phiếu đặt này.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Tính lại tổng tiền dịch vụ từ chi tiết (bao gồm cả dịch vụ vừa thêm)
        DECLARE @TongTienDichVuMoi INT = 0;
        
        SELECT @TongTienDichVuMoi = ISNULL(SUM(ThanhTien), 0)
        FROM ChiTietPhieuDatSan
        WHERE MaPhieuDat = @MaPhieuDat;

        -- 3. Tính lại tổng thanh toán
        DECLARE @TongThanhToanMoi INT;
        SET @TongThanhToanMoi = (@TongTienSan + @TongTienDichVuMoi) - @TongTienGiamGia;
        
        IF @TongThanhToanMoi < 0 SET @TongThanhToanMoi = 0;

        -- 4. Cập nhật hóa đơn
        UPDATE HoaDon
        SET TongTienDichVu = @TongTienDichVuMoi,
            TongThanhToan = @TongThanhToanMoi
        WHERE MaHoaDon = @MaHoaDon;

        COMMIT TRANSACTION;
        PRINT N'Cập nhật hóa đơn thành công!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;