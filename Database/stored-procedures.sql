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

CREATE OR ALTER PROCEDURE sp_LeTan_CheckIn
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
            N'Tại quầy', N'Chờ xác nhận', @MaKhachHang, @MaNhanVien, @MaSan
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
        WAITFOR DELAY '00:00:05';

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
go

CREATE OR ALTER PROCEDURE sp_TaoHoaDon
    @MaPhieuDat CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Lấy thông tin & Validate
        DECLARE @TrangThaiPhieu NVARCHAR(20);
        DECLARE @MaKhachHang CHAR(10);
        DECLARE @MaSan CHAR(10);
        DECLARE @MaLoaiSan CHAR(10);
        DECLARE @NgayNhanSan DATE;
        DECLARE @GioBatDau TIME;
        DECLARE @GioKetThuc TIME;

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

        IF @TrangThaiPhieu NOT IN (N'Chờ xác nhận', N'Đang sử dụng')
        BEGIN
            RAISERROR(N'Trạng thái phiếu không hợp lệ (Phải là Chờ xác nhận hoặc Đang sử dụng).', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. KHỞI TẠO BIẾN
        DECLARE @TongTienSan INT = 0;
        DECLARE @TongTienDichVu INT = 0;
        DECLARE @TongTienGiamGia INT = 0;
        DECLARE @TongThanhToan INT = 0;

        -- 3. TÍNH TIỀN DỊCH VỤ (Chỉ tính các món CHƯA THANH TOÁN)
        SELECT @TongTienDichVu = ISNULL(SUM(ThanhTien), 0)
        FROM ChiTietPhieuDatSan
        WHERE MaPhieuDat = @MaPhieuDat AND TrangThaiThanhToan = 0;

        -- =========================================================================
        -- LOGIC GIAI ĐOẠN 1: KHÁCH ĐẶT SÂN (Trạng thái: Chờ xác nhận)
        -- =========================================================================
        IF @TrangThaiPhieu = N'Chờ xác nhận'
        BEGIN
            -- 1. Tính tiền sân
            DECLARE @SoPhut INT = DATEDIFF(MINUTE, @GioBatDau, @GioKetThuc);
            DECLARE @GiaGoc INT, @DonViTinhPhut INT;
            SELECT @GiaGoc = GiaGoc, @DonViTinhPhut = DonViTinhTheoPhut FROM LoaiSan WHERE MaLoaiSan = @MaLoaiSan;
            SET @TongTienSan = (@SoPhut / @DonViTinhPhut) * @GiaGoc;

            -- 2. Phụ thu Cuối tuần
            IF DATEPART(dw, @NgayNhanSan) IN (1, 7)
            BEGIN
                DECLARE @PhuThuCuoiTuan INT = 0;
                SELECT @PhuThuCuoiTuan = ISNULL(GiaTang, 0) FROM BangGiaTangCuoiTuan WHERE MaLoaiSan = @MaLoaiSan;
                SET @TongTienSan += @PhuThuCuoiTuan;
            END

            -- 3. Phụ thu Ngày lễ
            DECLARE @PhuThuLe INT = 0;
            SELECT @PhuThuLe = ISNULL(GiaTang, 0) FROM BangGiaTangNgayLe WHERE MaLoaiSan = @MaLoaiSan AND MaNgayLe = @NgayNhanSan;
            SET @TongTienSan += @PhuThuLe;

            -- 4. Phụ thu Khung giờ
            DECLARE @PhuThuKhungGio INT = 0;
            SELECT @PhuThuKhungGio = ISNULL(SUM(bg.GiaTang), 0)
            FROM BangGiaTangKhungGio bg
            JOIN KhungGio kg ON bg.MaKhungGio = kg.MaKhungGio
            WHERE bg.MaLoaiSan = @MaLoaiSan AND ((@GioBatDau < kg.GioKetThuc) AND (@GioKetThuc > kg.GioBatDau));
            SET @TongTienSan += @PhuThuKhungGio;

            -- 5. Giảm giá
            DECLARE @PhanTramGiam INT = 0;
            SELECT TOP 1 @PhanTramGiam = U.PhanTramGiamGia
            FROM ApDung AD JOIN UuDai U ON AD.MaUuDai = U.MaUuDai
            WHERE AD.MaKhachHang = @MaKhachHang AND AD.TrangThai = 1 
              AND GETDATE() BETWEEN AD.NgayBatDau AND AD.NgayKetThuc
            ORDER BY U.PhanTramGiamGia DESC;
            SET @TongTienGiamGia = (@TongTienSan * @PhanTramGiam) / 100;
            
            -- Tổng kết
            SET @TongThanhToan = (@TongTienSan + @TongTienDichVu) - @TongTienGiamGia;
            IF @TongThanhToan < 0 SET @TongThanhToan = 0;

            -- Tạo hóa đơn cọc/thanh toán trước
            INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat)
            VALUES (GETDATE(), @TongTienSan, @TongTienDichVu, @TongTienGiamGia, @TongThanhToan, N'Chưa thanh toán', NULL, @MaPhieuDat);
        END

        -- =========================================================================
        -- LOGIC GIAI ĐOẠN 2: CHECKOUT (Trạng thái: Đang sử dụng)
        -- =========================================================================
        ELSE IF @TrangThaiPhieu = N'Đang sử dụng'
        BEGIN
            -- Ở giai đoạn này, tiền sân = 0 (đã trả trước). Chỉ quan tâm dịch vụ phát sinh.
            SET @TongTienSan = 0;
            SET @TongTienGiamGia = 0;
            SET @TongThanhToan = @TongTienDichVu; -- Tổng tiền dịch vụ chưa thanh toán

            -- >>> LOGIC QUAN TRỌNG: KIỂM TRA CÓ PHÁT SINH KHÔNG <<<
            
            IF @TongThanhToan > 0
            BEGIN
                -- TRƯỜNG HỢP A: CÓ PHÁT SINH TIỀN -> TẠO HÓA ĐƠN
                INSERT INTO HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat)
                VALUES (GETDATE(), 0, @TongTienDichVu, 0, @TongThanhToan, N'Chưa thanh toán', NULL, @MaPhieuDat);

                -- Chuyển sang chờ thanh toán để thu ngân thu tiền
                UPDATE PhieuDatSan SET TrangThaiPhieu = N'Chờ thanh toán' WHERE MaPhieuDat = @MaPhieuDat;
            END
            ELSE
            BEGIN
                -- TRƯỜNG HỢP B: KHÔNG PHÁT SINH (HOẶC = 0 ĐỒNG) -> HOÀN THÀNH LUÔN
                -- 1. Cập nhật phiếu thành Hoàn thành
                UPDATE PhieuDatSan 
                SET TrangThaiPhieu = N'Hoàn thành'
                WHERE MaPhieuDat = @MaPhieuDat;

                -- 2. Cập nhật trạng thái thanh toán cho các dịch vụ (ví dụ các món giá 0 đồng, khuyến mãi)
                UPDATE ChiTietPhieuDatSan 
                SET TrangThaiThanhToan = 1 
                WHERE MaPhieuDat = @MaPhieuDat AND TrangThaiThanhToan = 0;
                
                -- 3. Cập nhật trạng thái Sân về Trống
                UPDATE San SET TinhTrang = N'Trống' WHERE MaSan = @MaSan;
            END
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO


