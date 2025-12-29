using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class TaiKhoan
{
    public int Id { get; set; }

    public string? TenDangNhap { get; set; }

    public string Salt { get; set; } = null!;

    public string MatKhauMaHoa { get; set; } = null!;

    public string Email { get; set; } = null!;

    public bool? TrangThai { get; set; }

    public DateTime? NgayTao { get; set; }

    public string? MaKhachHang { get; set; }

    public string? MaNhanVien { get; set; }

    public virtual KhachHang? MaKhachHangNavigation { get; set; }

    public virtual NhanVien? MaNhanVienNavigation { get; set; }
}
