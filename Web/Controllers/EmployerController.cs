using DAL;
using HQTCSDL.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace HQTCSDL.Web.Controllers
{
  [Authorize(Roles = "Quản lý")]
  public class EmployerController : Controller
  {
    private readonly Dashboard _dashboardDAL;
		private readonly DichVuDAL _dichVuDAL;
		private readonly CoSo _coSoDAL;

    public EmployerController(Dashboard dashboardDAL, DichVuDAL dichVuDAL, CoSo coSoDAL)
    {
      _dashboardDAL = dashboardDAL;
			_dichVuDAL = dichVuDAL;
			_coSoDAL = coSoDAL;
    }

    public IActionResult Dashboard()
    {
      return View();
    }

    public IActionResult Employees()
    {
      return View();
    }

    public IActionResult Arrangement()
    {
      return View();
    }

    public IActionResult Modification()
    {
      var loaiSanList = _dashboardDAL.GetDanhSachLoaiSan() ?? new List<DTO.LoaiSan>();
      var dichVuList = _dichVuDAL.LayTongDanhSachDV() ?? new List<DTO.DichVu>();
      
      var viewModel = new ModificationViewModel
      {
          LoaiSanList = loaiSanList,
          DichVuList = dichVuList
      };

      return View(viewModel);
    }

    public IActionResult Report()
    {
      var coSoList = _coSoDAL.LayTongDanhSachCoSo() ?? new List<DTO.CoSo>();
      return View(coSoList);
    }

    public IActionResult Profile()
    {
      return View();
    }

    [HttpGet]
    public IActionResult GetRevenueReport(int nam, int? thang, int? ngay)
    {
      try
      {
        // Gọi hàm DAL vừa viết ở trên
        decimal doanhThu = _dashboardDAL.GetDoanhThu(nam, thang, ngay);
        // Trả về JSON để Javascript cập nhật giao diện mà không cần load lại trang
        return Json(
            new
            {
              success = true,
              value = doanhThu,
              formatted = doanhThu.ToString("N0") + " VND"
            }
        );
      }
      catch (Exception ex)
      {
        return Json(new { success = false, message = ex.Message });
      }
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
      try 
      {
          if (req.NewPrice <= 10000)
          {
            return BadRequest(new { message = "Bạn đang cài giá thuê quá thấp" });
          }

          bool result = _dashboardDAL.UpdateGiaSan(req.MaLoaiSan, req.NewPrice);
          if (result == true)
          {
            return Ok(new { success = true, message = "Cập nhật thành công" });
          }
          return BadRequest(new { success = false, message = "Cập nhật thất bại" });
      }
      catch (Exception ex)
      {
          return BadRequest(new { success = false, message = ex.Message });
      }
    }

		[HttpGet]
		public IActionResult GetServicesList() {
			try {
				var list = _dichVuDAL.LayTongDanhSachDV();
				return Json(new { success = true, data = list });
			}
			catch (Exception ex) {
				return Json(new { success = false, message = ex.Message });
			}
		}

		public class UpdateServicePriceRequest {
			public string MaDichVu { get; set; }
			public int NewPrice { get; set; }
		}
		
		[HttpPatch]
		public IActionResult UpdateServicePrice([FromBody] UpdateServicePriceRequest req) {
			try {
				if(req.NewPrice <= 10000) return BadRequest(new { success = false, message = "Giá phải lớn hơn 1,000 VND!" });
				
				bool result = _dichVuDAL.UpdateGiaDichVu(req.MaDichVu, req.NewPrice);
				if(result) return Ok(new { success = true, message = "Cập nhật thành công!" });
				return BadRequest(new { success = false, message = "Cập nhật thất bại!" });
			}
			catch(Exception ex) {
				return BadRequest(new { success = false, message = ex.Message });
			}
		}

		[HttpGet]
		public IActionResult GetCoSoList() {
			try {
				var list = _coSoDAL.LayTongDanhSachCoSo();
				return Json(new { success = true, data = list });
			}
			catch (Exception ex) {
				return Json(new { success = false, message = ex.Message });
			}
		}

		[HttpGet]
		public IActionResult GetRevenueByCoSo(string maCoSo, int nam) {
			try {
				var list = _coSoDAL.LayDoanhThuTheoCoSo(maCoSo, nam);
				return Json(new { success = true, data = list });
			}
			catch (Exception ex) {
				return Json(new { success = false, message = ex.Message });
			}
		}
  }
}
