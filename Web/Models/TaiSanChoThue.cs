using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class TaiSanChoThue
{
    public string MaTaiSan { get; set; } = null!;

    public string LoaiTaiSan { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public string MaCoSo { get; set; } = null!;

    public virtual ICollection<ChiTietPhieuThueTaiSan> ChiTietPhieuThueTaiSans { get; set; } = new List<ChiTietPhieuThueTaiSan>();

    public virtual CoSo MaCoSoNavigation { get; set; } = null!;
}
