using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class ChiTietPhieuDatSan
{
    public string MaChiTietPds { get; set; } = null!;

    public int SoLuong { get; set; }

    public int ThanhTien { get; set; }

    public string LoaiYeuCau { get; set; } = null!;

    public string MaPhieuDat { get; set; } = null!;

    public string? MaNhanVien { get; set; }

    public string MaDichVu { get; set; } = null!;

    public string? MaHlv { get; set; }

    public virtual DatLichHlv? DatLichHlv { get; set; }

    public virtual LichSuHuyDichVu? LichSuHuyDichVu { get; set; }

    public virtual DichVu MaDichVuNavigation { get; set; } = null!;

    public virtual HuanLuyenVien? MaHlvNavigation { get; set; }

    public virtual NhanVien? MaNhanVienNavigation { get; set; }

    public virtual PhieuDatSan MaPhieuDatNavigation { get; set; } = null!;
}
