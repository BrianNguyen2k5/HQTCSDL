using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using DAL;
using DTO;
using Microsoft.Extensions.Configuration;

namespace HQTCSDL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookingController : Controller
    {
        private readonly BookingDAL _bookingDAL;

        public BookingController(IConfiguration configuration)
        {
            _bookingDAL = new BookingDAL(configuration);
        }

        /// <summary>
        /// Get all branches (CoSo) - SP_LayDanhSachChiNhanh
        /// </summary>
        [HttpGet("branches")]
        public IActionResult GetBranches()
        {
            try 
            {
                var branches = _bookingDAL.GetBranches();
                return Ok(branches);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Get all court types (LoaiSan) - SP_LayDanhSachLoaiSan
        /// </summary>
        [HttpGet("sports")]
        public IActionResult GetSports()
        {
            try 
            {
                var courtTypes = _bookingDAL.GetCourtTypes();
                return Ok(courtTypes);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Get courts by branch and sport type - SP_LayDanhSachSan
        /// </summary>
        [HttpGet("courts")]
        public IActionResult GetCourts([FromQuery] string branchId, [FromQuery] string sportId)
        {
            try 
            {
                if (string.IsNullOrEmpty(branchId) || string.IsNullOrEmpty(sportId))
                {
                    return BadRequest(new { message = "branchId and sportId are required" });
                }

                var courts = _bookingDAL.GetCourts(branchId, sportId);
                return Ok(courts);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }


        [HttpGet]
        [Route("/Booking")]
        public IActionResult Index()
        {
            return View("~/Views/Customer/Booking.cshtml");
        }



        /// <summary>
        /// Get all services (DichVu) - SP_LayDanhSachDichVu
        /// </summary>
        [HttpGet("services")]
        public IActionResult GetServices([FromQuery] string branchId)
        {
            try 
            {
                var services = _bookingDAL.GetServices(branchId);
                return Ok(services);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }
        
        /// <summary>
        /// Get booking schedule for a specific date, branch, and sport - SP_LayLichDatSan
        /// </summary>
        [HttpGet("schedule")]
        public IActionResult GetSchedule([FromQuery] string date, [FromQuery] string branchId, [FromQuery] string sportId)
        {
            try 
            {
                if (string.IsNullOrEmpty(date) || string.IsNullOrEmpty(branchId) || string.IsNullOrEmpty(sportId))
                {
                    return BadRequest(new { message = "date, branchId, and sportId are required" });
                }

                var schedule = _bookingDAL.GetBookingSchedule(date, branchId, sportId);
                return Ok(schedule);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Create a new booking - sp_KhachHang_DatSanOnline
        /// </summary>
        [HttpPost("create")]
        public IActionResult CreateBooking([FromBody] BookingRequestDTO request)
        {
            try
            {
                if (string.IsNullOrEmpty(request.MaKhachHang))
                {
                    return BadRequest(new { message = "MaKhachHang is required" });
                }

                if (string.IsNullOrEmpty(request.NgayNhanSan) || 
                    string.IsNullOrEmpty(request.GioBatDau) || 
                    string.IsNullOrEmpty(request.GioKetThuc) ||
                    string.IsNullOrEmpty(request.MaSan))
                {
                    return BadRequest(new { message = "All booking fields are required" });
                }

                var response = _bookingDAL.CreateBooking(request);
                
                if (response.Success)
                {
                    return Ok(response);
                }
                else
                {
                    return BadRequest(response);
                }
            }
            catch(Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Add service to booking - sp_ThemDichVuVaoPhieuDat
        /// </summary>
        [HttpPost("add-service")]
        public IActionResult AddService([FromBody] ServiceAddRequestDTO request)
        {
            try
            {
                if (string.IsNullOrEmpty(request.MaPhieuDat) || 
                    string.IsNullOrEmpty(request.MaDichVu) || 
                    request.SoLuong <= 0)
                {
                    return BadRequest(new { message = "MaPhieuDat, MaDichVu and SoLuong are required" });
                }

                var response = _bookingDAL.AddServiceToBooking(request);
                
                if (response.Success)
                {
                    return Ok(response);
                }
                else
                {
                    return BadRequest(response);
                }
            }
            catch(Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Get customer's booking history - SP_LayLichDatCuaToi
        /// </summary>
        [HttpGet("my-bookings")]
        public IActionResult GetMyBookings([FromQuery] string maKhachHang)
        {
            try
            {
                if (string.IsNullOrEmpty(maKhachHang))
                {
                    return BadRequest(new { message = "maKhachHang is required" });
                }

                var bookings = _bookingDAL.GetMyBookings(maKhachHang);
                return Ok(bookings);
            }
            catch(Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Cancel booking - SP_HuyLichDatSan
        /// </summary>
        [HttpPost("cancel")]
        public IActionResult CancelBooking([FromBody] CancelBookingRequestDTO request)
        {
            try
            {
                if (string.IsNullOrEmpty(request.MaPhieuDat))
                {
                    return BadRequest(new { message = "MaPhieuDat is required" });
                }

                var response = _bookingDAL.CancelBooking(request.MaPhieuDat, request.LyDoHuy);
                
                if (response.Success)
                {
                    return Ok(response);
                }
                else
                {
                    return BadRequest(response);
                }
            }
            catch(Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        /// <summary>
        /// Get coaches by branch
        /// </summary>
        [HttpGet("coaches")]
        public IActionResult GetCoaches([FromQuery] string branchId)
        {
            try 
            {
                if (string.IsNullOrEmpty(branchId))
                {
                    return BadRequest(new { message = "branchId is required" });
                }

                var coaches = _bookingDAL.GetCoaches(branchId);
                return Ok(coaches);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

        [HttpGet("promotions")]
        public IActionResult GetPromotions()
        {
            try 
            {
                var promotions = _bookingDAL.GetPromotions();
                return Ok(promotions);
            } 
            catch (Exception ex) 
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }
        [HttpGet("customer-discounts")]
        public IActionResult GetCustomerDiscounts()
        {
            try
            {
                var userId = User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;
                if (string.IsNullOrEmpty(userId)) return Unauthorized();

                var discounts = _bookingDAL.GetCustomerDiscounts(userId);
                return Ok(discounts);
            }
            catch (Exception ex)
            {
                 return StatusCode(500, new { message = ex.Message });
            }
        }
    }
}
