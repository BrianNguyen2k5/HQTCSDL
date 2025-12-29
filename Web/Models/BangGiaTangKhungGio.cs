using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class BangGiaTangKhungGio
{
    public string MaLoaiSan { get; set; } = null!;

    public string MaKhungGio { get; set; } = null!;

    public int GiaTang { get; set; }

    public virtual KhungGio MaKhungGioNavigation { get; set; } = null!;

    public virtual LoaiSan MaLoaiSanNavigation { get; set; } = null!;
}
