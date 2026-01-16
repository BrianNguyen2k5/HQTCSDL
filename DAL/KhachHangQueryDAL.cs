using System.Data;
using DTO;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace DAL
{
    /// <summary>
    /// DAL class for customer-related queries (separate from existing KhachHang class)
    /// </summary>
    public class KhachHangQueryDAL : DatabaseConnection
    {
        public KhachHangQueryDAL(IConfiguration configuration)
            : base(configuration) { }

        /// <summary>
        /// Lấy danh sách tất cả khách hàng
        /// </summary>
        public List<DTO.KhachHang> LayDanhSachKhachHang()
        {
            var danhSach = new List<DTO.KhachHang>();

            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        MaKhachHang,
                        HoTen,
                        NgaySinh,
                        SoCCCD,
                        SoDienThoai,
                        Email
                    FROM KhachHang
                    ORDER BY HoTen";

                using SqlCommand cmd = new SqlCommand(query, conn);
                using SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    danhSach.Add(new DTO.KhachHang
                    {
                        MaKhachHang = reader["MaKhachHang"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        NgaySinh = reader.IsDBNull(reader.GetOrdinal("NgaySinh")) ? null : reader.GetDateTime(reader.GetOrdinal("NgaySinh")),
                        SoCCCD = reader["SoCCCD"].ToString() ?? string.Empty,
                        SoDienThoai = reader["SoDienThoai"].ToString() ?? string.Empty,
                        Email = reader["Email"].ToString()
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
        /// Lấy thông tin khách hàng theo số điện thoại hoặc mã khách hàng
        /// </summary>
        public DTO.KhachHang? LayKhachHang(string? soDienThoai = null, string? maKhachHang = null)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        MaKhachHang,
                        HoTen,
                        NgaySinh,
                        SoCCCD,
                        SoDienThoai,
                        Email
                    FROM KhachHang
                    WHERE (@SoDienThoai IS NULL OR SoDienThoai = @SoDienThoai)
                      AND (@MaKhachHang IS NULL OR MaKhachHang = @MaKhachHang)";

                using SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SoDienThoai", (object?)soDienThoai ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MaKhachHang", (object?)maKhachHang ?? DBNull.Value);

                using SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new DTO.KhachHang
                    {
                        MaKhachHang = reader["MaKhachHang"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        NgaySinh = reader.IsDBNull(reader.GetOrdinal("NgaySinh")) ? null : reader.GetDateTime(reader.GetOrdinal("NgaySinh")),
                        SoCCCD = reader["SoCCCD"].ToString() ?? string.Empty,
                        SoDienThoai = reader["SoDienThoai"].ToString() ?? string.Empty,
                        Email = reader["Email"].ToString()
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
        /// Lấy thông tin chi tiết khách hàng kèm ưu đãi đang áp dụng
        /// </summary>
        public KhachHangChiTiet? LayKhachHangChiTiet(string maKhachHang)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                conn.Open();

                string query = @"
                    SELECT 
                        kh.MaKhachHang,
                        kh.HoTen,
                        kh.NgaySinh,
                        kh.SoCCCD,
                        kh.SoDienThoai,
                        kh.Email,
                        ud.MaUuDai,
                        ud.LoaiUuDai,
                        ud.PhanTramGiamGia,
                        ad.NgayBatDau,
                        ad.NgayKetThuc,
                        ad.TrangThai
                    FROM KhachHang kh
                    LEFT JOIN ApDung ad ON kh.MaKhachHang = ad.MaKhachHang 
                        AND ad.TrangThai = 1
                        AND GETDATE() BETWEEN ad.NgayBatDau AND ad.NgayKetThuc
                    LEFT JOIN UuDai ud ON ad.MaUuDai = ud.MaUuDai
                    WHERE kh.MaKhachHang = @MaKhachHang";

                using SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaKhachHang", maKhachHang);

                using SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new KhachHangChiTiet
                    {
                        MaKhachHang = reader["MaKhachHang"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        NgaySinh = reader.IsDBNull(reader.GetOrdinal("NgaySinh")) ? null : reader.GetDateTime(reader.GetOrdinal("NgaySinh")),
                        SoCCCD = reader["SoCCCD"].ToString() ?? string.Empty,
                        SoDienThoai = reader["SoDienThoai"].ToString() ?? string.Empty,
                        Email = reader["Email"].ToString(),
                        LoaiUuDai = reader.IsDBNull(reader.GetOrdinal("LoaiUuDai"))
                            ? null
                            : reader["LoaiUuDai"].ToString(),
                        PhanTramGiamGia = reader.IsDBNull(reader.GetOrdinal("PhanTramGiamGia"))
                            ? 0
                            : reader.GetInt32(reader.GetOrdinal("PhanTramGiamGia"))
                    };
                }

                return null;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }

    #region Extended DTOs

    /// <summary>
    /// DTO mở rộng cho thông tin khách hàng kèm ưu đãi
    /// </summary>
    public class KhachHangChiTiet
    {
        public required string MaKhachHang { get; set; }
        public required string HoTen { get; set; }
        public DateTime? NgaySinh { get; set; }
        public required string SoCCCD { get; set; }
        public required string SoDienThoai { get; set; }
        public string? Email { get; set; }
        public string? LoaiUuDai { get; set; }
        public int PhanTramGiamGia { get; set; }
    }

    #endregion
}
