using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class PhieuDatSan
{
    public string MaPhieuDat { get; set; } = null!;

    public DateTime NgayDat { get; set; }

    public DateOnly NgayNhanSan { get; set; }

    public TimeOnly GioBatDau { get; set; }

    public TimeOnly GioKetThuc { get; set; }

    public string HinhThucDat { get; set; } = null!;

    public string TrangThaiPhieu { get; set; } = null!;

    public TimeOnly? ThoiGianCheckin { get; set; }

    public string MaKhachHang { get; set; } = null!;

    public string? MaNhanVien { get; set; }

    public string MaSan { get; set; } = null!;

    public virtual ICollection<ChiTietPhieuDatSan> ChiTietPhieuDatSans { get; set; } = new List<ChiTietPhieuDatSan>();

    public virtual ICollection<HoaDon> HoaDons { get; set; } = new List<HoaDon>();

    public virtual LichSuThayDoi? LichSuThayDoi { get; set; }

    public virtual KhachHang MaKhachHangNavigation { get; set; } = null!;

    public virtual NhanVien? MaNhanVienNavigation { get; set; }

    public virtual San MaSanNavigation { get; set; } = null!;
}
