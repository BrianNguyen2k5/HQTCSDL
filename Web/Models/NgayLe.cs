using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class NgayLe
{
    public DateOnly MaNgayLe { get; set; }

    public string TenNgayLe { get; set; } = null!;

    public virtual ICollection<BangGiaTangNgayLe> BangGiaTangNgayLes { get; set; } = new List<BangGiaTangNgayLe>();
}
