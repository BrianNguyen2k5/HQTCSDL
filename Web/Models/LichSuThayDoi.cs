using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class LichSuThayDoi
{
    public string MaPhieuDat { get; set; } = null!;

    public DateTime ThoiDiemThayDoi { get; set; }

    public string LoaiThayDoi { get; set; } = null!;

    public int SoTienPhat { get; set; }

    public string? LyDo { get; set; }

    public int SoTienHoanTra { get; set; }

    public virtual PhieuDatSan MaPhieuDatNavigation { get; set; } = null!;
}
