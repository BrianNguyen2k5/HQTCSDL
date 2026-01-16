using System;

namespace DTO
{
    public class BranchDTO
    {
        public string MaCoSo { get; set; }
        public string TenCoSo { get; set; }
        public string DiaChi { get; set; }
    }

    public class CourtTypeDTO
    {
        public string MaLoaiSan { get; set; }
        public string TenLoaiSan { get; set; }
        public int DonViTinhTheoPhut { get; set; }
        public decimal GiaGoc { get; set; }
        public string MoTa { get; set; }
    }

    public class CourtDTO
    {
        public string MaSan { get; set; }
        public string TenSan { get; set; }
        public string TinhTrang { get; set; }
        public int SucChua { get; set; }
        public string MaCoSo { get; set; }
        public string MaLoaiSan { get; set; }
    }

    public class ServiceDTO
    {
        public string MaDichVu { get; set; }
        public string TenDichVu { get; set; }
        public string LoaiDichVu { get; set; }
        public decimal DonGia { get; set; }
        public string DonViTinh { get; set; }
    }

    public class CancelBookingResponseDTO
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }
}
