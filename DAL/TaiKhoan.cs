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
                // Lưu ý: Nếu DB của bạn đang lưu pass thường (chưa hash), lệnh Verify này sẽ false.
                // Tạm thời để test với pass thường, bạn có thể dùng: if (storedHash == matKhau)
                // Nhưng đúng chuẩn BCrypt phải là:
                bool isPasswordValid = false;

                // CHECK TẠM THỜI: Hỗ trợ cả pass thường (cho dữ liệu cũ) và pass đã hash
                if (storedHash == matKhau)
                {
                    isPasswordValid = true;
                }
                else
                {
                    try
                    {
                        isPasswordValid = BCrypt.Net.BCrypt.Verify(matKhau, storedHash);
                    }
                    catch
                    { /* Không phải hash BCrypt hợp lệ */
                    }
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

        public string ThemTaiKhoan(string username, string email, string passwordRaw)
        {
             // 0. CHECK DUPLICATES IN TAIKHOAN
            string checkUserQuery = "SELECT COUNT(*) FROM TaiKhoan WHERE TenDangNhap = @user";
            SqlParameter[] userParams = { new SqlParameter("@user", username) };
            int userCount = (int)_dbConnection.ExecuteScalar(checkUserQuery, userParams);
            if (userCount > 0) return "Tên đăng nhập đã tồn tại";

            string checkEmailQuery = "SELECT COUNT(*) FROM TaiKhoan WHERE Email = @email";
            SqlParameter[] emailParams = { new SqlParameter("@email", email) };
            int emailCount = (int)_dbConnection.ExecuteScalar(checkEmailQuery, emailParams);
            if (emailCount > 0) return "Email đã được sử dụng bởi tài khoản khác";

            // 0. Tạo Khách hàng trước (hoặc lấy ID cũ)
            string maKhachHangMoi = _khachHang.ThemKhachHang(Email: email);

            if (maKhachHangMoi.StartsWith("Thất bại"))
            {
                Console.WriteLine("ThemTaiKhoan -> ThemKhachHang Failed: " + maKhachHangMoi);
                return maKhachHangMoi;
            }

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
                int rows = _dbConnection.ExecuteNonQuery(query, parameters);
                return rows > 0 ? "Success" : "Lỗi: Không thể thêm tài khoản vào database";
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi ThemTaiKhoan (Insert): " + ex.Message);
                return "Lỗi hệ thống: " + ex.Message;
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
    }
}
