using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class DonNghiPhep
{
    public string MaDon { get; set; } = null!;

    public DateOnly NgayXinNghi { get; set; }

    public string? LyDo { get; set; }

    public string? TrangThai { get; set; }

    public string MaNhanVienLap { get; set; } = null!;

    public string MaQuanLy { get; set; } = null!;

    public string? MaNhanVienThayThe { get; set; }

    public virtual NhanVien MaNhanVienLapNavigation { get; set; } = null!;

    public virtual NhanVien? MaNhanVienThayTheNavigation { get; set; }

    public virtual NhanVien MaQuanLyNavigation { get; set; } = null!;
}
