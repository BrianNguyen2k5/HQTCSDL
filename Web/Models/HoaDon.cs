using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class HoaDon
{
    public string MaHoaDon { get; set; } = null!;

    public DateTime NgayXuat { get; set; }

    public int TongTienSan { get; set; }

    public int TongTienDichVu { get; set; }

    public int TongTienGiamGia { get; set; }

    public int TongThanhToan { get; set; }

    public string? HinhThucThanhToan { get; set; }

    public string? TrangThaiThanhToan { get; set; }

    public string MaNhanVien { get; set; } = null!;

    public string MaPhieuDat { get; set; } = null!;

    public string? MaPhieuThue { get; set; }

    public virtual NhanVien MaNhanVienNavigation { get; set; } = null!;

    public virtual PhieuDatSan MaPhieuDatNavigation { get; set; } = null!;

    public virtual PhieuThueTaiSan? MaPhieuThueNavigation { get; set; }
}
