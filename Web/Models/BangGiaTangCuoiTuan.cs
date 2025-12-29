using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class BangGiaTangCuoiTuan
{
    public string MaLoaiSan { get; set; } = null!;

    public int GiaTang { get; set; }

    public virtual LoaiSan MaLoaiSanNavigation { get; set; } = null!;
}
