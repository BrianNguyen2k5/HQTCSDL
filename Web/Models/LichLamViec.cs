using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class LichLamViec
{
    public string MaHlv { get; set; } = null!;

    public int NgayTrongTuan { get; set; }

    public TimeOnly GioBatDau { get; set; }

    public TimeOnly GioKetThuc { get; set; }

    public virtual HuanLuyenVien MaHlvNavigation { get; set; } = null!;
}
