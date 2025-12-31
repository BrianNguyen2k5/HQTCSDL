namespace DTO
{
	public class HoaDon
	{
		public int MaHoaDon { get; set; }
		public DateTime NgayXuat { get; set; }
		public int TongTienSan { get; set; }
		public int TongTienDichVu { get; set; }
		public int TongTienGiamGia { get; set; }
		public int TongThanhToan { get; set; }
		public string? HinhThucThanhToan { get; set; }
		public string? TrangThaiThanhToan { get; set; }
		public required string MaNhanVien { get; set; }
		public string? MaPhieuDat { get; set; }
		public string? MaPhieuThue { get; set; }
	}
}