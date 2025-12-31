using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using DAL;

namespace HQTCSDL.Web.Controllers
{
	[Authorize(Roles = "QuanLy")]
	public class EmployerController : Controller
	{

		private readonly Dashboard _dashboardDAL;
		public EmployerController(IConfiguration config)
		{
			// Lấy chuỗi kết nối từ file appsettings.json
			string connectionString = config.GetConnectionString("VietSport")
				?? throw new InvalidOperationException("Không tìm thấy 'VietSport' trong appsettings.json");

			_dashboardDAL = new Dashboard(connectionString);
		}

		public IActionResult Dashboard()
		{
			return View();
		}

		[HttpGet]
		public IActionResult GetRevenueReport(int nam, int? thang, int? ngay)
		{
			// Gọi hàm DAL vừa viết ở trên
			decimal doanhThu = _dashboardDAL.GetDoanhThu(nam, thang, ngay);
			// Trả về JSON để Javascript cập nhật giao diện mà không cần load lại trang
			return Json(new { success = true, value = doanhThu, formatted = doanhThu.ToString("N0") + " VNĐ" });
		}
	}
}