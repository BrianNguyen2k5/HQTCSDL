using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

public class AuthController : Controller
{
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
		// 1. Gọi BLL kiểm tra username/pass (Logic của bạn nằm ở đây)
		// ...

		// Ví dụ giả lập:
		if (loginId == "admin" && password == "123")
		{
			// 2. Tạo "Thẻ căn cước" (Claims) cho user
			var claims = new List<Claim>
			{
				new Claim(ClaimTypes.Name, loginId),
				new Claim(ClaimTypes.Role, "QuanLy") // Ví dụ role
			};

			var identity = new ClaimsIdentity(claims, "MyCookieAuth");
			var principal = new ClaimsPrincipal(identity);

			// 3. Ghi Cookie vào trình duyệt (Đăng nhập thành công)
			await HttpContext.SignInAsync("MyCookieAuth", principal);

			// 4. Chuyển hướng về trang Dashboard
			return RedirectToAction("Dashboard", "Employer");
		}

		ViewBag.Error = "Sai tài khoản hoặc mật khẩu";
		return View();
	}

	[Route("logout")]
	public async Task<IActionResult> Logout()
	{
		await HttpContext.SignOutAsync("MyCookieAuth");
		return RedirectToAction("Login");
	}
}