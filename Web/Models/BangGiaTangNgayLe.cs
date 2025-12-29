using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class BangGiaTangNgayLe
{
    public string MaLoaiSan { get; set; } = null!;

    public DateOnly MaNgayLe { get; set; }

    public int GiaTang { get; set; }

    public virtual LoaiSan MaLoaiSanNavigation { get; set; } = null!;

    public virtual NgayLe MaNgayLeNavigation { get; set; } = null!;
}
