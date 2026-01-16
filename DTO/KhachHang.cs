namespace DTO
{
	public class KhachHang
	{
		public required string MaKhachHang { get; set; }
		public required string HoTen { get; set; }
		public DateTime? NgaySinh { get; set; }
		public required string SoCCCD { get; set; }
		public required string SoDienThoai { get; set; }
		public string? Email { get; set; }
	}

	public class UuDai
	{
		public required string MaUuDai { get; set; }
		public required string LoaiUuDai { get; set; }
		public int PhanTramGiamGia { get; set; }
	}

	public class ApDung
	{
		public required string MaKhachHang { get; set; }
		public required string MaUuDai { get; set; }
		public DateTime NgayBatDau { get; set; }
		public DateTime NgayKetThuc { get; set; }
		public bool TrangThai { get; set; }
	}
}