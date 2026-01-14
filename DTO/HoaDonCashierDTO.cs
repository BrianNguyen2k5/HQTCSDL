namespace DTO
{
    // DTO cho danh sách hóa đơn
    public class HoaDonListDTO
    {
        public int MaHoaDon { get; set; }
        public DateTime NgayXuat { get; set; }
        public int TongTienSan { get; set; }
        public int TongTienDichVu { get; set; }
        public int TongTienGiamGia { get; set; }
        public int TongThanhToan { get; set; }
        public string? HinhThucThanhToan { get; set; }
        public string TrangThaiThanhToan { get; set; } = string.Empty;
        public string? MaNhanVien { get; set; }
        public string? MaPhieuDat { get; set; }
        public string? MaPhieuThue { get; set; }
        
        // Thông tin khách hàng
        public string? MaKhachHang { get; set; }
        public string TenKhachHang { get; set; } = string.Empty;
        public string? SoDienThoai { get; set; }
        public string? Email { get; set; }
        
        // Thông tin ưu đãi
        public string? LoaiUuDai { get; set; }
        public int? PhanTramGiamGia { get; set; }
        
        // Thông tin phiếu đặt sân
        public DateTime? NgayNhanSan { get; set; }
        public TimeSpan? GioBatDau { get; set; }
        public TimeSpan? GioKetThuc { get; set; }
        public string? TrangThaiPhieu { get; set; }
        public string? TenSan { get; set; }
        public string? TenLoaiSan { get; set; }
        public string? TenCoSo { get; set; }
        public string? MaCoSo { get; set; }
    }

    // DTO cho chi tiết hóa đơn
    public class HoaDonDetailDTO
    {
        public int MaHoaDon { get; set; }
        public DateTime NgayXuat { get; set; }
        public int TongTienSan { get; set; }
        public int TongTienDichVu { get; set; }
        public int TongTienGiamGia { get; set; }
        public int TongThanhToan { get; set; }
        public string? HinhThucThanhToan { get; set; }
        public string TrangThaiThanhToan { get; set; } = string.Empty;
        public string? MaNhanVien { get; set; }
        public string? MaPhieuDat { get; set; }
        public string? MaPhieuThue { get; set; }
        
        // Thông tin khách hàng
        public string? MaKhachHang { get; set; }
        public string TenKhachHang { get; set; } = string.Empty;
        public string? SoDienThoai { get; set; }
        public string? Email { get; set; }
        public DateTime? NgaySinh { get; set; }
        
        // Thông tin ưu đãi
        public string? LoaiUuDai { get; set; }
        public int? PhanTramGiamGia { get; set; }
        
        // Thông tin phiếu đặt sân
        public DateTime? NgayDat { get; set; }
        public DateTime? NgayNhanSan { get; set; }
        public TimeSpan? GioBatDau { get; set; }
        public TimeSpan? GioKetThuc { get; set; }
        public string? HinhThucDat { get; set; }
        public string? TrangThaiPhieu { get; set; }
        public TimeSpan? ThoiGianCheckin { get; set; }
        
        // Thông tin sân
        public string? MaSan { get; set; }
        public string? TenSan { get; set; }
        public string? TenLoaiSan { get; set; }
        public int? GiaGocSan { get; set; }
        public int? DonViTinhTheoPhut { get; set; }
        
        // Thông tin cơ sở
        public string? MaCoSo { get; set; }
        public string? TenCoSo { get; set; }
        public string? DiaChiCoSo { get; set; }
        
        // Danh sách dịch vụ
        public List<ChiTietDichVuDTO> DichVu { get; set; } = new List<ChiTietDichVuDTO>();
        
        // Danh sách tài sản thuê
        public List<ChiTietTaiSanDTO> TaiSan { get; set; } = new List<ChiTietTaiSanDTO>();
    }

    // DTO cho chi tiết dịch vụ
    public class ChiTietDichVuDTO
    {
        public string MaChiTietPDS { get; set; } = string.Empty;
        public int SoLuong { get; set; }
        public int ThanhTien { get; set; }
        public string LoaiYeuCau { get; set; } = string.Empty;
        public DateTime? ThoiDiemTao { get; set; }
        
        // Thông tin dịch vụ
        public string? MaDichVu { get; set; }
        public string TenDichVu { get; set; } = string.Empty;
        public string? LoaiDichVu { get; set; }
        public int DonGia { get; set; }
        public string DonViTinh { get; set; } = string.Empty;
        
        // Thông tin HLV (nếu có)
        public string? MaHLV { get; set; }
        public string? TenHLV { get; set; }
        public int? GiaThuTheoGio { get; set; }
        public DateTime? GioBatDauDV { get; set; }
        public DateTime? GioKetThucDV { get; set; }
    }

    // DTO cho chi tiết tài sản thuê
    public class ChiTietTaiSanDTO
    {
        public string MaChiTietPTTS { get; set; } = string.Empty;
        public DateTime NgayBatDau { get; set; }
        public DateTime NgayKetThuc { get; set; }
        
        // Thông tin tài sản
        public string? MaTaiSan { get; set; }
        public string LoaiTaiSan { get; set; } = string.Empty;
        
        // Thông tin gói
        public string? MaGoi { get; set; }
        public string TenGoi { get; set; } = string.Empty;
        public int DonGia { get; set; }
        public int ThoiGianSuDung { get; set; }
    }

    // DTO cho request thanh toán
    public class PaymentRequestDTO
    {
        public int MaHoaDon { get; set; }
        public string HinhThucThanhToan { get; set; } = string.Empty;
        public string MaNhanVien { get; set; } = string.Empty;
    }

    // DTO cho response thanh toán
    public class PaymentResponseDTO
    {
        public int MaHoaDon { get; set; }
        public string TrangThaiThanhToan { get; set; } = string.Empty;
        public string? HinhThucThanhToan { get; set; }
        public DateTime NgayXuat { get; set; }
        public int TongThanhToan { get; set; }
        public bool Success { get; set; }
        public string? Message { get; set; }
    }
}
