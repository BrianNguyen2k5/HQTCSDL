using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class San
{
    public string MaSan { get; set; } = null!;

    public string TenSan { get; set; } = null!;

    public string TinhTrang { get; set; } = null!;

    public int SucChua { get; set; }

    public string MaCoSo { get; set; } = null!;

    public string MaLoaiSan { get; set; } = null!;

    public virtual ICollection<BaoTri> BaoTris { get; set; } = new List<BaoTri>();

    public virtual CoSo MaCoSoNavigation { get; set; } = null!;

    public virtual LoaiSan MaLoaiSanNavigation { get; set; } = null!;

    public virtual ICollection<PhieuDatSan> PhieuDatSans { get; set; } = new List<PhieuDatSan>();
}
