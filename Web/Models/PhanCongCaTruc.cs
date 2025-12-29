using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class PhanCongCaTruc
{
    public string MaCa { get; set; } = null!;

    public string MaNhanVien { get; set; } = null!;

    public DateOnly NgayLamViec { get; set; }

    public string MaQuanLy { get; set; } = null!;

    public virtual CaTruc MaCaNavigation { get; set; } = null!;

    public virtual NhanVien MaNhanVienNavigation { get; set; } = null!;

    public virtual NhanVien MaQuanLyNavigation { get; set; } = null!;
}
