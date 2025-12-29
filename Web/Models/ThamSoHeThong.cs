using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class ThamSoHeThong
{
    public string MaThamSo { get; set; } = null!;

    public string TenThamSo { get; set; } = null!;

    public int GiaTri { get; set; }

    public string DonVi { get; set; } = null!;

    public string? MoTa { get; set; }

    public DateOnly CapNhatLanCuoi { get; set; }
}
