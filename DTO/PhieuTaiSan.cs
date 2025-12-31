namespace DTO
{
	public class GoiDichVu
	{
		public required string MaGoi { get; set; }
		public required string TenGoi { get; set; }
		public required string LoaiTaiSan { get; set; }
		public int DonGia { get; set; }
		public int ThoiGianSuDung { get; set; }
	}

	public class TaiSanChoThue
	{
		public required string MaTaiSan { get; set; }
		public required string LoaiTaiSan { get; set; }
		public required string TrangThai { get; set; }
		public required string MaCoSo { get; set; }
	}

	public class PhieuThueTaiSan
	{
		public required string MaPhieuThue { get; set; }
		public DateTime? ThoiDiemTao { get; set; }
		public required string MaKhachHang { get; set; }
		public required string MaNhanVien { get; set; }
		public required string TrangThai { get; set; }
	}

	public class ChiTietPhieuThueTaiSan
	{
		public required string MaChiTietPTTS { get; set; }
		public required string MaPhieuThue { get; set; }
		public required string MaTaiSan { get; set; }
		public required string MaGoi { get; set; }
		public DateTime NgayBatDau { get; set; }
		public DateTime NgayKetThuc { get; set; }
	}
}