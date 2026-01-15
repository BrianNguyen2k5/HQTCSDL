using System.Data;
using DAL;
using DTO;
using Microsoft.Data.SqlClient;

namespace DAL
{
    public class TaiKhoan
    {
        private readonly DatabaseConnection _dbConnection;
        private readonly KhachHang _khachHang;

        public TaiKhoan(DatabaseConnection dbConnection, KhachHang khachHang)
        {
            _dbConnection = dbConnection;
            _khachHang = khachHang;
        }

        public DTO.TaiKhoan? KiemTraDangNhap(string tenDangNhap, string matKhau)
        {
            // 1. Tìm user theo TenDangNhap trươc
            string query =
                @"
                SELECT tk.*
                FROM TaiKhoan tk
                WHERE tk.TenDangNhap = @TenDangNhap 
                AND tk.TrangThai = 1";

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@TenDangNhap", tenDangNhap),
            };

            DataTable dt = _dbConnection.ExecuteQuery(query, parameters);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                string storedHash = row["MatKhauMaHoa"].ToString().Trim();

                // 2. Dùng BCrypt để kiểm tra mật khẩu
                bool isPasswordValid = false;

                try
                {
                    isPasswordValid = BCrypt.Net.BCrypt.Verify(matKhau, storedHash);
                }
                catch
                {
                    // Không phải hash BCrypt hợp lệ
                    isPasswordValid = false;
                }

                if (isPasswordValid)
                {
                    return new DTO.TaiKhoan
                    {
                        id = Convert.ToInt32(row["id"]),
                        TenDangNhap = row["TenDangNhap"].ToString() ?? "",
                        MatKhauMaHoa = storedHash ?? "",
                        Email = row["Email"].ToString() ?? "",
                        TrangThai =
                            row["TrangThai"] != DBNull.Value && Convert.ToBoolean(row["TrangThai"]),
                        NgayTao =
                            row["NgayTao"] != DBNull.Value
                                ? Convert.ToDateTime(row["NgayTao"])
                                : null,
                        MaKhachHang =
                            row["MaKhachHang"] != DBNull.Value
                                ? row["MaKhachHang"].ToString()
                                : null,
                        MaNhanVien =
                            row["MaNhanVien"] != DBNull.Value ? row["MaNhanVien"].ToString() : null,
                    };
                }
            }

            return null;
        }

        public bool ThemTaiKhoan(string username, string email, string passwordRaw)
        {
            // 0. Tạo Khách hàng trước
            string maKhachHangMoi = _khachHang.ThemKhachHang(Email: email);

            if (maKhachHangMoi == "Thất bại")
                return false;

            // 1. MÃ HÓA MẬT KHẨU TRƯỚC
            string hashPassword = BCrypt.Net.BCrypt.HashPassword(passwordRaw);

            // 2. LƯU VÀO DATABASE
            // Lưu ý: Cột MaKhachHang và MaNhanVien cho phép NULL.
            // Khi đăng ký mới -> Chưa có MaKH/MaNV -> Để NULL.
            string query =
                @"INSERT INTO TaiKhoan (TenDangNhap, MatKhauMaHoa, Email, TrangThai, NgayTao, MaKhachHang, MaNhanVien) 
                  VALUES (@user, @pass, @email, 1, GETDATE(), @MaKH, NULL)";

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", hashPassword),
                new SqlParameter("@email", email),
                new SqlParameter("@MaKH", maKhachHangMoi),
            };

            try
            {
                return _dbConnection.ExecuteNonQuery(query, parameters) > 0;
            }
            catch
            {
                // Có thể log lỗi trùng tên đăng nhập hoặc email tại đây
                return false;
            }
        }

        public string? LayChucVu(string maNhanVien)
        {
            if (string.IsNullOrEmpty(maNhanVien))
                return "KhachHang";

            string query =
                @"
                SELECT cv.TenChucVu 
                FROM NhanVien nv 
                JOIN ChucVu cv ON nv.MaChucVu = cv.MaChucVu 
                WHERE nv.MaNhanVien = @MaNV";
            SqlParameter[] parameters = { new SqlParameter("@MaNV", maNhanVien) };

            object? result = _dbConnection.ExecuteScalar(query, parameters);
            return result != null ? result.ToString() : "NhanVien";
        }

        public string? LayMaCoSo(string maNhanVien)
        {
            if (string.IsNullOrEmpty(maNhanVien))
                return null;

            string query =
                @"
                SELECT MaCoSo 
                FROM NhanVien 
                WHERE MaNhanVien = @MaNV";
            
            SqlParameter[] parameters = { new SqlParameter("@MaNV", maNhanVien) };
            object? result = _dbConnection.ExecuteScalar(query, parameters);
            return result?.ToString();
        }
    }
}
