using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace HQTCSDL.Models;

public partial class VietSportContext : DbContext
{
    public VietSportContext()
    {
    }

    public VietSportContext(DbContextOptions<VietSportContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ApDung> ApDungs { get; set; }

    public virtual DbSet<BangGiaTangCuoiTuan> BangGiaTangCuoiTuans { get; set; }

    public virtual DbSet<BangGiaTangKhungGio> BangGiaTangKhungGios { get; set; }

    public virtual DbSet<BangGiaTangNgayLe> BangGiaTangNgayLes { get; set; }

    public virtual DbSet<BaoTri> BaoTris { get; set; }

    public virtual DbSet<CaTruc> CaTrucs { get; set; }

    public virtual DbSet<ChiTietPhieuDatSan> ChiTietPhieuDatSans { get; set; }

    public virtual DbSet<ChiTietPhieuThueTaiSan> ChiTietPhieuThueTaiSans { get; set; }

    public virtual DbSet<ChucVu> ChucVus { get; set; }

    public virtual DbSet<CoSo> CoSos { get; set; }

    public virtual DbSet<DatLichHlv> DatLichHlvs { get; set; }

    public virtual DbSet<DichVu> DichVus { get; set; }

    public virtual DbSet<DonNghiPhep> DonNghiPheps { get; set; }

    public virtual DbSet<GoiDichVu> GoiDichVus { get; set; }

    public virtual DbSet<HoaDon> HoaDons { get; set; }

    public virtual DbSet<HuanLuyenVien> HuanLuyenViens { get; set; }

    public virtual DbSet<KhachHang> KhachHangs { get; set; }

    public virtual DbSet<KhungGio> KhungGios { get; set; }

    public virtual DbSet<LichLamViec> LichLamViecs { get; set; }

    public virtual DbSet<LichSuHuyDichVu> LichSuHuyDichVus { get; set; }

    public virtual DbSet<LichSuThayDoi> LichSuThayDois { get; set; }

    public virtual DbSet<LoaiSan> LoaiSans { get; set; }

    public virtual DbSet<NgayLe> NgayLes { get; set; }

    public virtual DbSet<NhanVien> NhanViens { get; set; }

    public virtual DbSet<PhanCongCaTruc> PhanCongCaTrucs { get; set; }

    public virtual DbSet<PhieuDatSan> PhieuDatSans { get; set; }

    public virtual DbSet<PhieuThueTaiSan> PhieuThueTaiSans { get; set; }

    public virtual DbSet<San> Sans { get; set; }

    public virtual DbSet<TaiKhoan> TaiKhoans { get; set; }

    public virtual DbSet<TaiSanChoThue> TaiSanChoThues { get; set; }

    public virtual DbSet<ThamSoHeThong> ThamSoHeThongs { get; set; }

    public virtual DbSet<TonKho> TonKhos { get; set; }

    public virtual DbSet<UuDai> UuDais { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
		{
				if (!optionsBuilder.IsConfigured)
				{
						optionsBuilder.UseSqlServer("Server=localhost;Database=VietSport;Trusted_Connection=True;TrustServerCertificate=True;");
				}
		}
		
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ApDung>(entity =>
        {
            entity.HasKey(e => new { e.MaKhachHang, e.MaUuDai }).HasName("PK__ApDung__31B7F3E7A8B51C8A");

            entity.ToTable("ApDung");

            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaUuDai)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.NgayBatDau).HasColumnType("datetime");
            entity.Property(e => e.NgayKetThuc).HasColumnType("datetime");

            entity.HasOne(d => d.MaKhachHangNavigation).WithMany(p => p.ApDungs)
                .HasForeignKey(d => d.MaKhachHang)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ApDung_KH");

            entity.HasOne(d => d.MaUuDaiNavigation).WithMany(p => p.ApDungs)
                .HasForeignKey(d => d.MaUuDai)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ApDung_UuDai");
        });

