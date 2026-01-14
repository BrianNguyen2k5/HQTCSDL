using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

public class AuthController : Controller
{
    private readonly IConfiguration _configuration;
    private readonly DAL.TaiKhoan _taiKhoanDAL;

    public AuthController(IConfiguration configuration, DAL.TaiKhoan taiKhoanDAL)
    {
        _configuration = configuration;
        _taiKhoanDAL = taiKhoanDAL;
    }

    [HttpGet]
    [Route("login")]
    public IActionResult Login()
    {
        return View(); // Trả về form đăng nhập
    }

    [HttpPost]
    [Route("login")]
    public async Task<IActionResult> Login(string loginId, string password)
    {
        // 1. Gọi BLL/DAL kiểm tra username/pass
        var user = _taiKhoanDAL.KiemTraDangNhap(loginId, password);
        if (user != null)
        {
            Console.WriteLine($"User: {user.TenDangNhap} - KH: {user.MaKhachHang}");
        }
        else
        {
            Console.WriteLine("User NULL (Login failed)");
        }

        if (user != null)
        {
            // 2. Xác định Role
            string role = "Khách hàng";
            if (!string.IsNullOrEmpty(user.MaNhanVien))
            {
                role = _taiKhoanDAL.LayChucVu(user.MaNhanVien) ?? "Nhân viên";
            }

            // 3. Tạo Token JWT
            string userId = !string.IsNullOrEmpty(user.MaNhanVien)
                ? user.MaNhanVien
                : (user.MaKhachHang ?? "");
            var token = GenerateJwtToken(user.TenDangNhap, role, userId);
            // role: Quản lý, Lễ tân, Kỹ thuật, Thu ngân, Huấn luyện viên, Khách hàng
            // If role = Nhân viên: Nhân viên chưa có chức vụ gì cả

            // 4. Lưu Token vào Cookie
            Response.Cookies.Append(
                "JwtToken",
                token,
                new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true, // Chỉ chạy trên HTTPS
                    SameSite = SameSiteMode.Strict,
                    Expires = DateTime.UtcNow.AddHours(1),
                }
            );

            // 5. Tạo "Thẻ căn cước" (Claims) cho Cookie Auth (MVC)
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.TenDangNhap),
                new Claim(ClaimTypes.Role, role),
                new Claim("UserId", userId),
            };

            // Add MaCoSo for employees
            if (!string.IsNullOrEmpty(user.MaNhanVien))
            {
                string? maCoSo = _taiKhoanDAL.LayMaCoSo(user.MaNhanVien);
                if (!string.IsNullOrEmpty(maCoSo))
                {
                    claims.Add(new Claim("MaCoSo", maCoSo));
                }
            }

            var identity = new ClaimsIdentity(claims, "MyCookieAuth");
            var principal = new ClaimsPrincipal(identity);

            // 6. Ghi Cookie Auth vào trình duyệt
            await HttpContext.SignInAsync("MyCookieAuth", principal);

            // 7. Chuyển hướng trang
            Console.WriteLine($"LOGIN SUCCESS: {user.id}");

            if (role == "Quản lý")
            {
                return RedirectToAction("Dashboard", "Employer");
            }
            else if (role == "Lễ tân")
            {
                return RedirectToAction("Dashboard", "Receptionist");
            }
            else if (role == "Kỹ thuật")
            {
                return RedirectToAction("", "Technician");
            }
            else if (role == "Thu ngân")
            {
                return RedirectToAction("Index", "Cashier");
            }
            else if (role == "Huấn luyện viên")
            {
                return RedirectToAction("", "Gymnast");
            }

            return RedirectToAction("Index", "Home");
        }

        ViewBag.Error = "Sai tài khoản hoặc mật khẩu";
        return View();
    }

    [Route("register")]
    [HttpGet]
    public IActionResult Register()
    {
        return View();
    }

    [Route("register")]
    [HttpPost]
    public IActionResult Register(string username, string email, string password)
    {
        if (
            string.IsNullOrEmpty(username)
            || string.IsNullOrEmpty(email)
            || string.IsNullOrEmpty(password)
        )
        {
            ViewBag.Error = "Vui lòng nhập đầy đủ thông tin";
            return View();
        }

        bool result = _taiKhoanDAL.ThemTaiKhoan(username, email, password);

        if (result)
        {
            // Đăng ký thành công -> Chuyển qua trang login
            return RedirectToAction("Login");
        }
        else
        {
            ViewBag.Error = "Đăng ký thất bại. Tên đăng nhập hoặc Email có thể đã tồn tại.";
            return View();
        }
    }

    [Route("logout")]
    public async Task<IActionResult> Logout()
    {
        // Xóa Cookie Auth
        await HttpContext.SignOutAsync("MyCookieAuth");

        // Xóa Cookie JWT
        Response.Cookies.Delete("JwtToken");

        return RedirectToAction("Login");
    }

    private string GenerateJwtToken(string username, string role, string userId)
    {
        var jwtSettings = _configuration.GetSection("Jwt");
        var key = Encoding.UTF8.GetBytes(jwtSettings["Key"]);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, username),
            new Claim(ClaimTypes.Role, role),
            new Claim("UserId", userId), // Lưu MaNhanVien hoặc MaKhachHang vào token
        };

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddHours(1),
            Issuer = jwtSettings["Issuer"],
            Audience = jwtSettings["Audience"],
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(key),
                SecurityAlgorithms.HmacSha256Signature
            ),
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
