USE VietSport
GO

CREATE PROCEDURE SP_LayDanhSachDichVu
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