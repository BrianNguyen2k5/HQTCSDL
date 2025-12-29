using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class HuanLuyenVien
{
    public string MaHlv { get; set; } = null!;

    public string ChuyenMon { get; set; } = null!;

    public int GiaThuTheoGio { get; set; }

    public string KinhNghiem { get; set; } = null!;

    public virtual ICollection<ChiTietPhieuDatSan> ChiTietPhieuDatSans { get; set; } = new List<ChiTietPhieuDatSan>();

    public virtual ICollection<DatLichHlv> DatLichHlvs { get; set; } = new List<DatLichHlv>();

    public virtual ICollection<LichLamViec> LichLamViecs { get; set; } = new List<LichLamViec>();

    public virtual NhanVien MaHlvNavigation { get; set; } = null!;
}
