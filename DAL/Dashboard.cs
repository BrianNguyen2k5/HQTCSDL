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

            string spName = "SP_ThayDoiGiaSan";
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
            // Ưu tiên kiểm tra từ chi tiết nhất (Ngày) -> Tháng -> Năm
            if (thang.HasValue && ngay.HasValue)
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
            cmd.CommandType = CommandType.StoredProcedure; // QUAN TRỌNG: Báo đây là SP

            // 2. TRUYỀN THAM SỐ (Parameters)
            // Tham số @nam luôn luôn có
            cmd.Parameters.AddWithValue("@nam", nam);

            // Tham số @thang (chỉ truyền nếu SP cần)
            if (thang.HasValue)
            {
                cmd.Parameters.AddWithValue("@thang", thang.Value);
            }

            // Tham số @ngay (chỉ truyền nếu SP cần)
            if (thang.HasValue && ngay.HasValue)
            {
                cmd.Parameters.AddWithValue("@ngay", ngay.Value);
            }

            // 3. XỬ LÝ OUTPUT PARAMETER (Phần quan trọng nhất với SP của bạn)
            // Vì SP của bạn trả về qua biến @output, không phải qua câu SELECT
            SqlParameter outputParam = new SqlParameter("@output", SqlDbType.Int);
            outputParam.Direction = ParameterDirection.Output; // Khai báo chiều ra
            cmd.Parameters.Add(outputParam);

            // 4. CHẠY LỆNH
            cmd.ExecuteNonQuery(); // Chỉ cần chạy, không cần đọc bảng

            // 5. LẤY KẾT QUẢ TỪ OUTPUT
            // Kiểm tra DBNull để tránh lỗi nếu không có doanh thu (NULL)
            if (outputParam.Value != DBNull.Value)
            {
                ketQua = Convert.ToDecimal(outputParam.Value);
            }

            return ketQua;
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
    }
}
