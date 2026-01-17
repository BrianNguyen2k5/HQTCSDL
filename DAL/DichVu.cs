using System.Data;
using DTO;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace DAL
{
  public class DichVuDAL : DatabaseConnection
  {
    public DichVuDAL(IConfiguration configuration)
        : base(configuration) { }

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
        danhSach.Add(
            new DTO.DichVu
            {
              MaDichVu = reader["MaDichVu"].ToString() ?? string.Empty,
              TenDichVu = reader["TenDichVu"].ToString() ?? string.Empty,
              LoaiDichVu = reader["LoaiDichVu"].ToString() ?? string.Empty,
              DonGia = reader.GetInt32(reader.GetOrdinal("DonGia")),
              DonViTinh = reader["DonViTinh"].ToString() ?? string.Empty,
              SoLuongTonKho = reader.GetInt32(reader.GetOrdinal("SoLuongTonKho")),
            }
        );
      }

      return danhSach;
    }

    public List<DTO.DichVu> LayTongDanhSachDV()
    {
      List<DTO.DichVu> danhSach = new List<DTO.DichVu>();

      using SqlConnection conn = new SqlConnection(_connectionString);
      conn.Open();

      string query =
        @"
          select * from DichVu
        ";

      using SqlCommand cmd = new SqlCommand(query, conn);
      cmd.CommandType = CommandType.Text;

      using SqlDataReader reader = cmd.ExecuteReader();
      while (reader.Read())
      {
        danhSach.Add(
            new DTO.DichVu
            {
              MaDichVu = reader["MaDichVu"].ToString() ?? string.Empty,
              TenDichVu = reader["TenDichVu"].ToString() ?? string.Empty,
              LoaiDichVu = reader["LoaiDichVu"].ToString() ?? string.Empty,
              DonGia = reader.GetInt32(reader.GetOrdinal("DonGia")),
              DonViTinh = reader["DonViTinh"].ToString() ?? string.Empty,
							SoLuongTonKho = 0
            }
        );
      }

      return danhSach;
    }

    public bool UpdateGiaDichVu(string maDichVu, int giaMoi)
    {
      try
      {
        using SqlConnection conn = new SqlConnection(_connectionString);
        conn.Open();
        string query = "sp_CapNhatGiaDV";
        using SqlCommand cmd = new SqlCommand(query, conn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@giamoi", giaMoi);
        cmd.Parameters.AddWithValue("@madv", maDichVu);
        int rows = cmd.ExecuteNonQuery();
        return rows > 0;
      }
      catch
      {
        return false;
      }
    }
  }
}
