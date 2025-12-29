using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class LichSuHuyDichVu
{
    public string MaChiTietPds { get; set; } = null!;

    public DateTime ThoiGianHuy { get; set; }

    public string? LyDoHuy { get; set; }

    public int SoTienHoan { get; set; }

    public virtual ChiTietPhieuDatSan MaChiTietPdsNavigation { get; set; } = null!;
}
