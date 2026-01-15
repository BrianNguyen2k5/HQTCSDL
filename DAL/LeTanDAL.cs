using System.Data;
using DTO;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace DAL
{
    public class LeTanDAL : DatabaseConnection
    {
        public LeTanDAL(IConfiguration configuration)
            : base(configuration) { }

        /// <summary>
        /// GIAI ĐOẠN 1: Đặt sân trực tiếp - Tạo phiếu với trạng thái "Chờ xác nhận"
        /// </summary>
        public (bool success, string message, string? maPhieuDat) DatSanTrucTiep(
            string maKhachHang,
            string maNhanVien,
            string maSan,
            DateTime ngayNhanSan,
            TimeSpan gioBatDau,
            TimeSpan gioKetThuc)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                using SqlCommand cmd = new SqlCommand("sp_LeTan_DatSanTrucTiep", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MaKhachHang", maKhachHang);
                cmd.Parameters.AddWithValue("@MaNhanVien", maNhanVien);
                cmd.Parameters.AddWithValue("@MaSan", maSan);
                cmd.Parameters.AddWithValue("@NgayNhanSan", ngayNhanSan.Date);
                cmd.Parameters.AddWithValue("@GioBatDau", gioBatDau);
                cmd.Parameters.AddWithValue("@GioKetThuc", gioKetThuc);

                cmd.ExecuteNonQuery();

                // Lấy mã phiếu đặt vừa tạo
                string? maPhieuDat = LayMaPhieuDatMoiNhat(conn, maNhanVien);

                return (true, "Đặt sân thành công", maPhieuDat);
            }
            catch (SqlException ex)
            {
                return (false, ex.Message, null);
            }
        }

        /// <summary>
        /// GIAI ĐOẠN 1 & 4: Tạo hóa đơn (cả đặt sân và checkout)
        /// - Giai đoạn 1: Phiếu "Chờ xác nhận" → Tạo HĐ #1 → "Chờ thanh toán"
        /// - Giai đoạn 4: Phiếu "Đang sử dụng" → Tạo HĐ #2 (nếu có DV phát sinh) hoặc "Hoàn thành"
        /// </summary>
        public (bool success, string message, int? maHoaDon) TaoHoaDon(string maPhieuDat, string maNhanVien)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                using SqlCommand cmd = new SqlCommand("sp_TaoHoaDon", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);
                cmd.Parameters.AddWithValue("@MaNhanVien", maNhanVien);

                cmd.ExecuteNonQuery();

                // Lấy mã hóa đơn vừa tạo (nếu có)
                int? maHoaDon = LayMaHoaDonMoiNhat(conn, maPhieuDat);

                return (true, "Tạo hóa đơn thành công", maHoaDon);
            }
            catch (SqlException ex)
            {
                return (false, ex.Message, null);
            }
        }

        /// <summary>
        /// GIAI ĐOẠN 3: Check-in - Chuyển trạng thái từ "Đã xác nhận" sang "Đang sử dụng"
        /// </summary>
        public (bool success, string message) CheckIn(string maPhieuDat)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                using SqlCommand cmd = new SqlCommand("sp_LeTan_CheckIn", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);

                cmd.ExecuteNonQuery();

                return (true, "Check-in thành công");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        /// <summary>
        /// GIAI ĐOẠN 3: Thêm dịch vụ phát sinh trong quá trình sử dụng
        /// </summary>
        public (bool success, string message) ThemDichVu(
            string maPhieuDat,
            string maDichVu,
            int soLuong,
            string maNhanVien)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                using SqlCommand cmd = new SqlCommand("sp_LeTan_ThemDichVu", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);
                cmd.Parameters.AddWithValue("@MaDichVu", maDichVu);
                cmd.Parameters.AddWithValue("@SoLuong", soLuong);
                cmd.Parameters.AddWithValue("@MaNhanVien", maNhanVien);

                cmd.ExecuteNonQuery();

                return (true, "Thêm dịch vụ thành công");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        /// <summary>
        /// Lấy thông tin chi tiết phiếu đặt sân
        /// </summary>
        public PhieuDatSanChiTiet? LayThongTinPhieuDat(string maPhieuDat)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        pds.MaPhieuDat,
                        pds.NgayDat,
                        pds.NgayNhanSan,
                        pds.GioBatDau,
                        pds.GioKetThuc,
                        pds.HinhThucDat,
                        pds.TrangThaiPhieu,
                        pds.ThoiGianCheckin,
                        pds.MaKhachHang,
                        kh.HoTen AS TenKhachHang,
                        kh.SoDienThoai,
                        pds.MaNhanVien,
                        pds.MaSan,
                        s.TenSan,
                        ls.TenLoaiSan
                    FROM PhieuDatSan pds
                    JOIN KhachHang kh ON pds.MaKhachHang = kh.MaKhachHang
                    LEFT JOIN San s ON pds.MaSan = s.MaSan
                    LEFT JOIN LoaiSan ls ON s.MaLoaiSan = ls.MaLoaiSan
                    WHERE pds.MaPhieuDat = @MaPhieuDat";

                using SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);

                using SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new PhieuDatSanChiTiet
                    {
                        MaPhieuDat = reader["MaPhieuDat"].ToString() ?? string.Empty,
                        NgayDat = reader.GetDateTime(reader.GetOrdinal("NgayDat")),
                        NgayNhanSan = reader.GetDateTime(reader.GetOrdinal("NgayNhanSan")),
                        GioBatDau = reader.GetTimeSpan(reader.GetOrdinal("GioBatDau")),
                        GioKetThuc = reader.GetTimeSpan(reader.GetOrdinal("GioKetThuc")),
                        HinhThucDat = reader["HinhThucDat"].ToString() ?? string.Empty,
                        TrangThaiPhieu = reader["TrangThaiPhieu"].ToString() ?? string.Empty,
                        ThoiGianCheckin = reader.IsDBNull(reader.GetOrdinal("ThoiGianCheckin"))
                            ? null
                            : reader.GetTimeSpan(reader.GetOrdinal("ThoiGianCheckin")),
                        MaKhachHang = reader["MaKhachHang"].ToString() ?? string.Empty,
                        TenKhachHang = reader["TenKhachHang"].ToString() ?? string.Empty,
                        SoDienThoai = reader["SoDienThoai"].ToString() ?? string.Empty,
                        MaNhanVien = reader["MaNhanVien"].ToString(),
                        MaSan = reader["MaSan"].ToString() ?? string.Empty,
                        TenSan = reader["TenSan"].ToString() ?? string.Empty,
                        TenLoaiSan = reader["TenLoaiSan"].ToString() ?? string.Empty
                    };
                }

                return null;
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// Lấy danh sách dịch vụ của một phiếu đặt
        /// </summary>
        public List<DichVuPhieuDat> LayDanhSachDichVuTheoPhieu(string maPhieuDat)
        {
            var danhSach = new List<DichVuPhieuDat>();

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        ct.MaChiTietPDS,
                        ct.ThoiDiemTao,
                        ct.SoLuong,
                        ct.ThanhTien,
                        ct.TrangThaiThanhToan,
                        ct.MaDichVu,
                        dv.TenDichVu,
                        dv.LoaiDichVu,
                        dv.DonGia,
                        dv.DonViTinh
                    FROM ChiTietPhieuDatSan ct
                    JOIN DichVu dv ON ct.MaDichVu = dv.MaDichVu
                    WHERE ct.MaPhieuDat = @MaPhieuDat
                    ORDER BY ct.ThoiDiemTao DESC";

                using SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    danhSach.Add(new DichVuPhieuDat
                    {
                        MaChiTietPDS = reader["MaChiTietPDS"].ToString() ?? string.Empty,
                        ThoiDiemTao = reader.IsDBNull(reader.GetOrdinal("ThoiDiemTao"))
                            ? null
                            : reader.GetDateTime(reader.GetOrdinal("ThoiDiemTao")),
                        SoLuong = reader.GetInt32(reader.GetOrdinal("SoLuong")),
                        ThanhTien = reader.GetInt32(reader.GetOrdinal("ThanhTien")),
                        TrangThaiThanhToan = reader.GetInt32(reader.GetOrdinal("TrangThaiThanhToan")),
                        MaDichVu = reader["MaDichVu"].ToString() ?? string.Empty,
                        TenDichVu = reader["TenDichVu"].ToString() ?? string.Empty,
                        LoaiDichVu = reader["LoaiDichVu"].ToString() ?? string.Empty,
                        DonGia = reader.GetInt32(reader.GetOrdinal("DonGia")),
                        DonViTinh = reader["DonViTinh"].ToString() ?? string.Empty
                    });
                }

                return danhSach;
            }
            catch (Exception)
            {
                return danhSach;
            }
        }

        /// <summary>
        /// Lấy danh sách hóa đơn của một phiếu đặt
        /// </summary>
        public List<HoaDon> LayDanhSachHoaDonTheoPhieu(string maPhieuDat)
        {
            var danhSach = new List<HoaDon>();

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        MaHoaDon,
                        NgayXuat,
                        TongTienSan,
                        TongTienDichVu,
                        TongTienGiamGia,
                        TongThanhToan,
                        HinhThucThanhToan,
                        TrangThaiThanhToan,
                        MaNhanVien,
                        MaPhieuDat,
                        MaPhieuThue
                    FROM HoaDon
                    WHERE MaPhieuDat = @MaPhieuDat
                    ORDER BY NgayXuat DESC";

                using SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    danhSach.Add(new HoaDon
                    {
                        MaHoaDon = reader.GetInt32(reader.GetOrdinal("MaHoaDon")),
                        NgayXuat = reader.GetDateTime(reader.GetOrdinal("NgayXuat")),
                        TongTienSan = reader.GetInt32(reader.GetOrdinal("TongTienSan")),
                        TongTienDichVu = reader.GetInt32(reader.GetOrdinal("TongTienDichVu")),
                        TongTienGiamGia = reader.GetInt32(reader.GetOrdinal("TongTienGiamGia")),
                        TongThanhToan = reader.GetInt32(reader.GetOrdinal("TongThanhToan")),
                        HinhThucThanhToan = reader["HinhThucThanhToan"].ToString(),
                        TrangThaiThanhToan = reader["TrangThaiThanhToan"].ToString(),
                        MaNhanVien = reader["MaNhanVien"].ToString() ?? string.Empty,
                        MaPhieuDat = reader["MaPhieuDat"].ToString(),
                        MaPhieuThue = reader["MaPhieuThue"].ToString()
                    });
                }

                return danhSach;
            }
            catch (Exception)
            {
                return danhSach;
            }
        }

        /// <summary>
        /// Lấy danh sách phiếu đặt sân theo trạng thái
        /// </summary>
        public List<PhieuDatSanChiTiet> LayDanhSachPhieuDat(string? trangThai = null, DateTime? ngayNhanSan = null)
        {
            var danhSach = new List<PhieuDatSanChiTiet>();

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        pds.MaPhieuDat,
                        pds.NgayDat,
                        pds.NgayNhanSan,
                        pds.GioBatDau,
                        pds.GioKetThuc,
                        pds.HinhThucDat,
                        pds.TrangThaiPhieu,
                        pds.ThoiGianCheckin,
                        pds.MaKhachHang,
                        kh.HoTen AS TenKhachHang,
                        kh.SoDienThoai,
                        pds.MaNhanVien,
                        pds.MaSan,
                        s.TenSan,
                        ls.TenLoaiSan
                    FROM PhieuDatSan pds
                    JOIN KhachHang kh ON pds.MaKhachHang = kh.MaKhachHang
                    LEFT JOIN San s ON pds.MaSan = s.MaSan
                    LEFT JOIN LoaiSan ls ON s.MaLoaiSan = ls.MaLoaiSan
                    WHERE 1=1";

                if (!string.IsNullOrEmpty(trangThai))
                {
                    query += " AND pds.TrangThaiPhieu = @TrangThai";
                }

                if (ngayNhanSan.HasValue)
                {
                    query += " AND CAST(pds.NgayNhanSan AS DATE) = @NgayNhanSan";
                }

                query += " ORDER BY pds.NgayNhanSan DESC, pds.GioBatDau DESC";

                using SqlCommand cmd = new SqlCommand(query, conn);

                if (!string.IsNullOrEmpty(trangThai))
                {
                    cmd.Parameters.AddWithValue("@TrangThai", trangThai);
                }

                if (ngayNhanSan.HasValue)
                {
                    cmd.Parameters.AddWithValue("@NgayNhanSan", ngayNhanSan.Value.Date);
                }

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    danhSach.Add(new PhieuDatSanChiTiet
                    {
                        MaPhieuDat = reader["MaPhieuDat"].ToString() ?? string.Empty,
                        NgayDat = reader.GetDateTime(reader.GetOrdinal("NgayDat")),
                        NgayNhanSan = reader.GetDateTime(reader.GetOrdinal("NgayNhanSan")),
                        GioBatDau = reader.GetTimeSpan(reader.GetOrdinal("GioBatDau")),
                        GioKetThuc = reader.GetTimeSpan(reader.GetOrdinal("GioKetThuc")),
                        HinhThucDat = reader["HinhThucDat"].ToString() ?? string.Empty,
                        TrangThaiPhieu = reader["TrangThaiPhieu"].ToString() ?? string.Empty,
                        ThoiGianCheckin = reader.IsDBNull(reader.GetOrdinal("ThoiGianCheckin"))
                            ? null
                            : reader.GetTimeSpan(reader.GetOrdinal("ThoiGianCheckin")),
                        MaKhachHang = reader["MaKhachHang"].ToString() ?? string.Empty,
                        TenKhachHang = reader["TenKhachHang"].ToString() ?? string.Empty,
                        SoDienThoai = reader["SoDienThoai"].ToString() ?? string.Empty,
                        MaNhanVien = reader["MaNhanVien"].ToString(),
                        MaSan = reader["MaSan"].ToString() ?? string.Empty,
                        TenSan = reader["TenSan"].ToString() ?? string.Empty,
                        TenLoaiSan = reader["TenLoaiSan"].ToString() ?? string.Empty
                    });
                }

                return danhSach;
            }
            catch (Exception)
            {
                return danhSach;
            }
        }

        #region Helper Methods

        private string? LayMaPhieuDatMoiNhat(SqlConnection conn, string maNhanVien)
        {
            string query = @"
                SELECT TOP 1 MaPhieuDat 
                FROM PhieuDatSan 
                WHERE MaNhanVien = @MaNhanVien 
                ORDER BY NgayDat DESC";

            using SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@MaNhanVien", maNhanVien);

            var result = cmd.ExecuteScalar();
            return result?.ToString();
        }

        private int? LayMaHoaDonMoiNhat(SqlConnection conn, string maPhieuDat)
        {
            string query = @"
                SELECT TOP 1 MaHoaDon 
                FROM HoaDon 
                WHERE MaPhieuDat = @MaPhieuDat 
                ORDER BY NgayXuat DESC";

            using SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);

            var result = cmd.ExecuteScalar();
            return result != null ? Convert.ToInt32(result) : null;
        }

        #endregion
    }

    #region Extended DTOs

    /// <summary>
    /// DTO mở rộng cho thông tin chi tiết phiếu đặt sân
    /// </summary>
    public class PhieuDatSanChiTiet
    {
        public required string MaPhieuDat { get; set; }
        public DateTime NgayDat { get; set; }
        public DateTime NgayNhanSan { get; set; }
        public TimeSpan GioBatDau { get; set; }
        public TimeSpan GioKetThuc { get; set; }
        public required string HinhThucDat { get; set; }
        public required string TrangThaiPhieu { get; set; }
        public TimeSpan? ThoiGianCheckin { get; set; }
        public required string MaKhachHang { get; set; }
        public required string TenKhachHang { get; set; }
        public required string SoDienThoai { get; set; }
        public string? MaNhanVien { get; set; }
        public required string MaSan { get; set; }
        public required string TenSan { get; set; }
        public required string TenLoaiSan { get; set; }
    }

    /// <summary>
    /// DTO cho dịch vụ trong phiếu đặt
    /// </summary>
    public class DichVuPhieuDat
    {
        public required string MaChiTietPDS { get; set; }
        public DateTime? ThoiDiemTao { get; set; }
        public int SoLuong { get; set; }
        public int ThanhTien { get; set; }
        public int TrangThaiThanhToan { get; set; }
        public required string MaDichVu { get; set; }
        public required string TenDichVu { get; set; }
        public required string LoaiDichVu { get; set; }
        public int DonGia { get; set; }
        public required string DonViTinh { get; set; }
    }

    #endregion
}
