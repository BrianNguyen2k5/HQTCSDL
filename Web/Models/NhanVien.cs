using System;
using System.Collections.Generic;

namespace HQTCSDL.Models;

public partial class NhanVien
{
    public string MaNhanVien { get; set; } = null!;

    public string HoTen { get; set; } = null!;

    public DateOnly NgaySinh { get; set; }

    public string GioiTinh { get; set; } = null!;

    public string SoCccd { get; set; } = null!;

    public string DiaChi { get; set; } = null!;

    public string SoDienThoai { get; set; } = null!;

    public int LuongCoBan { get; set; }

    public int? PhuCap { get; set; }

    public DateOnly NgayVaoLam { get; set; }

    public string TrangThai { get; set; } = null!;

    public string? MaQuanLy { get; set; }

    public string MaCoSo { get; set; } = null!;

    public string MaChucVu { get; set; } = null!;

    public virtual ICollection<BaoTri> BaoTris { get; set; } = new List<BaoTri>();

    public virtual ICollection<ChiTietPhieuDatSan> ChiTietPhieuDatSans { get; set; } = new List<ChiTietPhieuDatSan>();

    public virtual ICollection<DonNghiPhep> DonNghiPhepMaNhanVienLapNavigations { get; set; } = new List<DonNghiPhep>();

    public virtual ICollection<DonNghiPhep> DonNghiPhepMaNhanVienThayTheNavigations { get; set; } = new List<DonNghiPhep>();

    public virtual ICollection<DonNghiPhep> DonNghiPhepMaQuanLyNavigations { get; set; } = new List<DonNghiPhep>();

    public virtual ICollection<HoaDon> HoaDons { get; set; } = new List<HoaDon>();

    public virtual HuanLuyenVien? HuanLuyenVien { get; set; }

    public virtual ICollection<NhanVien> InverseMaQuanLyNavigation { get; set; } = new List<NhanVien>();

    public virtual ChucVu MaChucVuNavigation { get; set; } = null!;

    public virtual CoSo MaCoSoNavigation { get; set; } = null!;

    public virtual NhanVien? MaQuanLyNavigation { get; set; }

    public virtual ICollection<PhanCongCaTruc> PhanCongCaTrucMaNhanVienNavigations { get; set; } = new List<PhanCongCaTruc>();

    public virtual ICollection<PhanCongCaTruc> PhanCongCaTrucMaQuanLyNavigations { get; set; } = new List<PhanCongCaTruc>();

    public virtual ICollection<PhieuDatSan> PhieuDatSans { get; set; } = new List<PhieuDatSan>();

    public virtual ICollection<TaiKhoan> TaiKhoans { get; set; } = new List<TaiKhoan>();
}
