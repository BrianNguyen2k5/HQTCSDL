using System;

namespace DTO
{

    public class ChiNhanhDTO
    {
        public string MaCoSo { get; set; }
        public string TenCoSo { get; set; }
        public string DiaChi { get; set; }
        public string GioMoCua { get; set; } = "7:00"; // Default, or fetch from DB logic
        public string GioDongCua { get; set; } = "22:00"; // Default
    }

    public class PromotionDTO
    {
        public string MaUuDai { get; set; }
        public string LoaiUuDai { get; set; }
        public double PhanTramGiamGia { get; set; }
    }

    public class LoaiSanDTO
    {
        public string MaLoaiSan { get; set; }
        public string TenLoaiSan { get; set; }
        public string MoTa { get; set; }
        public int GiaGoc { get; set; }
        public int DonViTinhTheoPhut { get; set; }
        public string Icon { get; set; } // Map manually on backend or frontend
    }

    public class SanDTO
    {
        public string MaSan { get; set; }
        public string TenSan { get; set; }
        public string MaLoaiSan { get; set; }
        public string MaCoSo { get; set; }
        public string TinhTrang { get; set; }
        public int SucChua { get; set; }
    }

    public class DichVuBookingDTO
    {
        public string MaDichVu { get; set; }
        public string TenDichVu { get; set; }
        public string LoaiDichVu { get; set; }
        public int DonGia { get; set; }
        public string DonViTinh { get; set; }
    }

    public class BookingRequestDTO
    {
        public string NgayNhanSan { get; set; } // Date in format YYYY-MM-DD
        public string GioBatDau { get; set; } // "HH:mm"
        public string GioKetThuc { get; set; } // "HH:mm"
        public string MaSan { get; set; }
        public string MaKhachHang { get; set; } // From Auth
        
    }

    public class BookingScheduleDTO
    {
        public string MaPhieuDat { get; set; }
        public string MaSan { get; set; }
        public TimeSpan GioBatDau { get; set; }
        public TimeSpan GioKetThuc { get; set; }
    }

    public class ServiceAddRequestDTO
    {
        public string MaPhieuDat { get; set; }
        public string MaDichVu { get; set; }
        public int SoLuong { get; set; }
        public string? MaNhanVien { get; set; } // Optional, null for online booking
    }

    public class ServiceAddResponseDTO
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string MaChiTietPDS { get; set; }
    }

    public class BookingResponseDTO
    {
        public string MaPhieuDat { get; set; }
        public bool Success { get; set; }
        public string Message { get; set; }
    }

    public class MyBookingDTO
    {
        public string MaPhieuDat { get; set; }
        public string NgayDat { get; set; }
        public string NgayNhanSan { get; set; }
        public string GioBatDau { get; set; }
        public string GioKetThuc { get; set; }
        public string TenSan { get; set; }
        public string TenLoaiSan { get; set; }
        public string TenCoSo { get; set; }
        public string TrangThaiPhieu { get; set; }
    }

    public class CancelBookingRequestDTO
    {
        public string MaPhieuDat { get; set; }
        public string LyDoHuy { get; set; }
    }

    public class CoachDTO
    {
        public string MaNhanVien { get; set; }
        public string TenNhanVien { get; set; }
        public string MonTheThao { get; set; }
        public decimal GiaThue { get; set; }
        public string KinhNghiem { get; set; }
    }
}