-- 1. Lấy danh sách hóa đơn
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

-- 2. Lấy chi tiết hóa đơn
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

-- 3. Xử lý thanh toán
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

create or alter function F_ThongKeSoLuong ()
returns @statistics table (
	TenThongKe nvarchar(50),
	ThongSo int
)
as
begin
	declare @thongkesan int
	select @thongkesan = count(MaPhieuDat)
	from PhieuDatSan
	insert into @statistics values (N'San_total', @thongkesan)

	declare @thongkedv int
	select @thongkedv = count(MaChiTietPDS)
	from ChiTietPhieuDatSan
	insert into @statistics values (N'DichVu_total', @thongkedv)

	declare @thongkets int
	select @thongkets = count(MaPhieuThue)
	from PhieuThueTaiSan
	insert into @statistics values (N'TaiSan_total', @thongkets)

	declare @huysan int
	select @huysan = count(p.MaPhieuDat)
	from PhieuDatSan p
	where p.TrangThaiPhieu = N'Đã hủy'
	insert into @statistics values (N'San_cancel', @huysan)

	return
end
go

create or alter function F_DanhSachGiaLoaiSan ()
returns @dsLoaiSan table (
	MaLoaiSan varchar(10),
    TenLoaiSan nvarchar(50),
	DonViTinhTheoPhut int,
	GiaGoc int,
	MoTa nvarchar(255)
)
as
begin
	insert into @dsLoaiSan
		select distinct ls.MaLoaiSan, ls.TenLoaiSan, ls.DonViTinhTheoPhut, ls.GiaGoc, ls.MoTa
		from LoaiSan ls
	return
end
go


-- Dirty read (Tranh chấp No8)
--T2: NVQL xem doanh thu để lập báo cáo doanh thu hiện tại
create or alter proc sp_QL_DoanhThuNam
	@nam int,
	@output int output
