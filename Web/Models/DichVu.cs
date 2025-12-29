using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class DichVu
{
    public string MaDichVu { get; set; } = null!;

    public string TenDichVu { get; set; } = null!;

    public string LoaiDichVu { get; set; } = null!;

    public int DonGia { get; set; }

    public string DonViTinh { get; set; } = null!;

    public virtual ICollection<ChiTietPhieuDatSan> ChiTietPhieuDatSans { get; set; } = new List<ChiTietPhieuDatSan>();

    public virtual ICollection<TonKho> TonKhos { get; set; } = new List<TonKho>();
}
