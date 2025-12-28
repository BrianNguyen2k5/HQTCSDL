CREATE OR ALTER PROCEDURE sp_TinhTienVaCapNhatHoaDon
(
    @MaHoaDon CHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @MaPhieuDat CHAR(10),
        @MaKhachHang CHAR(10),
        @MaLoaiSan CHAR(10),
        @NgayNhanSan DATE,
        @TongTienSan INT = 0,
        @TongTienDichVu INT = 0,
        @TongTienGiamGia INT = 0,
        @TongThanhToan INT = 0,
        @GiaGoc INT,
        @GiaTang INT = 0,
        @GiaTangToi INT = 0,
        @PhanTramGiam INT = 0;

    /* ===============================
       1. LẤY THÔNG TIN CƠ BẢN
       =============================== */
    SELECT 
        @MaPhieuDat = hd.MaPhieuDat,
        @MaKhachHang = pds.MaKhachHang,
        @NgayNhanSan = pds.NgayNhanSan,
        @MaLoaiSan = s.MaLoaiSan
    FROM HoaDon hd
    JOIN PhieuDatSan pds ON hd.MaPhieuDat = pds.MaPhieuDat
    JOIN San s ON pds.MaSan = s.MaSan
    WHERE hd.MaHoaDon = @MaHoaDon;

    /* ===============================
       2. GIÁ GỐC
       =============================== */
    SELECT @GiaGoc = GiaGoc
    FROM LoaiSan
    WHERE MaLoaiSan = @MaLoaiSan;

    SET @TongTienSan = @GiaGoc;

    /* ===============================
       3. PHỤ THU NGÀY LỄ / CUỐI TUẦN
       =============================== */
    IF EXISTS (SELECT 1 FROM NgayLe WHERE MaNgayLe = @NgayNhanSan)
    BEGIN
        SELECT @GiaTang = GiaTang
        FROM BangGiaTangNgayLe
        WHERE MaLoaiSan = @MaLoaiSan
          AND MaNgayLe = @NgayNhanSan;
    END
    ELSE IF DATENAME(WEEKDAY, @NgayNhanSan) IN (N'Saturday', N'Sunday')
    BEGIN
        SELECT @GiaTang = GiaTang
        FROM BangGiaTangCuoiTuan
        WHERE MaLoaiSan = @MaLoaiSan;
    END

    SET @TongTienSan += ISNULL(@GiaTang, 0);

    /* ===============================
       4. PHỤ THU KHUNG GIỜ TỐI
       =============================== */
    SELECT @GiaTangToi = ISNULL(SUM(bg.GiaTang), 0)
    FROM PhieuDatSan pds
    JOIN KhungGio kg 
        ON pds.GioBatDau >= kg.GioBatDau 
       AND pds.GioKetThuc <= kg.GioKetThuc
    JOIN BangGiaTangKhungGio bg 
        ON bg.MaKhungGio = kg.MaKhungGio
       AND bg.MaLoaiSan = @MaLoaiSan
    WHERE pds.MaPhieuDat = @MaPhieuDat;

    SET @TongTienSan += @GiaTangToi;

    /* ===============================
       5. TỔNG TIỀN DỊCH VỤ
       =============================== */
    SELECT 
        @TongTienDichVu = ISNULL(SUM(ThanhTien), 0)
    FROM ChiTietPhieuDatSan
    WHERE MaPhieuDat = @MaPhieuDat;

    /* ===============================
       6. TỔNG % GIẢM GIÁ
       =============================== */
    SELECT 
        @PhanTramGiam = ISNULL(SUM(ud.PhanTramGiamGia), 0)
    FROM ApDung ad
    JOIN UuDai ud ON ad.MaUuDai = ud.MaUuDai
    WHERE ad.MaKhachHang = @MaKhachHang
      AND ad.TrangThai = 1
      AND GETDATE() BETWEEN ad.NgayBatDau AND ad.NgayKetThuc;

    /* ===============================
       7. TÍNH GIẢM GIÁ & TỔNG THANH TOÁN
       =============================== */
    SET @TongTienGiamGia =
        (@TongTienSan + @TongTienDichVu) * @PhanTramGiam / 100;

    SET @TongThanhToan =
        @TongTienSan + @TongTienDichVu - @TongTienGiamGia;

    /* ===============================
       8. UPDATE HÓA ĐƠN
       =============================== */
    UPDATE HoaDon
    SET
        TongTienSan = @TongTienSan,
        TongTienDichVu = @TongTienDichVu,
        TongTienGiamGia = @TongTienGiamGia,
        TongThanhToan = @TongThanhToan
    WHERE MaHoaDon = @MaHoaDon;
END;
GO


CREATE OR ALTER PROCEDURE sp_TinhTienTatCaHoaDon
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaHoaDon CHAR(10);

    -- Cursor duyệt tất cả hóa đơn đặt sân
    DECLARE curHoaDon CURSOR FOR
    SELECT MaHoaDon
    FROM HoaDon
    WHERE MaPhieuDat IS NOT NULL;  -- chỉ hóa đơn đặt sân

    OPEN curHoaDon;
    FETCH NEXT FROM curHoaDon INTO @MaHoaDon;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sp_TinhTienVaCapNhatHoaDon @MaHoaDon;

        FETCH NEXT FROM curHoaDon INTO @MaHoaDon;
    END

    CLOSE curHoaDon;
    DEALLOCATE curHoaDon;
END;
GO
EXEC sp_TinhTienTatCaHoaDon;

select *
from HoaDon