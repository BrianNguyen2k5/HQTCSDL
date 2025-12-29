using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class GoiDichVu
{
    public string MaGoi { get; set; } = null!;

    public string TenGoi { get; set; } = null!;

    public string LoaiTaiSan { get; set; } = null!;

    public int DonGia { get; set; }

    public int ThoiGianSuDung { get; set; }

    public virtual ICollection<ChiTietPhieuThueTaiSan> ChiTietPhieuThueTaiSans { get; set; } = new List<ChiTietPhieuThueTaiSan>();
}
