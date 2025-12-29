using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class ApDung
{
    public string MaKhachHang { get; set; } = null!;

    public string MaUuDai { get; set; } = null!;

    public DateTime NgayBatDau { get; set; }

    public DateTime NgayKetThuc { get; set; }

    public virtual KhachHang MaKhachHangNavigation { get; set; } = null!;

    public virtual UuDai MaUuDaiNavigation { get; set; } = null!;
}
