using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class BaoTri
{
    public string MaNhanVien { get; set; } = null!;

    public string MaSan { get; set; } = null!;

    public DateTime NgayBaoTri { get; set; }

    public DateTime? NgayHoanThanh { get; set; }

    public string TrangThai { get; set; } = null!;

    public int? ChiPhi { get; set; }

    public string? MoTa { get; set; }

    public virtual NhanVien MaNhanVienNavigation { get; set; } = null!;

    public virtual San MaSanNavigation { get; set; } = null!;
}
