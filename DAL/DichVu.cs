using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using DTO;

namespace DAL
{
	public class DichVuDAL : DatabaseConnection
	{
		public DichVuDAL(IConfiguration configuration) : base(configuration)
		{
		}

		public List<DTO.DichVu> LayDanhSachDichVu(string maCoSo)
		{
			List<DTO.DichVu> danhSach = new List<DTO.DichVu>();

			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			using SqlCommand cmd = new SqlCommand("SP_LayDanhSachDichVu", conn);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@MaCoSo", maCoSo);

			using SqlDataReader reader = cmd.ExecuteReader();
			while (reader.Read())
			{
				danhSach.Add(new DTO.DichVu
				{
					MaDichVu = reader["MaDichVu"].ToString() ?? string.Empty,
					TenDichVu = reader["TenDichVu"].ToString() ?? string.Empty,
					LoaiDichVu = reader["LoaiDichVu"].ToString() ?? string.Empty,
					DonGia = reader.GetInt32(reader.GetOrdinal("DonGia")),
					DonViTinh = reader["DonViTinh"].ToString() ?? string.Empty,
					SoLuongTonKho = reader.GetInt32(reader.GetOrdinal("SoLuongTonKho"))
				});
			}

			return danhSach;
		}
	}
}
