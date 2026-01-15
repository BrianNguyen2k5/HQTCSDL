using DAL;
using DTO;
using Microsoft.Extensions.Configuration;

namespace BLL
{
    public class HoaDonBLL
    {
        private readonly HoaDonDAL _hoaDonDAL;

        public HoaDonBLL(IConfiguration configuration)
        {
            _hoaDonDAL = new HoaDonDAL(configuration);
        }

        /// <summary>
        /// Lấy tên cơ sở theo mã cơ sở
        /// </summary>
        public string GetTenCoSo(string maCoSo)
        {
            return _hoaDonDAL.GetTenCoSo(maCoSo);
        }

        // Lấy danh sách hóa đơn với validation
        public List<HoaDonListDTO> GetAllInvoices(string? maCoSo = null, string? trangThai = null)
        {
            // Validate trạng thái nếu có
            if (!string.IsNullOrEmpty(trangThai))
            {
                var validStatuses = new[] { "Chưa thanh toán", "Đã thanh toán" };
                if (!validStatuses.Contains(trangThai))
                {
                    throw new ArgumentException("Trạng thái không hợp lệ");
                }
            }

            return _hoaDonDAL.GetAllInvoices(maCoSo, trangThai);
        }

        // Lấy chi tiết hóa đơn với validation
        public HoaDonDetailDTO? GetInvoiceDetail(int maHoaDon)
        {
            if (maHoaDon <= 0)
            {
                throw new ArgumentException("Mã hóa đơn không hợp lệ");
            }

            var invoice = _hoaDonDAL.GetInvoiceDetail(maHoaDon);
            
            if (invoice == null)
            {
                throw new KeyNotFoundException($"Không tìm thấy hóa đơn với mã {maHoaDon}");
            }

            return invoice;
        }

        // Xử lý thanh toán với validation
        public PaymentResponseDTO ProcessPayment(PaymentRequestDTO request)
        {
            // Validate input
            if (request.MaHoaDon <= 0)
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Mã hóa đơn không hợp lệ"
                };
            }

            if (string.IsNullOrWhiteSpace(request.HinhThucThanhToan))
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Hình thức thanh toán không được để trống"
                };
            }

            var validPaymentMethods = new[] { "Tiền mặt", "Ví điện tử" };
            if (!validPaymentMethods.Contains(request.HinhThucThanhToan))
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Hình thức thanh toán không hợp lệ"
                };
            }

            if (string.IsNullOrWhiteSpace(request.MaNhanVien))
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Mã nhân viên không được để trống"
                };
            }

            // Kiểm tra hóa đơn tồn tại
            var invoice = _hoaDonDAL.GetInvoiceDetail(request.MaHoaDon);
            if (invoice == null)
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Không tìm thấy hóa đơn"
                };
            }

            // Kiểm tra hóa đơn đã thanh toán chưa
            if (invoice.TrangThaiThanhToan == "Đã thanh toán")
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Hóa đơn đã được thanh toán trước đó"
                };
            }

            // Xử lý thanh toán
            return _hoaDonDAL.ProcessPayment(request);
        }

        // Tìm kiếm hóa đơn theo từ khóa
        public List<HoaDonListDTO> SearchInvoices(string keyword, string? maCoSo = null, string? trangThai = null)
        {
            var allInvoices = GetAllInvoices(maCoSo, trangThai);

            if (string.IsNullOrWhiteSpace(keyword))
            {
                return allInvoices;
            }

            keyword = keyword.ToLower();

            return allInvoices.Where(inv =>
                inv.MaHoaDon.ToString().Contains(keyword) ||
                inv.TenKhachHang.ToLower().Contains(keyword) ||
                (inv.SoDienThoai != null && inv.SoDienThoai.Contains(keyword)) ||
                (inv.Email != null && inv.Email.ToLower().Contains(keyword))
            ).ToList();
        }
    }
}
