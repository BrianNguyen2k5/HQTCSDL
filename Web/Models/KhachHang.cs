using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class KhachHang
{
    public string MaKhachHang { get; set; } = null!;

    public string HoTen { get; set; } = null!;

    public DateOnly NgaySinh { get; set; }

    public string SoCccd { get; set; } = null!;

    public string SoDienThoai { get; set; } = null!;

    public string? Email { get; set; }

    public virtual ICollection<ApDung> ApDungs { get; set; } = new List<ApDung>();

    public virtual ICollection<PhieuDatSan> PhieuDatSans { get; set; } = new List<PhieuDatSan>();

    public virtual ICollection<TaiKhoan> TaiKhoans { get; set; } = new List<TaiKhoan>();
}
