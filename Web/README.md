Các bước kết nối database vào ASP.NET
Chạy từng câu lệnh sau:

// Chọn đúng folder của project: cd ...
1. dotnet add package Microsoft.EntityFrameworkCore
2. dotnet add package Microsoft.EntityFrameworkCore.SqlServer
3. dotnet add package Microsoft.EntityFrameworkCore.Tools
4. dotnet tool install --global dotnet-ef
// Đảm bảo đã có database chạy trên SSMS
5. dotnet ef dbcontext scaffold "Server=localhost;Database=VietSport;Trusted_Connection=True;TrustServerCertificate=True;" Microsoft.EntityFrameworkCore.SqlServer -o Models -c VietSportContext

Lệnh (5) này tạo:
VietSportContext (DbContext)
Các class entity tương ứng bảng trong thư mục Models

6. Thêm connection string vào appsettings.json:
"""
"ConnectionStrings": {
	"VietSport": "Server=localhost;Database=VietSport;Trusted_Connection=True;TrustServerCertificate=True;"
}
"""

7. Đăng ký DbContext trong Program.cs:
"""
using Microsoft.EntityFrameworkCore;
using newHQTCSDL.Models;

// ...existing code...

builder.Services.AddDbContext<VietSportContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("VietSport")));
//nhớ đặt hàm này sau "var builder = ..."

// ...existing code...
"""

8. Xóa connection string hard‑code trong VietSportContext
"""
// ...existing code...
protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
{
    if (!optionsBuilder.IsConfigured)
    {
        optionsBuilder.UseSqlServer("Server=localhost;Database=VietSport;Trusted_Connection=True;TrustServerCertificate=True;");
    }
}
// ...existing code...
"""


Sử dụng DbContext trong controller
"""
// Ví dụ lấy danh sách nhân viên:
using Microsoft.AspNetCore.Mvc;
using newHQTCSDL.Models;

public class NhanVienController : Controller
{
    private readonly VietSportContext _context;

    public NhanVienController(VietSportContext context)
    {
        _context = context;
    }

    public IActionResult Index()
    {
        var list = _context.NhanViens.ToList();
        return View(list);
    }
}
"""