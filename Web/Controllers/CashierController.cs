using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using BLL;
using DTO;

namespace HQTCSDL.Controllers
{
    [Authorize(Roles = "Thu ngân")]
    public class CashierController : Controller
    {
        private readonly HoaDonBLL _hoaDonBLL;

        public CashierController(IConfiguration configuration)
        {
            _hoaDonBLL = new HoaDonBLL(configuration);
        }

        // Helper method to get MaCoSo from claims
        private string GetMaCoSo()
        {
            var maCoSo = User.FindFirst("MaCoSo")?.Value;
            if (string.IsNullOrEmpty(maCoSo))
            {
                // Fallback if not logged in or claim not available
                return "CS01"; // Default branch
            }
            return maCoSo;
        }

        // Helper method to get MaNhanVien from claims
        private string GetMaNhanVien()
        {
            var maNhanVien = User.FindFirst("MaNhanVien")?.Value;
            if (string.IsNullOrEmpty(maNhanVien))
            {
                // This should not happen for authenticated users
                throw new UnauthorizedAccessException("Không tìm thấy thông tin nhân viên");
            }
            return maNhanVien;
        }

        // GET: /Cashier
        // GET: /Cashier/Index
        public IActionResult Bill()
        {
            // Get branch name for display
            var maCoSo = GetMaCoSo();
            Console.WriteLine($"DEBUG - MaCoSo: {maCoSo}");
            
            var tenCoSo = _hoaDonBLL.GetTenCoSo(maCoSo);
            Console.WriteLine($"DEBUG - TenCoSo: {tenCoSo}");
            
            ViewBag.TenCoSo = tenCoSo;
            return View();
        }

        /// <summary>
        /// Lấy danh sách hóa đơn của cơ sở mà nhân viên thu ngân đang làm việc
        /// </summary>
        /// <param name="trangThai">Trạng thái thanh toán (optional): "Chưa thanh toán" hoặc "Đã thanh toán"</param>
        /// <param name="keyword">Từ khóa tìm kiếm (optional)</param>
        /// <returns>Danh sách hóa đơn</returns>
        [HttpGet]
        [Route("/api/cashier/invoices")]
        public IActionResult GetInvoices(
            [FromQuery] string? trangThai = null,
            [FromQuery] string? keyword = null)
        {
            try
            {
                // Always use logged-in cashier's branch
                string maCoSo = GetMaCoSo();
                List<HoaDonListDTO> invoices;

                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    invoices = _hoaDonBLL.SearchInvoices(keyword, maCoSo, trangThai);
                }
                else
                {
                    invoices = _hoaDonBLL.GetAllInvoices(maCoSo, trangThai);
                }

                return Ok(new
                {
                    success = true,
                    data = invoices,
                    count = invoices.Count
                });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new
                {
                    success = false,
                    message = ex.Message
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Lỗi server: " + ex.Message
                });
            }
        }

        /// <summary>
        /// Lấy chi tiết hóa đơn
        /// </summary>
        /// <param name="id">Mã hóa đơn</param>
        /// <returns>Chi tiết hóa đơn</returns>
        [HttpGet]
        [Route("/api/cashier/invoices/{id}")]
        public IActionResult GetInvoiceDetail(int id)
        {
            try
            {
                var invoice = _hoaDonBLL.GetInvoiceDetail(id);

                return Ok(new
                {
                    success = true,
                    data = invoice
                });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new
                {
                    success = false,
                    message = ex.Message
                });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new
                {
                    success = false,
                    message = ex.Message
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Lỗi server: " + ex.Message
                });
            }
        }

        /// <summary>
        /// Xử lý thanh toán hóa đơn
        /// </summary>
        /// <param name="id">Mã hóa đơn</param>
        /// <param name="request">Thông tin thanh toán</param>
        /// <returns>Kết quả thanh toán</returns>
        [HttpPost]
        [Route("/api/cashier/invoices/{id}/payment")]
        public IActionResult ProcessPayment(int id, [FromBody] PaymentRequestDTO request)
        {
            try
            {
                // Đảm bảo ID trong URL khớp với ID trong body
                if (request.MaHoaDon != id)
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = "Mã hóa đơn không khớp"
                    });
                }

                // Lấy mã nhân viên từ user đang đăng nhập
                request.MaNhanVien = GetMaNhanVien();

                var result = _hoaDonBLL.ProcessPayment(request);

                if (result.Success)
                {
                    return Ok(new
                    {
                        success = true,
                        data = result,
                        message = result.Message
                    });
                }
                else
                {
                    return BadRequest(new
                    {
                        success = false,
                        message = result.Message
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Lỗi server: " + ex.Message
                });
            }
        }

        /// <summary>
        /// Lấy thống kê hóa đơn của cơ sở mà nhân viên thu ngân đang làm việc
        /// </summary>
        /// <returns>Thống kê hóa đơn</returns>
        [HttpGet]
        [Route("/api/cashier/statistics")]
        public IActionResult GetStatistics()
        {
            try
            {
                // Always use logged-in cashier's branch
                string maCoSo = GetMaCoSo();
                var allInvoices = _hoaDonBLL.GetAllInvoices(maCoSo);

                var statistics = new
                {
                    tongSoHoaDon = allInvoices.Count,
                    chuaThanhToan = allInvoices.Count(i => i.TrangThaiThanhToan == "Chưa thanh toán"),
                    daThanhToan = allInvoices.Count(i => i.TrangThaiThanhToan == "Đã thanh toán"),
                    tongDoanhThu = allInvoices.Where(i => i.TrangThaiThanhToan == "Đã thanh toán").Sum(i => i.TongThanhToan),
                    doanhThuChuaThu = allInvoices.Where(i => i.TrangThaiThanhToan == "Chưa thanh toán").Sum(i => i.TongThanhToan)
                };

                return Ok(new
                {
                    success = true,
                    data = statistics
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Lỗi server: " + ex.Message
                });
            }
        }
    }
}
