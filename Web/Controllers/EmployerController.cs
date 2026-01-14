using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using DAL;
using HQTCSDL.Models;

namespace HQTCSDL.Web.Controllers
{
	[Authorize(Roles = "QuanLy")]
	public class EmployerController : Controller
	{
		private readonly Dashboard _dashboardDAL;
		
		public EmployerController(Dashboard dashboardDAL)
		{
			_dashboardDAL = dashboardDAL;
		}

		public IActionResult Dashboard()
		{
			var list = _dashboardDAL.GetDanhSachLoaiSan() ?? new List<DTO.LoaiSan>(); // Đảm ko null?
			return View(list);
		}

		[HttpGet]
		public IActionResult GetRevenueReport(int nam, int? thang, int? ngay)
		{
			// Gọi hàm DAL vừa viết ở trên
			decimal doanhThu = _dashboardDAL.GetDoanhThu(nam, thang, ngay);
			// Trả về JSON để Javascript cập nhật giao diện mà không cần load lại trang
			return Json(new { success = true, value = doanhThu, formatted = doanhThu.ToString("N0") + " VNĐ" });
		}

		[HttpGet]
		public IActionResult GetStatisticsReport(string type)
		{
			// Gọi hàm DAL vừa viết ở trên
			var report = _dashboardDAL.GetThongKe(type);
			// Trả về JSON để Javascript cập nhật giao diện mà không cần load lại trang
			return Json(new { success = true, data = report });
		}


		[HttpPatch]
		public IActionResult UpdateFieldPrice([FromBody] UpdateFieldPriceRequest req)
		{
			if(req.NewPrice <= 10000) {
				return BadRequest(new {message = "Bạn đang cài giá thuê quá thấp"});
			}

			bool result = _dashboardDAL.UpdateGiaSan(req.MaLoaiSan, req.NewPrice);
			if(result == true)
			{
				return Ok(new {success = true, message = "Cập nhật thành công"});
			}
			return StatusCode(500, new { success = false, message = "Lỗi khi cập nhật"});
		}
	}
}