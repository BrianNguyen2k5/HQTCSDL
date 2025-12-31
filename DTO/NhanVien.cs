namespace DTO
{
	public class ChucVu
	{
		public required string MaChucVu { get; set; }
		public required string TenChucVu { get; set; }
	}

	public class NhanVien
	{
		public required string MaNhanVien { get; set; }
		public required string HoTen { get; set; }
		public DateTime NgaySinh { get; set; }
		public required string GioiTinh { get; set; }
		public required string SoCCCD { get; set; }
		public required string DiaChi { get; set; }
		public required string SoDienThoai { get; set; }
		public int LuongCoBan { get; set; }
		public int? PhuCap { get; set; }
		public DateTime NgayVaoLam { get; set; }
		public required string TrangThai { get; set; }
		public string? MaQuanLy { get; set; }
		public required string MaCoSo { get; set; }
		public required string MaChucVu { get; set; }
	}

	public class HuanLuyenVien
	{
		public required string MaHLV { get; set; }
		public required string ChuyenMon { get; set; }
		public int GiaThuTheoGio { get; set; }
		public required string KinhNghiem { get; set; }
	}

	public class LichLamViec
	{
		public required string MaHLV { get; set; }
		public int NgayTrongTuan { get; set; }
		public TimeSpan GioBatDau { get; set; }
		public TimeSpan GioKetThuc { get; set; }
	}

	public class CaTruc
	{
		public required string MaCa { get; set; }
		public required string TenCa { get; set; }
		public TimeSpan GioBatDau { get; set; }
		public TimeSpan GioKetThuc { get; set; }
	}

	public class PhanCongCaTruc
	{
		public required string MaCa { get; set; }
		public required string MaNhanVien { get; set; }
		public DateTime NgayLamViec { get; set; }
		public required string MaQuanLy { get; set; }
	}

	public class DonNghiPhep
	{
		public required string MaDon { get; set; }
		public DateTime NgayXinNghi { get; set; }
		public string? LyDo { get; set; }
		public string? TrangThai { get; set; }
		public required string MaNhanVienLap { get; set; }
		public required string MaQuanLy { get; set; }
		public string? MaNhanVienThayThe { get; set; }
	}
}