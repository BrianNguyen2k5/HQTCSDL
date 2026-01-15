using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using DTO;

namespace DAL
{
    public class HoaDonDAL : DatabaseConnection
    {
        public HoaDonDAL(IConfiguration configuration) : base(configuration)
        {
        }

        /// <summary>
        /// Lấy tên cơ sở theo mã cơ sở
        /// </summary>
        public string GetTenCoSo(string maCoSo)
        {
            var parameter = new SqlParameter("@MaCoSo", maCoSo);
            var dt = ExecuteQuery("SELECT TenCoSo FROM CoSo WHERE MaCoSo = @MaCoSo", new[] { parameter });
            
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0]["TenCoSo"].ToString() ?? "Cơ sở";
            }
            
            return "Cơ sở";
        }

        // Lấy danh sách hóa đơn
        public List<HoaDonListDTO> GetAllInvoices(string? maCoSo = null, string? trangThai = null)
        {
            var invoices = new List<HoaDonListDTO>();
            
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@MaCoSo", (object?)maCoSo ?? DBNull.Value),
                new SqlParameter("@TrangThai", (object?)trangThai ?? DBNull.Value)
            };

            var dt = ExecuteQuery("EXEC sp_GetAllInvoices @MaCoSo, @TrangThai", parameters);

            foreach (DataRow row in dt.Rows)
            {
                invoices.Add(new HoaDonListDTO
                {
                    MaHoaDon = Convert.ToInt32(row["MaHoaDon"]),
                    NgayXuat = Convert.ToDateTime(row["NgayXuat"]),
                    TongTienSan = Convert.ToInt32(row["TongTienSan"]),
                    TongTienDichVu = Convert.ToInt32(row["TongTienDichVu"]),
                    TongTienGiamGia = Convert.ToInt32(row["TongTienGiamGia"]),
                    TongThanhToan = Convert.ToInt32(row["TongThanhToan"]),
                    HinhThucThanhToan = row["HinhThucThanhToan"] as string,
                    TrangThaiThanhToan = row["TrangThaiThanhToan"].ToString() ?? string.Empty,
                    MaNhanVien = row["MaNhanVien"] as string,
                    MaPhieuDat = row["MaPhieuDat"] as string,
                    MaPhieuThue = row["MaPhieuThue"] as string,
                    MaKhachHang = row["MaKhachHang"] as string,
                    TenKhachHang = row["TenKhachHang"]?.ToString() ?? string.Empty,
                    SoDienThoai = row["SoDienThoai"] as string,
                    Email = row["Email"] as string,
                    LoaiUuDai = row["LoaiUuDai"] as string,
                    PhanTramGiamGia = row["PhanTramGiamGia"] != DBNull.Value ? Convert.ToInt32(row["PhanTramGiamGia"]) : null,
                    NgayNhanSan = row["NgayNhanSan"] != DBNull.Value ? Convert.ToDateTime(row["NgayNhanSan"]) : null,
                    GioBatDau = row["GioBatDau"] != DBNull.Value ? (TimeSpan)row["GioBatDau"] : null,
                    GioKetThuc = row["GioKetThuc"] != DBNull.Value ? (TimeSpan)row["GioKetThuc"] : null,
                    TrangThaiPhieu = row["TrangThaiPhieu"] as string,
                    TenSan = row["TenSan"] as string,
                    TenLoaiSan = row["TenLoaiSan"] as string,
                    TenCoSo = row["TenCoSo"] as string,
                    MaCoSo = row["MaCoSo"] as string
                });
            }

            return invoices;
        }

        // Lấy chi tiết hóa đơn
        public HoaDonDetailDTO? GetInvoiceDetail(int maHoaDon)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@MaHoaDon", maHoaDon)
            };

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetInvoiceDetail", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(parameters[0]);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        HoaDonDetailDTO? invoice = null;

                        // Đọc thông tin hóa đơn chính
                        if (reader.Read())
                        {
                            invoice = new HoaDonDetailDTO
                            {
                                MaHoaDon = Convert.ToInt32(reader["MaHoaDon"]),
                                NgayXuat = Convert.ToDateTime(reader["NgayXuat"]),
                                TongTienSan = Convert.ToInt32(reader["TongTienSan"]),
                                TongTienDichVu = Convert.ToInt32(reader["TongTienDichVu"]),
                                TongTienGiamGia = Convert.ToInt32(reader["TongTienGiamGia"]),
                                TongThanhToan = Convert.ToInt32(reader["TongThanhToan"]),
                                HinhThucThanhToan = reader["HinhThucThanhToan"] as string,
                                TrangThaiThanhToan = reader["TrangThaiThanhToan"].ToString() ?? string.Empty,
                                MaNhanVien = reader["MaNhanVien"] as string,
                                MaPhieuDat = reader["MaPhieuDat"] as string,
                                MaPhieuThue = reader["MaPhieuThue"] as string,
                                MaKhachHang = reader["MaKhachHang"] as string,
                                TenKhachHang = reader["TenKhachHang"]?.ToString() ?? string.Empty,
                                SoDienThoai = reader["SoDienThoai"] as string,
                                Email = reader["Email"] as string,
                                NgaySinh = reader["NgaySinh"] != DBNull.Value ? Convert.ToDateTime(reader["NgaySinh"]) : null,
                                LoaiUuDai = reader["LoaiUuDai"] as string,
                                PhanTramGiamGia = reader["PhanTramGiamGia"] != DBNull.Value ? Convert.ToInt32(reader["PhanTramGiamGia"]) : null,
                                NgayDat = reader["NgayDat"] != DBNull.Value ? Convert.ToDateTime(reader["NgayDat"]) : null,
                                NgayNhanSan = reader["NgayNhanSan"] != DBNull.Value ? Convert.ToDateTime(reader["NgayNhanSan"]) : null,
                                GioBatDau = reader["GioBatDau"] != DBNull.Value ? (TimeSpan)reader["GioBatDau"] : null,
                                GioKetThuc = reader["GioKetThuc"] != DBNull.Value ? (TimeSpan)reader["GioKetThuc"] : null,
                                HinhThucDat = reader["HinhThucDat"] as string,
                                TrangThaiPhieu = reader["TrangThaiPhieu"] as string,
                                ThoiGianCheckin = reader["ThoiGianCheckin"] != DBNull.Value ? (TimeSpan)reader["ThoiGianCheckin"] : null,
                                MaSan = reader["MaSan"] as string,
                                TenSan = reader["TenSan"] as string,
                                TenLoaiSan = reader["TenLoaiSan"] as string,
                                GiaGocSan = reader["GiaGocSan"] != DBNull.Value ? Convert.ToInt32(reader["GiaGocSan"]) : null,
                                DonViTinhTheoPhut = reader["DonViTinhTheoPhut"] != DBNull.Value ? Convert.ToInt32(reader["DonViTinhTheoPhut"]) : null,
                                MaCoSo = reader["MaCoSo"] as string,
                                TenCoSo = reader["TenCoSo"] as string,
                                DiaChiCoSo = reader["DiaChiCoSo"] as string
                            };
                        }

                        if (invoice == null) return null;

                        // Đọc chi tiết dịch vụ
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                invoice.DichVu.Add(new ChiTietDichVuDTO
                                {
                                    MaChiTietPDS = reader["MaChiTietPDS"].ToString() ?? string.Empty,
                                    SoLuong = Convert.ToInt32(reader["SoLuong"]),
                                    ThanhTien = Convert.ToInt32(reader["ThanhTien"]),
                                    ThoiDiemTao = reader["ThoiDiemTao"] != DBNull.Value ? Convert.ToDateTime(reader["ThoiDiemTao"]) : null,
                                    TrangThaiThanhToan = reader["TrangThaiThanhToan"] != DBNull.Value && Convert.ToBoolean(reader["TrangThaiThanhToan"]),
                                    MaDichVu = reader["MaDichVu"] as string,
                                    TenDichVu = reader["TenDichVu"]?.ToString() ?? string.Empty,
                                    LoaiDichVu = reader["LoaiDichVu"] as string,
                                    DonGia = reader["DonGia"] != DBNull.Value ? Convert.ToInt32(reader["DonGia"]) : 0,
                                    DonViTinh = reader["DonViTinh"]?.ToString() ?? string.Empty,
                                    MaHLV = reader["MaHLV"] as string,
                                    TenHLV = reader["TenHLV"] as string,
                                    GiaThuTheoGio = reader["GiaThuTheoGio"] != DBNull.Value ? Convert.ToInt32(reader["GiaThuTheoGio"]) : null,
                                    GioBatDauDV = reader["GioBatDauDV"] != DBNull.Value ? Convert.ToDateTime(reader["GioBatDauDV"]) : null,
                                    GioKetThucDV = reader["GioKetThucDV"] != DBNull.Value ? Convert.ToDateTime(reader["GioKetThucDV"]) : null
                                });
                            }
                        }

                        // Đọc chi tiết tài sản
                        if (reader.NextResult())
                        {
                            while (reader.Read())
                            {
                                invoice.TaiSan.Add(new ChiTietTaiSanDTO
                                {
                                    MaChiTietPTTS = reader["MaChiTietPTTS"].ToString() ?? string.Empty,
                                    NgayBatDau = Convert.ToDateTime(reader["NgayBatDau"]),
                                    NgayKetThuc = Convert.ToDateTime(reader["NgayKetThuc"]),
                                    MaTaiSan = reader["MaTaiSan"] as string,
                                    LoaiTaiSan = reader["LoaiTaiSan"].ToString() ?? string.Empty,
                                    MaGoi = reader["MaGoi"] as string,
                                    TenGoi = reader["TenGoi"].ToString() ?? string.Empty,
                                    DonGia = Convert.ToInt32(reader["DonGia"]),
                                    ThoiGianSuDung = Convert.ToInt32(reader["ThoiGianSuDung"])
                                });
                            }
                        }

                        return invoice;
                    }
                }
            }
        }

        // Xử lý thanh toán
        public PaymentResponseDTO ProcessPayment(PaymentRequestDTO request)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@MaHoaDon", request.MaHoaDon),
                new SqlParameter("@HinhThucThanhToan", request.HinhThucThanhToan),
                new SqlParameter("@MaNhanVien", request.MaNhanVien)
            };

            try
            {
                var dt = ExecuteQuery("EXEC sp_ProcessPayment @MaHoaDon, @HinhThucThanhToan, @MaNhanVien", parameters);

                if (dt.Rows.Count > 0)
                {
                    var row = dt.Rows[0];
                    return new PaymentResponseDTO
                    {
                        Success = true,
                        MaHoaDon = Convert.ToInt32(row["MaHoaDon"]),
                        TrangThaiThanhToan = row["TrangThaiThanhToan"].ToString() ?? string.Empty,
                        HinhThucThanhToan = row["HinhThucThanhToan"] as string,
                        NgayXuat = Convert.ToDateTime(row["NgayXuat"]),
                        TongThanhToan = Convert.ToInt32(row["TongThanhToan"]),
                        Message = "Thanh toán thành công"
                    };
                }

                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = "Không thể xử lý thanh toán"
                };
            }
            catch (Exception ex)
            {
                return new PaymentResponseDTO
                {
                    Success = false,
                    Message = ""
                };
            }
        }
    }
}