as
begin
	set transaction isolation level read uncommitted
	begin tran
		-- Lấy thống kê
		declare @doanhthu int
		select @doanhthu = sum(hd.TongThanhToan)
		from HoaDon hd
		where year(hd.NgayXuat) = @nam
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
	commit tran
	set @output = isnull(@doanhthu, 0)
	set transaction isolation level read committed
end
go

create or alter proc sp_QL_DoanhThuNamThang
	@nam int,
	@thang int,
	@output int output
as
begin
	declare @doanhthu int
	select @doanhthu = sum(hd.TongThanhToan)
	from HoaDon hd
	where year(hd.NgayXuat) = @nam
		and month(hd.NgayXuat) = @thang
		and hd.TrangThaiThanhToan = N'Đã thanh toán'
	set @output = isnull(@doanhthu, 0)
end
go

create or alter proc sp_QL_DoanhThuNamThangNgay
	@nam int,
	@thang int,
	@ngay int,
	@output int output
as
begin
	declare @doanhthu int
	select @doanhthu = sum(hd.TongThanhToan)
	from HoaDon hd
	where year(hd.NgayXuat) = @nam
		and month(hd.NgayXuat) = @thang
		and day(hd.NgayXuat) = @ngay
		and hd.TrangThaiThanhToan = N'Đã thanh toán'
	set @output = isnull(@doanhthu, 0)
end
go

-- Phantom (Xem chi tiết hóa đơn giai đoạn 1 và 2 của quản lý)
create or alter proc sp_ChiTietThongKeDoanhThu
	@macoso char(10),
	@nam int
as
begin
	set transaction isolation level repeatable read
	begin tran
		SELECT COUNT(MaHoaDon) as SoHoaDon,  SUM (TongThanhToan) as TongDoanhThu
		FROM HoaDon hd
		JOIN NhanVien nv on nv.MaNhanVien = hd.MaNhanVien
		WHERE MaCoSo = 'CS01' 
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
			and year(hd.NgayXuat) = @nam

		WAITFOR DELAY '00:00:05'

		SELECT hd.MaHoaDon, hd.TongThanhToan, hd.HinhThucThanhToan
		FROM HoaDon hd
		JOIN NhanVien nv on nv.MaNhanVien = hd.MaNhanVien
		WHERE MaCoSo = 'CS01' 
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
			and year(hd.NgayXuat) = @nam
	commit tran
	set transaction isolation level read committed
end
go

-- Thống kê phiếu hủy (Minh)
create or alter proc sp_ChiTietThongKePhieuHuy
	@nam int
as
begin
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	begin tran
		--B1: Đếm số phiếu huỷ 
		SELECT COUNT(*) AS SoLuong
		FROM PhieuDatSan
		WHERE year(NgayNhanSan) = @nam
			AND TrangThaiPhieu = N'Đã hủy'

		waitfor delay '00:00:05'

		select p.MaPhieuDat, p.NgayDat, p.NgayNhanSan, p.HinhThucDat
		from PhieuDatSan p
		where year(p.NgayNhanSan) = @nam
			and TrangThaiPhieu = N'Đã hủy'
	commit tran
end
go

-- Đổi giá sân, dịch vụ
create or alter proc sp_CapNhatGiaSan
	@maloaisan char(10),
	@giamoi int
as
begin
	update LoaiSan set GiaGoc = @giamoi where MaLoaiSan = @maloaisan
end
go

create or alter proc sp_CapNhatGiaDV
	@madv char(10),
	@giamoi int
as
begin
	update DichVu set DonGia = @giamoi where MaDichVu = @madv
end
go

create or alter proc sp_LayPhieuDatSan
as
begin
	select p.MaPhieuDat, kh.HoTen as NguoiDat, p.NgayDat, p.HinhThucDat, p.TrangThaiPhieu
	from PhieuDatSan p, KhachHang kh
	where p.MaKhachHang = kh.MaKhachHang
end
go

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
            N'Online', N'Chờ xác nhận', @MaKhachHang, @MaSan
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

        -- 3. Kiểm tra tồn kho tại chi nhánh và đọc số lượng hiện tại
        DECLARE @TonKhoHienTai INT;
        SELECT @TonKhoHienTai = SoLuong, @TrangThaiKhaDung = TrangThaiKhaDung
        FROM TonKho
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
        pds.TrangThaiPhieu,
        -- Aggregate Services
        (
            SELECT STRING_AGG(CONCAT(dv.TenDichVu, ' (x', ct.SoLuong, ')'), ', ') 
            FROM ChiTietPhieuDatSan ct
            JOIN DichVu dv ON ct.MaDichVu = dv.MaDichVu
            WHERE ct.MaPhieuDat = pds.MaPhieuDat
        ) AS DanhSachDichVu
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





