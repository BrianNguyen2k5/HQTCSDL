using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class ChucVu
{
    public string MaChucVu { get; set; } = null!;

    public string TenChucVu { get; set; } = null!;

    public virtual ICollection<NhanVien> NhanViens { get; set; } = new List<NhanVien>();
}
