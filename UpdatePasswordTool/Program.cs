using System;
using System.Data;
using Microsoft.Data.SqlClient;

class Program
{
    // Cấu hình database
    const string CONNECTION_STRING = "Server=localhost,1433;Database=VietSport;User Id=sa;Password=MyStrongPass123;TrustServerCertificate=True;MultipleActiveResultSets=true";
    
    // Danh sách nhân viên cần update
    static readonly string[] EMPLOYEES = { "NV001", "NV006", "NV002", "NV003", "NV009" };
    
    // Mật khẩu gốc
    const string RAW_PASSWORD = "123456";

    static void Main(string[] args)
    {
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine("UPDATE BCRYPT PASSWORD TOOL");
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine($"Mật khẩu gốc: {RAW_PASSWORD}");
        Console.WriteLine($"Số lượng tài khoản cần update: {EMPLOYEES.Length}");
        Console.WriteLine("=".PadRight(60, '='));
        Console.WriteLine();

        // Tạo BCrypt hash
        string passwordHash = BCrypt.Net.BCrypt.HashPassword(RAW_PASSWORD, workFactor: 10);
        Console.WriteLine($"BCrypt Hash được tạo:");
        Console.WriteLine($"{passwordHash}");
        Console.WriteLine();

        // Update vào database
        UpdatePasswords(passwordHash);
    }

    static void UpdatePasswords(string passwordHash)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(CONNECTION_STRING))
            {
                conn.Open();
                Console.WriteLine("✓ Kết nối database thành công!");
                Console.WriteLine();
                Console.WriteLine("Bắt đầu update mật khẩu...");
                Console.WriteLine();

                string query = @"
                    UPDATE TaiKhoan 
                    SET MatKhauMaHoa = @Hash 
                    WHERE MaNhanVien = @MaNV";

                foreach (string maNV in EMPLOYEES)
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Hash", passwordHash);
                        cmd.Parameters.AddWithValue("@MaNV", maNV);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Console.WriteLine($"✓ Đã update mật khẩu cho {maNV}");
                        }
                        else
                        {
                            Console.WriteLine($"✗ Không tìm thấy tài khoản với MaNhanVien = {maNV}");
                        }
                    }
                }

                Console.WriteLine();
                Console.WriteLine("=".PadRight(60, '='));
                Console.WriteLine("Hoàn thành! Tất cả mật khẩu đã được update.");
                Console.WriteLine("=".PadRight(60, '='));
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Lỗi: {ex.Message}");
        }
    }
}
