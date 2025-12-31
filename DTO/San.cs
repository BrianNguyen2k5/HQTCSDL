namespace DTO
{
	public class CoSo
	{
		public required string MaCoSo { get; set; }
		public required string TenCoSo { get; set; }
		public required string DiaChi { get; set; }
	}

	public class LoaiSan
	{
		public required string MaLoaiSan { get; set; }
		public required string TenLoaiSan { get; set; }
		public int DonViTinhTheoPhut { get; set; }
		public int GiaGoc { get; set; }
		public string? MoTa { get; set; }
	}

	public class San
	{
		public required string MaSan { get; set; }
		public required string TenSan { get; set; }
		public required string TinhTrang { get; set; }
		public int SucChua { get; set; }
		public required string MaCoSo { get; set; }
		public required string MaLoaiSan { get; set; }
	}

	public class BaoTri
	{
		public required string MaNhanVien { get; set; }
		public required string MaSan { get; set; }
		public DateTime NgayBaoTri { get; set; }
		public DateTime? NgayHoanThanh { get; set; }
		public required string TrangThai { get; set; }
		public int? ChiPhi { get; set; }
		public string? MoTa { get; set; }
	}

	public class KhungGio
	{
		public required string MaKhungGio { get; set; }
		public TimeSpan GioBatDau { get; set; }
		public TimeSpan GioKetThuc { get; set; }
	}

	public class NgayLe
	{
		public DateTime MaNgayLe { get; set; }
		public required string TenNgayLe { get; set; }
	}

	// Bảng giá phụ thu
	public class BangGiaTangKhungGio
	{
		public required string MaLoaiSan { get; set; }
		public required string MaKhungGio { get; set; }
		public int GiaTang { get; set; }
	}

	public class BangGiaTangNgayLe
	{
		public required string MaLoaiSan { get; set; }
		public DateTime MaNgayLe { get; set; }
		public int GiaTang { get; set; }
	}

	public class BangGiaTangCuoiTuan
	{
		public required string MaLoaiSan { get; set; }
		public int GiaTang { get; set; }
	}
}