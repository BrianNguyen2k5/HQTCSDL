using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class UuDai
{
    public string MaUuDai { get; set; } = null!;

    public string LoaiUuDai { get; set; } = null!;

    public int PhanTramGiamGia { get; set; }

    public virtual ICollection<ApDung> ApDungs { get; set; } = new List<ApDung>();
}
