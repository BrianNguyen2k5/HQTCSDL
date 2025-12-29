using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class KhungGio
{
    public string MaKhungGio { get; set; } = null!;

    public TimeOnly GioBatDau { get; set; }

    public TimeOnly GioKetThuc { get; set; }

    public virtual ICollection<BangGiaTangKhungGio> BangGiaTangKhungGios { get; set; } = new List<BangGiaTangKhungGio>();
}
