namespace DTO
{
    public class TaiKhoan
    {
        public int id { get; set; }
        public required string TenDangNhap { get; set; }

        public required string MatKhauMaHoa { get; set; }
        public required string Email { get; set; }
        public bool? TrangThai { get; set; } // Default 1
        public DateTime? NgayTao { get; set; }
        public string? MaKhachHang { get; set; } // Đảm bảo 1 trong 2 phải khác null
        public string? MaNhanVien { get; set; } // Đảm bảo 1 trong 2 phải khác null
    }
}
