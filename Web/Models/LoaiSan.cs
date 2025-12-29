using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class LoaiSan
{
    public string MaLoaiSan { get; set; } = null!;

    public string TenLoaiSan { get; set; } = null!;

    public int DonViTinhTheoPhut { get; set; }

    public int GiaGoc { get; set; }

    public string? MoTa { get; set; }

    public virtual BangGiaTangCuoiTuan? BangGiaTangCuoiTuan { get; set; }

    public virtual ICollection<BangGiaTangKhungGio> BangGiaTangKhungGios { get; set; } = new List<BangGiaTangKhungGio>();

    public virtual ICollection<BangGiaTangNgayLe> BangGiaTangNgayLes { get; set; } = new List<BangGiaTangNgayLe>();

    public virtual ICollection<San> Sans { get; set; } = new List<San>();
}
