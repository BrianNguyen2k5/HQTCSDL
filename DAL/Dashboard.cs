using System.Data;
using DTO;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace DAL
{
	public class Dashboard : DatabaseConnection
	{
		public Dashboard(IConfiguration configuration)
				: base(configuration) { }

		public bool UpdateGiaSan(string maLoaiSan, int giaMoi)
		{
			if (giaMoi < 0)
			{
				return false;
			}

			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			string spName = "sp_CapNhatGiaSan";
			using SqlCommand cmd = new SqlCommand(spName, conn);
			cmd.CommandType = CommandType.StoredProcedure;
			
			cmd.Parameters.AddWithValue("@maloaisan", maLoaiSan);
			cmd.Parameters.AddWithValue("@giamoi", giaMoi);
			int rowsAffected = cmd.ExecuteNonQuery();

			return rowsAffected > 0;
		}

		public decimal GetDoanhThu(int nam, int? thang, int? ngay)
		{
			decimal ketQua = 0; // Mặc định là 0

			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			string spName = "";

			// 1. LOGIC CHỌN STORED PROCEDURE
			// Ưu tiên kiểm tra từ chi tiết nhất Ngày -> Tháng -> Năm
			if (ngay.HasValue)
			{
				spName = "sp_QL_DoanhThuNamThangNgay";
			}
			else if (thang.HasValue)
			{
				spName = "sp_QL_DoanhThuNamThang";
			}
			else
			{
				spName = "sp_QL_DoanhThuNam";
			}

			using SqlCommand cmd = new SqlCommand(spName, conn);
			cmd.CommandTimeout = 120; // Chờ tối đa 2 phút để test transaction blocking
			cmd.CommandType = CommandType.StoredProcedure; // Phải là StoredProcedure vì spName là tên SP

			// 2. TRUYỀN THAM SỐ (Parameters)
			// Tham số @nam luôn luôn có
			cmd.Parameters.AddWithValue("@nam", nam);

			// Tham số @thang (chỉ truyền nếu SP cần)
			if (thang.HasValue)
			{
				cmd.Parameters.AddWithValue("@thang", thang);
			}

			// Tham số @ngay (chỉ truyền nếu SP cần)
			if (ngay.HasValue)
			{
				cmd.Parameters.AddWithValue("@ngay", ngay);
			}

			Console.WriteLine("nam: " + nam);
			Console.WriteLine("thang: " + thang);
			Console.WriteLine("ngay: " + ngay);
			Console.WriteLine("spName: " + spName);

			// 3. XỬ LÝ OUTPUT PARAMETER (Phần quan trọng nhất với SP của bạn)
			// Vì SP của bạn trả về qua biến @output, không phải qua câu SELECT
			SqlParameter outputParam = new SqlParameter("@output", SqlDbType.Int);
			outputParam.Direction = ParameterDirection.Output; // Khai báo chiều ra
			cmd.Parameters.Add(outputParam);

			// 4. CHẠY LỆNH
			cmd.ExecuteNonQuery(); // Chỉ cần chạy, không cần đọc bảng

			// 5. LẤY KẾT QUẢ TỪ OUTPUT
			// Kiểm tra DBNull để tránh lỗi nếu không có doanh thu (NULL)
			return Convert.ToDecimal(outputParam.Value);
		}

		public decimal GetThongKe(string type)
		{
			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			string query = "select * from dbo.F_ThongKeSoLuong()";
			using SqlCommand cmd = new SqlCommand(query, conn);
			cmd.CommandType = CommandType.Text; // QUAN TRỌNG: Báo đây là FUNCTION

			using SqlDataReader reader = cmd.ExecuteReader();
			string returnType = "";
			int returnValue = 0;
			while (reader.Read())
			{
				returnType = reader.GetString(0);
				returnValue = reader.GetInt32(1);

				if (returnType == type)
				{
					return returnValue;
				}
			}
			return -1;
		}

		public List<LoaiSan> GetDanhSachLoaiSan()
		{
			var danhSach = new List<LoaiSan>();
			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			string query = "select * from dbo.F_DanhSachGiaLoaiSan()";
			using SqlCommand cmd = new SqlCommand(query, conn);
			cmd.CommandType = CommandType.Text;

			using SqlDataReader reader = cmd.ExecuteReader();
			while (reader.Read())
			{
				var data = new LoaiSan()
				{
					MaLoaiSan = reader.GetString(0),
					TenLoaiSan = reader.GetString(1),
					DonViTinhTheoPhut = reader.GetInt32(2),
					GiaGoc = reader.GetInt32(3),
					MoTa = reader.GetString(4),
				};

				danhSach.Add(data);
			}

			return danhSach;
		}

		public class PhieuHuyResult
		{
			public int tongSoPhieu { get; set; }
			public List<DTO.DanhSachPhieuHuy> dsPhieuHuy { get; set; } = new List<DTO.DanhSachPhieuHuy>();
		}

		public PhieuHuyResult GetDanhSachPhieuHuy (int nam)
		{
			var result = new PhieuHuyResult(); 
			using var conn = new SqlConnection(_connectionString);
			conn.Open();
			using var cmd = new SqlCommand("sp_ChiTietThongKePhieuHuy", conn);
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.Parameters.AddWithValue("@nam", nam);

			using var reader = cmd.ExecuteReader();
			if (reader.Read())
			{
				// Result set đầu tiên chỉ có 1 cột: COUNT(*) AS SoLuong => index 0
				result.tongSoPhieu = reader.GetInt32(0);
			}
			// Danh sách phiếu
			if (reader.NextResult())
			{
				while(reader.Read())
				{
					result.dsPhieuHuy.Add(new DTO.DanhSachPhieuHuy
					{
						MaPhieuDat = reader.GetString(0),
						NgayDat = reader.GetDateTime(1),
						NgayNhanSan = reader.GetDateTime(2),
						HinhThucDat = reader.GetString(3),
					});
				}

				return result;
			}
			return null;
		}
	
		public List<DTO.PhieuDatSimple> GetDanhSachPhieuDat()
		{
			var danhSach = new List<DTO.PhieuDatSimple>();
			using SqlConnection conn = new SqlConnection(_connectionString);
			conn.Open();

			string spName = "sp_LayPhieuDatSan";
			using SqlCommand cmd = new SqlCommand(spName, conn);
			cmd.CommandType = CommandType.StoredProcedure;

			using SqlDataReader reader = cmd.ExecuteReader();
			while (reader.Read())
			{
				var data = new DTO.PhieuDatSimple()
				{
					MaPhieuDat = reader.GetString(0),
					NguoiDat = reader.GetString(1),
					NgayDat = reader.GetDateTime(2),
					HinhThucDat = reader.GetString(3),
					TrangThaiPhieu = reader.GetString(4),
				};

				danhSach.Add(data);
			}

			return danhSach;
		}
	}
}
