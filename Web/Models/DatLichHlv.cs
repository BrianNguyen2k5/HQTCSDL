using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class DatLichHlv
{
    public string MaChiTietPds { get; set; } = null!;

    public string MaHlv { get; set; } = null!;

    public DateTime GioBatDauDv { get; set; }

    public DateTime GioKetThucDv { get; set; }

    public virtual ChiTietPhieuDatSan MaChiTietPdsNavigation { get; set; } = null!;

    public virtual HuanLuyenVien MaHlvNavigation { get; set; } = null!;
}
