using System.Data;
using Microsoft.Data.SqlClient;
using DTO;
using Microsoft.Extensions.Configuration;

namespace DAL
{
    public class BookingDAL
    {
        private readonly string _connectionString;

        public BookingDAL(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("VietSport");
        }

        // SP_LayDanhSachChiNhanh - Get all branches
        public List<BranchDTO> GetBranches()
        {
            var branches = new List<BranchDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SP_LayDanhSachChiNhanh", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            branches.Add(new BranchDTO
                            {
                                MaCoSo = reader["MaCoSo"].ToString(),
                                TenCoSo = reader["TenCoSo"].ToString(),
                                DiaChi = reader["DiaChi"].ToString()
                            });
                        }
                    }
                }
            }

            return branches;
        }

        // SP_LayDanhSachLoaiSan - Get all court types
        public List<CourtTypeDTO> GetCourtTypes()
        {
            var courtTypes = new List<CourtTypeDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SP_LayDanhSachLoaiSan", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courtTypes.Add(new CourtTypeDTO
                            {
                                MaLoaiSan = reader["MaLoaiSan"].ToString(),
                                TenLoaiSan = reader["TenLoaiSan"].ToString(),
                                DonViTinhTheoPhut = Convert.ToInt32(reader["DonViTinhTheoPhut"]),
                                GiaGoc = Convert.ToDecimal(reader["GiaGoc"]),
                                MoTa = reader["MoTa"].ToString()
                            });
                        }
                    }
                }
            }

            return courtTypes;
        }

        // SP_LayDanhSachSan - Get courts by branch and court type
        public List<CourtDTO> GetCourts(string branchId, string courtTypeId)
        {
            var courts = new List<CourtDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SP_LayDanhSachSan", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MaCoSo", branchId);
                    cmd.Parameters.AddWithValue("@MaLoaiSan", courtTypeId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courts.Add(new CourtDTO
                            {
                                MaSan = reader["MaSan"].ToString(),
                                TenSan = reader["TenSan"].ToString(),
                                TinhTrang = reader["TinhTrang"].ToString(),
                                SucChua = Convert.ToInt32(reader["SucChua"]),
                                MaCoSo = reader["MaCoSo"].ToString(),
                                MaLoaiSan = reader["MaLoaiSan"].ToString()
                            });
                        }
                    }
                }
            }

            return courts;
        }

        // SP_LayDanhSachDichVu - Get all services
        public List<ServiceDTO> GetServices(string branchId)
        {
            var services = new List<ServiceDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SP_LayDanhSachDichVu", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MaCoSo", branchId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            services.Add(new ServiceDTO
                            {
                                MaDichVu = reader["MaDichVu"].ToString(),
                                TenDichVu = reader["TenDichVu"].ToString(),
                                LoaiDichVu = reader["LoaiDichVu"].ToString(),
                                DonGia = Convert.ToDecimal(reader["DonGia"]),
                                DonViTinh = reader["DonViTinh"].ToString()
                            });
                        }
                    }
                }
            }

            return services;
        }

        // SP_LayLichDatSan - Get booking schedule for a specific date, branch, and court type
        public List<BookingScheduleDTO> GetBookingSchedule(string date, string branchId, string courtTypeId)
        {
            var bookings = new List<BookingScheduleDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SP_LayLichDatSan", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@NgayNhanSan", DateTime.Parse(date));
                    cmd.Parameters.AddWithValue("@MaCoSo", branchId);
                    cmd.Parameters.AddWithValue("@MaLoaiSan", courtTypeId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            bookings.Add(new BookingScheduleDTO
                            {
                                MaPhieuDat = reader["MaPhieuDat"].ToString(),
                                GioBatDau = (TimeSpan)reader["GioBatDau"],
                                GioKetThuc = (TimeSpan)reader["GioKetThuc"],
                                MaSan = reader["MaSan"].ToString()
                            });
                        }
                    }
                }
            }

            return bookings;
        }

        // sp_KhachHang_DatSanOnline - Create a new booking
        public BookingResponseDTO CreateBooking(BookingRequestDTO request)
        {
            var response = new BookingResponseDTO();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    conn.Open();
                    
                    using (SqlCommand cmd = new SqlCommand("sp_KhachHang_DatSanOnline", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@MaKhachHang", request.MaKhachHang);
                        cmd.Parameters.AddWithValue("@MaSan", request.MaSan);
                        cmd.Parameters.AddWithValue("@NgayNhanSan", DateTime.Parse(request.NgayNhanSan));
                        cmd.Parameters.AddWithValue("@GioBatDau", TimeSpan.Parse(request.GioBatDau));
                        cmd.Parameters.AddWithValue("@GioKetThuc", TimeSpan.Parse(request.GioKetThuc));
                        
                        cmd.ExecuteNonQuery();
                    }
                    
                    // Lấy mã phiếu đặt vừa tạo (SP không trả về trực tiếp)
                    using (SqlCommand cmdSelect = new SqlCommand("SELECT TOP 1 MaPhieuDat FROM PhieuDatSan WHERE MaKhachHang = @MaKhachHang ORDER BY NgayDat DESC", conn))
                    {
                        cmdSelect.CommandType = CommandType.Text;
                        cmdSelect.Parameters.AddWithValue("@MaKhachHang", request.MaKhachHang);
                        
                        var maPhieuDat = cmdSelect.ExecuteScalar();
                        
                        if (maPhieuDat != null)
                        {
                            response.MaPhieuDat = maPhieuDat.ToString();
                            response.Success = true;
                            response.Message = "Đặt sân thành công";
                        }
                        else
                        {
                            response.Success = false;
                            response.Message = "Không thể lấy mã phiếu đặt";
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                response.Success = false;
                response.Message = ex.Message;
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = $"Lỗi: {ex.Message}";
            }

            return response;
        }

        // sp_ThemDichVuVaoPhieuDat - Add service to booking with inventory management
        public ServiceAddResponseDTO AddServiceToBooking(ServiceAddRequestDTO request)
        {
            var response = new ServiceAddResponseDTO();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ThemDichVuVaoPhieuDat", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@MaPhieuDat", request.MaPhieuDat);
                        cmd.Parameters.AddWithValue("@MaDichVu", request.MaDichVu);
                        cmd.Parameters.AddWithValue("@SoLuong", request.SoLuong);
                        cmd.Parameters.AddWithValue("@MaNhanVien", (object)request.MaNhanVien ?? DBNull.Value);
                        
                        conn.Open();
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                response.MaChiTietPDS = reader["MaChiTietPDS"].ToString();
                                response.Success = true;
                                response.Message = "Thêm dịch vụ thành công";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = $"Lỗi: {ex.Message}";
            }

            return response;
        }

        // sp_LayLichDatCuaToi - Get customer's booking history
        public List<MyBookingDTO> GetMyBookings(string maKhachHang)
        {
            var bookings = new List<MyBookingDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_LayLichDatCuaToi", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MaKhachHang", maKhachHang);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            bookings.Add(new MyBookingDTO
                            {
                                MaPhieuDat = reader["MaPhieuDat"].ToString(),
                                NgayDat = reader["NgayDat"].ToString(),
                                NgayNhanSan = reader["NgayNhanSan"].ToString(),
                                GioBatDau = reader["GioBatDau"].ToString(),
                                GioKetThuc = reader["GioKetThuc"].ToString(),
                                TenSan = reader["TenSan"].ToString(),
                                TenLoaiSan = reader["TenLoaiSan"].ToString(),
                                TenCoSo = reader["TenCoSo"].ToString(),
                                TrangThaiPhieu = reader["TrangThaiPhieu"].ToString()
                            });
                        }
                    }
                }
            }

            return bookings;
        }

        // sp_HuyLichDatSan - Cancel booking
        public CancelBookingResponseDTO CancelBooking(string maPhieuDat, string lyDoHuy = null)
        {
            var response = new CancelBookingResponseDTO();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_HuyLichDatSan", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MaPhieuDat", maPhieuDat);
                    cmd.Parameters.AddWithValue("@LyDoHuy", (object)lyDoHuy ?? DBNull.Value);
                    
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            response.Success = Convert.ToBoolean(reader["Success"]);
                            response.Message = reader["Message"].ToString();
                        }
                    }
                }
            }

            return response;
        }

        // Get coaches by branch
        public List<CoachDTO> GetCoaches(string branchId)
        {
            var coaches = new List<CoachDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT nv.MaNhanVien, nv.HoTen, hlv.MonTheThao, hlv.GiaThue, hlv.KinhNghiem
                    FROM NhanVien nv 
                    JOIN HuanLuyenVien hlv ON nv.MaNhanVien = hlv.MaNhanVien
                    WHERE nv.MaCoSo = @MaCoSo";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@MaCoSo", branchId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            coaches.Add(new CoachDTO
                            {
                                MaNhanVien = reader["MaNhanVien"].ToString(),
                                TenNhanVien = reader["HoTen"].ToString(),
                                MonTheThao = reader["MonTheThao"].ToString(),
                                GiaThue = Convert.ToDecimal(reader["GiaThue"]),
                                KinhNghiem = reader["KinhNghiem"].ToString()
                            });
                        }
                    }
                }
            }

            return coaches;
        }
        // Get promotions
        public List<PromotionDTO> GetPromotions()
        {
            var promotions = new List<PromotionDTO>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_LayDanhSachUuDai", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            promotions.Add(new PromotionDTO
                            {
                                MaUuDai = reader["MaUuDai"].ToString(),
                                LoaiUuDai = reader["LoaiUuDai"].ToString(),
                                PhanTramGiamGia = Convert.ToDouble(reader["PhanTramGiamGia"])
                            });
                        }
                    }
                }
            }

            return promotions;
        }
    }
}
