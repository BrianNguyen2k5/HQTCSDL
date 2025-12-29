using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class CaTruc
{
    public string MaCa { get; set; } = null!;

    public string TenCa { get; set; } = null!;

    public TimeOnly GioBatDau { get; set; }

    public TimeOnly GioKetThuc { get; set; }

    public virtual ICollection<PhanCongCaTruc> PhanCongCaTrucs { get; set; } = new List<PhanCongCaTruc>();
}
