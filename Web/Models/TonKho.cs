using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class TonKho
{
    public string MaDichVu { get; set; } = null!;

    public string MaCoSo { get; set; } = null!;

    public int SoLuong { get; set; }

    public bool? TrangThaiKhaDung { get; set; }

    public virtual CoSo MaCoSoNavigation { get; set; } = null!;

    public virtual DichVu MaDichVuNavigation { get; set; } = null!;
}