        modelBuilder.Entity<BangGiaTangCuoiTuan>(entity =>
        {
            entity.HasKey(e => e.MaLoaiSan).HasName("PK__BangGiaT__7D512AE4BC507297");

            entity.ToTable("BangGiaTangCuoiTuan");

            entity.Property(e => e.MaLoaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaLoaiSanNavigation).WithOne(p => p.BangGiaTangCuoiTuan)
                .HasForeignKey<BangGiaTangCuoiTuan>(d => d.MaLoaiSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BGTCT_LoaiSan");
        });

        modelBuilder.Entity<BangGiaTangKhungGio>(entity =>
        {
            entity.HasKey(e => new { e.MaLoaiSan, e.MaKhungGio }).HasName("PK__BangGiaT__FCBD3DC239B7B0AF");

            entity.ToTable("BangGiaTangKhungGio");

            entity.Property(e => e.MaLoaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaKhungGio)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaKhungGioNavigation).WithMany(p => p.BangGiaTangKhungGios)
                .HasForeignKey(d => d.MaKhungGio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BGTKG_KhungGio");

            entity.HasOne(d => d.MaLoaiSanNavigation).WithMany(p => p.BangGiaTangKhungGios)
                .HasForeignKey(d => d.MaLoaiSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BGTKG_LoaiSan");
        });

        modelBuilder.Entity<BangGiaTangNgayLe>(entity =>
        {
            entity.HasKey(e => new { e.MaLoaiSan, e.MaNgayLe }).HasName("PK__BangGiaT__48001BAD385EA131");

            entity.ToTable("BangGiaTangNgayLe");

            entity.Property(e => e.MaLoaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaLoaiSanNavigation).WithMany(p => p.BangGiaTangNgayLes)
                .HasForeignKey(d => d.MaLoaiSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BGTNL_LoaiSan");

            entity.HasOne(d => d.MaNgayLeNavigation).WithMany(p => p.BangGiaTangNgayLes)
                .HasForeignKey(d => d.MaNgayLe)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BGTNL_NgayLe");
        });

        modelBuilder.Entity<BaoTri>(entity =>
        {
            entity.HasKey(e => new { e.MaNhanVien, e.MaSan }).HasName("PK__BaoTri__04AA46C5897199A5");

            entity.ToTable("BaoTri");

            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.ChiPhi).HasDefaultValue(0);
            entity.Property(e => e.MoTa).HasMaxLength(255);
            entity.Property(e => e.NgayBaoTri).HasColumnType("datetime");
            entity.Property(e => e.NgayHoanThanh).HasColumnType("datetime");
            entity.Property(e => e.TrangThai).HasMaxLength(20);

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.BaoTris)
                .HasForeignKey(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BaoTri_NV");

            entity.HasOne(d => d.MaSanNavigation).WithMany(p => p.BaoTris)
                .HasForeignKey(d => d.MaSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BaoTri_San");
        });

        modelBuilder.Entity<CaTruc>(entity =>
        {
            entity.HasKey(e => e.MaCa).HasName("PK__CaTruc__27258E7BB36970AF");

            entity.ToTable("CaTruc");

            entity.Property(e => e.MaCa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TenCa).HasMaxLength(50);
        });

        modelBuilder.Entity<ChiTietPhieuDatSan>(entity =>
        {
            entity.HasKey(e => e.MaChiTietPds).HasName("PK__ChiTietP__C05D0A6332C2A8AE");

            entity.ToTable("ChiTietPhieuDatSan");

            entity.Property(e => e.MaChiTietPds)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaChiTietPDS");
            entity.Property(e => e.LoaiYeuCau).HasMaxLength(100);
            entity.Property(e => e.MaDichVu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaHlv)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaHLV");
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaPhieuDat)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.ChiTietPhieuDatSans)
                .HasForeignKey(d => d.MaDichVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CTPDS_DichVu");

            entity.HasOne(d => d.MaHlvNavigation).WithMany(p => p.ChiTietPhieuDatSans)
                .HasForeignKey(d => d.MaHlv)
                .HasConstraintName("FK_CTPDS_HLV");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.ChiTietPhieuDatSans)
                .HasForeignKey(d => d.MaNhanVien)
                .HasConstraintName("FK_CTPDS_NV");

            entity.HasOne(d => d.MaPhieuDatNavigation).WithMany(p => p.ChiTietPhieuDatSans)
                .HasForeignKey(d => d.MaPhieuDat)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CTPDS_Phieu");
        });

        modelBuilder.Entity<ChiTietPhieuThueTaiSan>(entity =>
        {
            entity.HasKey(e => e.MaChiTietPtts).HasName("PK__ChiTietP__E8566020F24A2ADE");

            entity.ToTable("ChiTietPhieuThueTaiSan");

            entity.Property(e => e.MaChiTietPtts)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaChiTietPTTS");
            entity.Property(e => e.MaGoi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaPhieuThue)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaTaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.NgayBatDau).HasColumnType("datetime");
            entity.Property(e => e.NgayKetThuc).HasColumnType("datetime");

            entity.HasOne(d => d.MaGoiNavigation).WithMany(p => p.ChiTietPhieuThueTaiSans)
                .HasForeignKey(d => d.MaGoi)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CTPTTS_Goi");

            entity.HasOne(d => d.MaPhieuThueNavigation).WithMany(p => p.ChiTietPhieuThueTaiSans)
                .HasForeignKey(d => d.MaPhieuThue)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CTPTTS_Phieu");

            entity.HasOne(d => d.MaTaiSanNavigation).WithMany(p => p.ChiTietPhieuThueTaiSans)
                .HasForeignKey(d => d.MaTaiSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CTPTTS_TaiSan");
        });

        modelBuilder.Entity<ChucVu>(entity =>
        {
            entity.HasKey(e => e.MaChucVu).HasName("PK__ChucVu__D4639533B9BB7065");

            entity.ToTable("ChucVu");

            entity.Property(e => e.MaChucVu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TenChucVu).HasMaxLength(50);
        });

        modelBuilder.Entity<CoSo>(entity =>
        {
            entity.HasKey(e => e.MaCoSo).HasName("PK__CoSo__152D06344B1F24F7");

            entity.ToTable("CoSo");

            entity.Property(e => e.MaCoSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.DiaChi).HasMaxLength(255);
            entity.Property(e => e.TenCoSo).HasMaxLength(100);
        });

        modelBuilder.Entity<DatLichHlv>(entity =>
        {
            entity.HasKey(e => e.MaChiTietPds).HasName("PK__DatLichH__C05D0A63DEFED32D");

            entity.ToTable("DatLichHLV");

            entity.Property(e => e.MaChiTietPds)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaChiTietPDS");
            entity.Property(e => e.GioBatDauDv)
                .HasColumnType("datetime")
                .HasColumnName("GioBatDauDV");
            entity.Property(e => e.GioKetThucDv)
                .HasColumnType("datetime")
                .HasColumnName("GioKetThucDV");
            entity.Property(e => e.MaHlv)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaHLV");

            entity.HasOne(d => d.MaChiTietPdsNavigation).WithOne(p => p.DatLichHlv)
                .HasForeignKey<DatLichHlv>(d => d.MaChiTietPds)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DLHLV_CTPDS");

            entity.HasOne(d => d.MaHlvNavigation).WithMany(p => p.DatLichHlvs)
                .HasForeignKey(d => d.MaHlv)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DLHLV_HLV");
        });

        modelBuilder.Entity<DichVu>(entity =>
        {
            entity.HasKey(e => e.MaDichVu).HasName("PK__DichVu__C0E6DE8FDC5DFEA9");

            entity.ToTable("DichVu");

            entity.Property(e => e.MaDichVu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.DonViTinh).HasMaxLength(10);
            entity.Property(e => e.LoaiDichVu).HasMaxLength(20);
            entity.Property(e => e.TenDichVu).HasMaxLength(100);
        });

        modelBuilder.Entity<DonNghiPhep>(entity =>
        {
            entity.HasKey(e => e.MaDon).HasName("PK__DonNghiP__3D89F56851DE3B59");

            entity.ToTable("DonNghiPhep");

            entity.Property(e => e.MaDon)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LyDo).HasMaxLength(255);
            entity.Property(e => e.MaNhanVienLap)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaNhanVienThayThe)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaQuanLy)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TrangThai).HasMaxLength(20);

            entity.HasOne(d => d.MaNhanVienLapNavigation).WithMany(p => p.DonNghiPhepMaNhanVienLapNavigations)
                .HasForeignKey(d => d.MaNhanVienLap)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NghiPhep_NVLap");

            entity.HasOne(d => d.MaNhanVienThayTheNavigation).WithMany(p => p.DonNghiPhepMaNhanVienThayTheNavigations)
                .HasForeignKey(d => d.MaNhanVienThayThe)
                .HasConstraintName("FK_NghiPhep_NVTT");

            entity.HasOne(d => d.MaQuanLyNavigation).WithMany(p => p.DonNghiPhepMaQuanLyNavigations)
                .HasForeignKey(d => d.MaQuanLy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NghiPhep_QL");
        });

        modelBuilder.Entity<GoiDichVu>(entity =>
        {
            entity.HasKey(e => e.MaGoi).HasName("PK__GoiDichV__3CD30F69CD6B2941");

            entity.ToTable("GoiDichVu");

            entity.Property(e => e.MaGoi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LoaiTaiSan).HasMaxLength(20);
            entity.Property(e => e.TenGoi).HasMaxLength(100);
        });

        modelBuilder.Entity<HoaDon>(entity =>
        {
            entity.HasKey(e => e.MaHoaDon).HasName("PK__HoaDon__835ED13BBE67B16E");

            entity.ToTable("HoaDon");

            entity.Property(e => e.MaHoaDon)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.HinhThucThanhToan).HasMaxLength(50);
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaPhieuDat)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaPhieuThue)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.NgayXuat).HasColumnType("datetime");
            entity.Property(e => e.TrangThaiThanhToan).HasMaxLength(50);

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HoaDon_NV");

            entity.HasOne(d => d.MaPhieuDatNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaPhieuDat)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HoaDon_PDS");

            entity.HasOne(d => d.MaPhieuThueNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaPhieuThue)
                .HasConstraintName("FK_HoaDon_PTS");
        });

        modelBuilder.Entity<HuanLuyenVien>(entity =>
        {
            entity.HasKey(e => e.MaHlv).HasName("PK__HuanLuye__3C9029D8247C60BE");

            entity.ToTable("HuanLuyenVien");

            entity.Property(e => e.MaHlv)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaHLV");
            entity.Property(e => e.ChuyenMon).HasMaxLength(100);
            entity.Property(e => e.KinhNghiem).HasMaxLength(255);

            entity.HasOne(d => d.MaHlvNavigation).WithOne(p => p.HuanLuyenVien)
                .HasForeignKey<HuanLuyenVien>(d => d.MaHlv)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HLV_NhanVien");
        });

        modelBuilder.Entity<KhachHang>(entity =>
        {
            entity.HasKey(e => e.MaKhachHang).HasName("PK__KhachHan__88D2F0E526142043");

            entity.ToTable("KhachHang");

            entity.HasIndex(e => e.SoCccd, "UQ__KhachHan__8A547D3AECEF4A1E").IsUnique();

            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.SoCccd)
                .HasMaxLength(12)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("SoCCCD");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
        });

        modelBuilder.Entity<KhungGio>(entity =>
        {
            entity.HasKey(e => e.MaKhungGio).HasName("PK__KhungGio__1EC172690A349F4A");

            entity.ToTable("KhungGio");

            entity.Property(e => e.MaKhungGio)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
        });

        modelBuilder.Entity<LichLamViec>(entity =>
        {
            entity.HasKey(e => new { e.MaHlv, e.NgayTrongTuan }).HasName("PK__LichLamV__8231BC5F3001C04B");

            entity.ToTable("LichLamViec");

            entity.Property(e => e.MaHlv)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaHLV");

            entity.HasOne(d => d.MaHlvNavigation).WithMany(p => p.LichLamViecs)
                .HasForeignKey(d => d.MaHlv)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LichLamViec_HLV");
        });

        modelBuilder.Entity<LichSuHuyDichVu>(entity =>
        {
            entity.HasKey(e => e.MaChiTietPds).HasName("PK__LichSuHu__C05D0A63ECAEEF2C");

            entity.ToTable("LichSuHuyDichVu");

            entity.Property(e => e.MaChiTietPds)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MaChiTietPDS");
            entity.Property(e => e.LyDoHuy).HasMaxLength(255);
            entity.Property(e => e.ThoiGianHuy).HasColumnType("datetime");

            entity.HasOne(d => d.MaChiTietPdsNavigation).WithOne(p => p.LichSuHuyDichVu)
                .HasForeignKey<LichSuHuyDichVu>(d => d.MaChiTietPds)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LSHDV_CTPDS");
        });

        modelBuilder.Entity<LichSuThayDoi>(entity =>
        {
            entity.HasKey(e => e.MaPhieuDat).HasName("PK__LichSuTh__01EA0D2BCA5312BB");

            entity.ToTable("LichSuThayDoi");

            entity.Property(e => e.MaPhieuDat)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LoaiThayDoi).HasMaxLength(100);
            entity.Property(e => e.LyDo).HasMaxLength(255);
            entity.Property(e => e.ThoiDiemThayDoi).HasColumnType("datetime");

            entity.HasOne(d => d.MaPhieuDatNavigation).WithOne(p => p.LichSuThayDoi)
                .HasForeignKey<LichSuThayDoi>(d => d.MaPhieuDat)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LSTD_PDS");
        });

        modelBuilder.Entity<LoaiSan>(entity =>
        {
            entity.HasKey(e => e.MaLoaiSan).HasName("PK__LoaiSan__7D512AE4EC67F669");

            entity.ToTable("LoaiSan");

            entity.Property(e => e.MaLoaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MoTa).HasMaxLength(255);
            entity.Property(e => e.TenLoaiSan).HasMaxLength(50);
        });

        modelBuilder.Entity<NgayLe>(entity =>
        {
            entity.HasKey(e => e.MaNgayLe).HasName("PK__NgayLe__551314922773EBF9");

            entity.ToTable("NgayLe");

            entity.Property(e => e.TenNgayLe).HasMaxLength(100);
        });

        modelBuilder.Entity<NhanVien>(entity =>
        {
            entity.HasKey(e => e.MaNhanVien).HasName("PK__NhanVien__77B2CA4733C7D22F");

            entity.ToTable("NhanVien");

            entity.HasIndex(e => e.SoCccd, "UQ__NhanVien__8A547D3A411AA0F9").IsUnique();

            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.DiaChi).HasMaxLength(255);
            entity.Property(e => e.GioiTinh).HasMaxLength(5);
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.MaChucVu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaCoSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaQuanLy)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.PhuCap).HasDefaultValue(0);
            entity.Property(e => e.SoCccd)
                .HasMaxLength(12)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("SoCCCD");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TrangThai).HasMaxLength(20);

            entity.HasOne(d => d.MaChucVuNavigation).WithMany(p => p.NhanViens)
                .HasForeignKey(d => d.MaChucVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NhanVien_ChucVu");

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.NhanViens)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_NhanVien_CoSo");

            entity.HasOne(d => d.MaQuanLyNavigation).WithMany(p => p.InverseMaQuanLyNavigation)
                .HasForeignKey(d => d.MaQuanLy)
                .HasConstraintName("FK_NhanVien_QuanLy");
        });

        modelBuilder.Entity<PhanCongCaTruc>(entity =>
        {
            entity.HasKey(e => new { e.MaCa, e.MaNhanVien, e.NgayLamViec }).HasName("PK__PhanCong__FC6CD02D934F750A");

            entity.ToTable("PhanCongCaTruc");

            entity.Property(e => e.MaCa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaQuanLy)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaCaNavigation).WithMany(p => p.PhanCongCaTrucs)
                .HasForeignKey(d => d.MaCa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PhanCong_Ca");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.PhanCongCaTrucMaNhanVienNavigations)
                .HasForeignKey(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PhanCong_NV");

            entity.HasOne(d => d.MaQuanLyNavigation).WithMany(p => p.PhanCongCaTrucMaQuanLyNavigations)
                .HasForeignKey(d => d.MaQuanLy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PhanCong_QL");
        });

        modelBuilder.Entity<PhieuDatSan>(entity =>
        {
            entity.HasKey(e => e.MaPhieuDat).HasName("PK__PhieuDat__01EA0D2B21F71D6F");

            entity.ToTable("PhieuDatSan");

            entity.Property(e => e.MaPhieuDat)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.HinhThucDat).HasMaxLength(50);
            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.NgayDat).HasColumnType("datetime");
            entity.Property(e => e.TrangThaiPhieu).HasMaxLength(20);

            entity.HasOne(d => d.MaKhachHangNavigation).WithMany(p => p.PhieuDatSans)
                .HasForeignKey(d => d.MaKhachHang)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PDS_KH");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.PhieuDatSans)
                .HasForeignKey(d => d.MaNhanVien)
                .HasConstraintName("FK_PDS_NV");

            entity.HasOne(d => d.MaSanNavigation).WithMany(p => p.PhieuDatSans)
                .HasForeignKey(d => d.MaSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PDS_San");
        });

        modelBuilder.Entity<PhieuThueTaiSan>(entity =>
        {
            entity.HasKey(e => e.MaPhieuThue).HasName("PK__PhieuThu__0832281643627ADD");

            entity.ToTable("PhieuThueTaiSan");

            entity.Property(e => e.MaPhieuThue)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .IsFixedLength();
        });

        modelBuilder.Entity<San>(entity =>
        {
            entity.HasKey(e => e.MaSan).HasName("PK__San__3188C826E7282FCF");

            entity.ToTable("San");

            entity.Property(e => e.MaSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaCoSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaLoaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TenSan).HasMaxLength(50);
            entity.Property(e => e.TinhTrang).HasMaxLength(20);

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.Sans)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_San_CoSo");

            entity.HasOne(d => d.MaLoaiSanNavigation).WithMany(p => p.Sans)
                .HasForeignKey(d => d.MaLoaiSan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_San_LoaiSan");
        });

        modelBuilder.Entity<TaiKhoan>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__TaiKhoan__3213E83FD2429C63");

            entity.ToTable("TaiKhoan");

            entity.HasIndex(e => e.TenDangNhap, "UQ__TaiKhoan__55F68FC083BAFADF").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__TaiKhoan__A9D10534EEDE0477").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MatKhauMaHoa)
                .HasMaxLength(64)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Salt)
                .HasMaxLength(32)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TenDangNhap)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.TrangThai).HasDefaultValue(true);

            entity.HasOne(d => d.MaKhachHangNavigation).WithMany(p => p.TaiKhoans)
                .HasForeignKey(d => d.MaKhachHang)
                .HasConstraintName("FK_TaiKhoan_KhachHang");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.TaiKhoans)
                .HasForeignKey(d => d.MaNhanVien)
                .HasConstraintName("FK_TaiKhoan_NhanVien");
        });

        modelBuilder.Entity<TaiSanChoThue>(entity =>
        {
            entity.HasKey(e => e.MaTaiSan).HasName("PK__TaiSanCh__8DB7C7BE815DAEB0");

            entity.ToTable("TaiSanChoThue");

            entity.Property(e => e.MaTaiSan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LoaiTaiSan).HasMaxLength(20);
            entity.Property(e => e.MaCoSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.TrangThai).HasMaxLength(50);

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.TaiSanChoThues)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TSCT_CoSo");
        });

        modelBuilder.Entity<ThamSoHeThong>(entity =>
        {
            entity.HasKey(e => e.MaThamSo).HasName("PK__ThamSoHe__948C30E66C59CF04");

            entity.ToTable("ThamSoHeThong");

            entity.Property(e => e.MaThamSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.DonVi).HasMaxLength(50);
            entity.Property(e => e.MoTa)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.TenThamSo)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TonKho>(entity =>
        {
            entity.HasKey(e => new { e.MaDichVu, e.MaCoSo }).HasName("PK__TonKho__91B40EEC61C4E270");

            entity.ToTable("TonKho");

            entity.Property(e => e.MaDichVu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.MaCoSo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.TonKhos)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TonKho_CoSo");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.TonKhos)
                .HasForeignKey(d => d.MaDichVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TonKho_DV");
        });

        modelBuilder.Entity<UuDai>(entity =>
        {
            entity.HasKey(e => e.MaUuDai).HasName("PK__UuDai__9650302A73ACC22B");

            entity.ToTable("UuDai");

            entity.Property(e => e.MaUuDai)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.LoaiUuDai).HasMaxLength(100);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
