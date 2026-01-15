using System.Data;
using DTO;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace DAL
{
    public class CoSo : DatabaseConnection
    {
        public CoSo(IConfiguration configuration)
        : base(configuration) { }

        public List<DTO.CoSo> LayTongDanhSachCoSo()
        {
            List<DTO.CoSo> list = new List<DTO.CoSo>();
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string query = "SELECT * FROM CoSo";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DTO.CoSo coSo = new DTO.CoSo
                            {
                                MaCoSo = reader.GetString(0),
                                TenCoSo = reader.GetString(1),
                                DiaChi = reader.GetString(2),
                            };
                            list.Add(coSo);
                        }
                    }
                }
            }
            return list;
        }

        public class DoanhThuCoSoResult
        {
            public int SoHoaDon { get; set; }
            public decimal TongDoanhThu { get; set; }
            public List<DTO.HoaDon> DanhSachHoaDon { get; set; } = new List<DTO.HoaDon>();
        }

        public DoanhThuCoSoResult LayDoanhThuTheoCoSo(string maCoSo, int nam)
        {
            var result = new DoanhThuCoSoResult();

            using var conn = new SqlConnection(_connectionString);
            conn.Open();

            using var cmd = new SqlCommand("sp_ChiTietThongKeDoanhThu", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@macoso", maCoSo);
            cmd.Parameters.AddWithValue("@nam", nam);

            using var reader = cmd.ExecuteReader();

            // Result Set 1: Summary
            if (reader.Read())
            {
                result.SoHoaDon = reader.IsDBNull(reader.GetOrdinal("SoHoaDon")) ? 0 : reader.GetInt32(reader.GetOrdinal("SoHoaDon"));
                result.TongDoanhThu = reader.IsDBNull(reader.GetOrdinal("TongDoanhThu")) ? 0 : Convert.ToDecimal(reader["TongDoanhThu"]);
            }

            // Result Set 2: Details
            if (reader.NextResult())
            {
                // Lấy danh sách tên cột để kiểm tra tồn tại
                var columns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    columns.Add(reader.GetName(i));
                }

                while (reader.Read())
                {
                    result.DanhSachHoaDon.Add(new DTO.HoaDon
                    {
                        MaHoaDon = columns.Contains("MaHoaDon") ? reader.GetInt32(reader.GetOrdinal("MaHoaDon")) : 0,
                        TongThanhToan = columns.Contains("TongThanhToan") ? reader.GetInt32(reader.GetOrdinal("TongThanhToan")) : 0,
                        HinhThucThanhToan = columns.Contains("HinhThucThanhToan") ? reader["HinhThucThanhToan"].ToString() : "",
                        
                        // Các cột bên dưới chưa có trong SP, gán giá trị mặc định để tránh lỗi
                        NgayXuat = columns.Contains("NgayXuat") ? reader.GetDateTime(reader.GetOrdinal("NgayXuat")) : DateTime.Now,
                        TongTienSan = columns.Contains("TongTienSan") ? reader.GetInt32(reader.GetOrdinal("TongTienSan")) : 0,
                        TongTienDichVu = columns.Contains("TongTienDichVu") ? reader.GetInt32(reader.GetOrdinal("TongTienDichVu")) : 0,
                        TongTienGiamGia = columns.Contains("TongTienGiamGia") ? reader.GetInt32(reader.GetOrdinal("TongTienGiamGia")) : 0,
                        TrangThaiThanhToan = columns.Contains("TrangThaiThanhToan") ? reader["TrangThaiThanhToan"].ToString() : "Đã thanh toán",
                        MaNhanVien = columns.Contains("MaNhanVien") ? reader["MaNhanVien"].ToString() ?? "" : "",
                        MaPhieuDat = columns.Contains("MaPhieuDat") ? reader["MaPhieuDat"].ToString() : "",
                        MaPhieuThue = columns.Contains("MaPhieuThue") ? reader["MaPhieuThue"].ToString() : ""
                    });
                }
            }

            return result;
        }
    }
}
