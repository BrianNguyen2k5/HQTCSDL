using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class CoSo
{
    public string MaCoSo { get; set; } = null!;

    public string TenCoSo { get; set; } = null!;

    public string DiaChi { get; set; } = null!;

    public virtual ICollection<NhanVien> NhanViens { get; set; } = new List<NhanVien>();

    public virtual ICollection<San> Sans { get; set; } = new List<San>();

    public virtual ICollection<TaiSanChoThue> TaiSanChoThues { get; set; } = new List<TaiSanChoThue>();

    public virtual ICollection<TonKho> TonKhos { get; set; } = new List<TonKho>();
}
