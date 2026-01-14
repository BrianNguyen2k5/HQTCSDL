using System.Data;
using DTO;
using Microsoft.Data.SqlClient;

namespace DAL
{
    public class KhachHang
    {
        private readonly DatabaseConnection _dbConnection;

        public KhachHang(DatabaseConnection dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public string ThemKhachHang(
            string HoTen = "",
            string NgaySinh = "",
            string SoCCCD = "",
            string SoDienThoai = "",
            string Email = ""
        )
        {
            // VD: KH003 => KH + 003 (int) => Khách hàng tiếp theo KH004
            string getIDQuery = "SELECT MAX(MaKhachHang) FROM KhachHang";
            object result = _dbConnection.ExecuteScalar(getIDQuery);
            string maKhachHangMax =
                result != null && result != DBNull.Value ? result.ToString() : "";

            string maKhachHangMoi = "KH001"; // Default nếu chưa có ai

            if (!string.IsNullOrEmpty(maKhachHangMax))
            {
                // Cắt ra để lấy MaKhachHang tiep theo, VD: KH003
                // Logic đơn giản: Lấy 3 số cuối
                if (maKhachHangMax.Length > 2)
                {
                    string numberPart = maKhachHangMax.Substring(2); // Bỏ chữ 'KH'
                    if (int.TryParse(numberPart, out int soKhachHang))
                    {
                        soKhachHang++;
                        maKhachHangMoi = "KH" + soKhachHang.ToString("D3");
                    }
                }
            }

            string insertQuery =
                @"
                    INSERT INTO KhachHang (MaKhachHang, HoTen, NgaySinh, SoCCCD, SoDienThoai, Email)
                    VALUES (@MaKhachHang, @HoTen, @NgaySinh, @SoCCCD, @SoDienThoai, @Email)
                ";

            object hoTenParam = !string.IsNullOrEmpty(HoTen) ? HoTen : DBNull.Value;

            object ngaySinhParam = DBNull.Value;
            if (!string.IsNullOrEmpty(NgaySinh) && DateTime.TryParse(NgaySinh, out DateTime dtSinh))
            {
                ngaySinhParam = dtSinh;
            }
            object cccdParam = !string.IsNullOrEmpty(SoCCCD) ? SoCCCD : DBNull.Value;
            object sdtParam = !string.IsNullOrEmpty(SoDienThoai) ? SoDienThoai : DBNull.Value;
            object emailParam = !string.IsNullOrEmpty(Email) ? Email : DBNull.Value;

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaKhachHang", maKhachHangMoi),
                new SqlParameter("@HoTen", hoTenParam),
                new SqlParameter("@NgaySinh", ngaySinhParam),
                new SqlParameter("@SoCCCD", cccdParam),
                new SqlParameter("@SoDienThoai", sdtParam),
                new SqlParameter("@Email", emailParam),
            };

            try
            {
                _dbConnection.ExecuteNonQuery(insertQuery, parameters);
                return maKhachHangMoi;
            }
            catch (Exception ex)
            {
                return "Thất bại";
            }
        }
    }
}
