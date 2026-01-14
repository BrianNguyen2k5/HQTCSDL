namespace DTO
{
	public class ThamSoHeThong
	{
		public required string MaThamSo { get; set; }
		public required string TenThamSo { get; set; }
		public int GiaTri { get; set; }
		public required string DonVi { get; set; }
		public string? MoTa { get; set; }
		public DateTime CapNhatLanCuoi { get; set; }
	}
}