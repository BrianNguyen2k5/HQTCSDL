using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class ChiTietPhieuThueTaiSan
{
    public string MaChiTietPtts { get; set; } = null!;

    public string MaPhieuThue { get; set; } = null!;

    public string MaTaiSan { get; set; } = null!;

    public string MaGoi { get; set; } = null!;

    public DateTime NgayBatDau { get; set; }

    public DateTime NgayKetThuc { get; set; }

    public virtual GoiDichVu MaGoiNavigation { get; set; } = null!;

    public virtual PhieuThueTaiSan MaPhieuThueNavigation { get; set; } = null!;

    public virtual TaiSanChoThue MaTaiSanNavigation { get; set; } = null!;
}
