using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class PhieuThueTaiSan
{
    public string MaPhieuThue { get; set; } = null!;

    public string MaKhachHang { get; set; } = null!;

    public string MaNhanVien { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<ChiTietPhieuThueTaiSan> ChiTietPhieuThueTaiSans { get; set; } = new List<ChiTietPhieuThueTaiSan>();

    public virtual ICollection<HoaDon> HoaDons { get; set; } = new List<HoaDon>();
}
