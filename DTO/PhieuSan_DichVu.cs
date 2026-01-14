namespace DTO
{
	public class PhieuDatSan
	{
		public required string MaPhieuDat { get; set; }
		public DateTime NgayDat { get; set; }
		public DateTime NgayNhanSan { get; set; }
		public TimeSpan GioBatDau { get; set; }
		public TimeSpan GioKetThuc { get; set; }
		public required string HinhThucDat { get; set; }
		public required string TrangThaiPhieu { get; set; }
		public TimeSpan? ThoiGianCheckin { get; set; }
		public required string MaKhachHang { get; set; }
		public string? MaNhanVien { get; set; }
		public required string MaSan { get; set; }
	}

	public class DatLichHLV
	{
		public required string MaChiTietPDS { get; set; }
		public required string MaHLV { get; set; }
		public DateTime GioBatDauDV { get; set; }
		public DateTime GioKetThucDV { get; set; }
	}

	public class DichVu
	{
		public required string MaDichVu { get; set; }
		public required string TenDichVu { get; set; }
		public required string LoaiDichVu { get; set; }
		public int DonGia { get; set; }
		public required string DonViTinh { get; set; }
		public int SoLuongTonKho { get; set; } = 0;
	}

	public class TonKho
	{
		public required string MaDichVu { get; set; }
		public required string MaCoSo { get; set; }
		public int SoLuong { get; set; }
		public bool? TrangThaiKhaDung { get; set; }
	}

	public class ChiTietPhieuDatSan
	{
		public required string MaChiTietPDS { get; set; }
		public DateTime? ThoiDiemTao { get; set; }
		public int SoLuong { get; set; }
		public int ThanhTien { get; set; }
		public required string LoaiYeuCau { get; set; }
		public required string MaPhieuDat { get; set; }
		public string? MaNhanVien { get; set; }
		public required string MaDichVu { get; set; }
		public string? MaHLV { get; set; }
	}

	public class LichSuThayDoi
	{
		public required string MaPhieuDat { get; set; }
		public DateTime ThoiDiemThayDoi { get; set; }
		public required string LoaiThayDoi { get; set; }
		public int SoTienPhat { get; set; }
		public string? LyDo { get; set; }
		public int SoTienHoanTra { get; set; }
	}

	public class LichSuHuyDichVu
	{
		public required string MaChiTietPDS { get; set; }
		public DateTime ThoiGianHuy { get; set; }
		public string? LyDoHuy { get; set; }
		public int SoTienHoan { get; set; }
	}
}