using System;
using System.Data;
using Microsoft.Data.SqlClient;

class Program
{
    // Cấu hình database
    const string CONNECTION_STRING = "Server=localhost,1433;Database=VietSport;User Id=sa;Password=MyStrongPass123;TrustServerCertificate=True;MultipleActiveResultSets=true";
    
    // Danh sách nhân viên cần tạo tài khoản
    static readonly string[] TARGET_EMPLOYEES = { "NV001", "NV006", "NV002", "NV003", "NV009" };
    
    // Mật khẩu gốc cho tất cả tài khoản
    const string RAW_PASSWORD = "123456";

    static void Main(string[] args)
    {
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine("TẠO TÀI KHOẢN NHÂN VIÊN - BCRYPT TOOL");
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine($"Mật khẩu mặc định: {RAW_PASSWORD}");
        Console.WriteLine($"Số lượng tài khoản: {TARGET_EMPLOYEES.Length}");
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine();

        // Tạo tài khoản vào database
        CreateAccounts();
    }

    static void CreateAccounts()
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(CONNECTION_STRING))
            {
                conn.Open();
                Console.WriteLine("✓ Kết nối database thành công!");
                Console.WriteLine();
                Console.WriteLine("Bắt đầu tạo tài khoản cho nhân viên...");
                Console.WriteLine();

                // Lấy danh sách nhân viên được chỉ định
                string employeeList = string.Join("','", TARGET_EMPLOYEES);
                string selectQuery = $"SELECT MaNhanVien, HoTen FROM NhanVien WHERE MaNhanVien IN ('{employeeList}') ORDER BY MaNhanVien";
                
                using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                using (SqlDataReader reader = selectCmd.ExecuteReader())
                {
                    var employees = new System.Collections.Generic.List<(string MaNV, string HoTen)>();
                    
                    while (reader.Read())
                    {
                        employees.Add((
                            reader["MaNhanVien"].ToString(),
                            reader["HoTen"].ToString()
                        ));
                    }
                    
                    reader.Close();

                    // Tạo tài khoản cho từng nhân viên
                    string insertQuery = @"
                        INSERT INTO TaiKhoan (TenDangNhap, MatKhauMaHoa, Email, TrangThai, NgayTao, MaNhanVien)
                        VALUES (@Username, @Hash, @Email, 1, GETDATE(), @MaNV)";

                    int successCount = 0;
                    int skipCount = 0;

                    foreach (var emp in employees)
                    {
                        string username = $"nv_{emp.MaNV.ToLower()}";
                        string email = $"{username}@vietsport.com";

                        // Kiểm tra xem tài khoản đã tồn tại chưa
                        string checkQuery = "SELECT COUNT(*) FROM TaiKhoan WHERE MaNhanVien = @MaNV";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@MaNV", emp.MaNV);
                            int count = (int)checkCmd.ExecuteScalar();

                            if (count > 0)
                            {
                                Console.WriteLine($"⊘ Bỏ qua {emp.MaNV} ({emp.HoTen}) - Tài khoản đã tồn tại");
                                skipCount++;
                                continue;
                            }
                        }

                        // Tạo BCrypt hash riêng cho từng tài khoản (mỗi hash sẽ có salt khác nhau)
                        string passwordHash = BCrypt.Net.BCrypt.HashPassword(RAW_PASSWORD, workFactor: 10);

                        // Tạo tài khoản mới
                        try
                        {
                            using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                            {
                                cmd.Parameters.AddWithValue("@Username", username);
                                cmd.Parameters.AddWithValue("@Hash", passwordHash);
                                cmd.Parameters.AddWithValue("@Email", email);
                                cmd.Parameters.AddWithValue("@MaNV", emp.MaNV);

                                cmd.ExecuteNonQuery();
                                Console.WriteLine($"✓ Tạo tài khoản: {username,-15} | {emp.HoTen}");
                                Console.WriteLine($"  Hash: {passwordHash}");
                                successCount++;
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"✗ Lỗi khi tạo tài khoản cho {emp.MaNV}: {ex.Message}");
                        }
                    }

                    Console.WriteLine();
                    Console.WriteLine("=".PadRight(60, '='));
                    Console.WriteLine($"Hoàn thành!");
                    Console.WriteLine($"- Tạo mới: {successCount} tài khoản");
                    Console.WriteLine($"- Bỏ qua: {skipCount} tài khoản");
                    Console.WriteLine($"- Tổng số nhân viên: {employees.Count}");
                    Console.WriteLine("=".PadRight(60, '='));
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Lỗi: {ex.Message}");
            Console.WriteLine($"Chi tiết: {ex.StackTrace}");
        }
    }
}
