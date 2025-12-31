using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration; // Cần reference package này để đọc config

namespace DAL
{
	public class NhanVien
	{
		private readonly string _connectionString;

		public NhanVien(IConfiguration configuration)
		{
			_connectionString = configuration.GetConnectionString("VietSport")
				?? throw new InvalidOperationException("Không tìm thấy Connection String 'VietSport'");
		}

		public List<DTO.NhanVien> getAllEmployees()
		{
			var list = new List<DTO.NhanVien>();
			using (SqlConnection conn = new SqlConnection(_connectionString))
			{
				conn.Open();
        string query = "SELECT * FROM NhanVien";

				using SqlCommand cmd = new SqlCommand(query, conn);
				using SqlDataReader reader = cmd.ExecuteReader();

				while(reader.Read())
				{
					list.Add(new DTO.NhanVien
					{
						MaNhanVien = reader.GetString(0),
						HoTen = reader.GetString(1),
						NgaySinh = reader.GetDateTime(2),
						GioiTinh = reader.GetString(3),
						SoCCCD = reader.GetString(4),
						DiaChi = reader.GetString(5),
						SoDienThoai = reader.GetString(6),
						LuongCoBan = reader.GetInt32(7),
						PhuCap = reader.IsDBNull(8) ? null : reader.GetInt32(8),
						NgayVaoLam = reader.GetDateTime(9),
						TrangThai = reader.GetString(10),
						MaQuanLy = reader.IsDBNull(11) ? null : reader.GetString(11),
						MaCoSo = reader.GetString(12),
						MaChucVu = reader.GetString(13)
					});
				}
			}
			return list;
		}
	}
}
