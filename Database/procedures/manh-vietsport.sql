-- Các hàm bổ sung tùy theo ý muốn mọi người
create or alter function F_ThongKeSoLuong ()
returns @statistics table (
	TenThongKe nvarchar(50),
	ThongSo int
)
as
begin
	declare @thongkesan int
	select @thongkesan = count(MaPhieuDat)
	from PhieuDatSan
	insert into @statistics values (N'San_total', @thongkesan)

	declare @thongkedv int
	select @thongkedv = count(MaChiTietPDS)
	from ChiTietPhieuDatSan
	insert into @statistics values (N'DichVu_total', @thongkedv)

	declare @thongkets int
	select @thongkets = count(MaPhieuThue)
	from PhieuThueTaiSan
	insert into @statistics values (N'TaiSan_total', @thongkets)

	declare @huysan int
	select @huysan = count(MaPhieuDat)
	from LichSuThayDoi 
	insert into @statistics values (N'San_cancel', @huysan)

	declare @huydv int
	select @huydv = count(MaChiTietPDS)
	from LichSuHuyDichVu
	insert into @statistics values (N'DichVu_cancel', @huydv)

	return
end
go

create or alter function F_DanhSachGiaLoaiSan ()
returns @dsLoaiSan table (
	MaLoaiSan varchar(10),
    TenLoaiSan nvarchar(50),
	DonViTinhTheoPhut int,
	GiaGoc int,
	MoTa nvarchar(255)
)
as
begin
	insert into @dsLoaiSan
		select distinct ls.MaLoaiSan, ls.TenLoaiSan, ls.DonViTinhTheoPhut, ls.GiaGoc, ls.MoTa
		from LoaiSan ls
	return
end
go

-- Lost update (Tranh chấp No7)
-- T1: NVKT thay đổi tình trạng của sân A qua “Bảo trì”
create or alter proc sp_KT_BaoTriSan
	@masan char(10)
as
begin
	set transaction isolation level read committed
	begin tran
		-- Kiểm tra sân có tồn tại hay không
		if not exists (
			select top 1 *
			from San s
			where s.MaSan = @masan
		)
		begin
			print N'Sân không tồn tại'
			rollback tran
			return 0
		end
		-- Kiểm tra sân có đang trống hay không
		if exists (
			select top 1 *
			from San s
			where s.MaSan = @masan
				and s.TinhTrang <> N'Trống'
		)
		begin
			print N'Sân không trống'
			rollback tran
			return 0
		end
		-- Giữ transaction mở để T2 đọc
		waitfor delay '00:00:05';
		-- Update tình trạng qua bảo trì
		update San set TinhTrang = N'Bảo trì' where MaSan = @masan
	commit tran
end
go


-- Dirty read (Tranh chấp No8)
--T1: NVTN thanh toán và xuất hóa đơn cùng ngày lập báo cáo nhưng lỗi không xuất được
create or alter proc sp_TN_LapHoaDon
	@tiensan int,
	@tiendv int,
	@giamgia int,
	@hinhthuc nvarchar(50),
	@trangthai nvarchar(50),
	@manv char(10),
	@maphieudat char(10),
	@maphieuthue char(10)
as
begin
	set transaction isolation level read committed
	begin tran
		declare @tongtien int
		set @tongtien = @tiensan + @tiendv - @giamgia
		-- Kiểm tra tổng tiền phải > 0
		if @tongtien <= 0
		begin
			print N'Tiền thanh toán của hóa đơn không thể nhỏ hơn 0'
			rollback tran
			return 0
		end
		-- Kiểm tra 1 trong 2 phiếu phải khác null
		if @maphieudat = null and @maphieuthue = null
		begin
			print N'Hóa đơn phải có 1 trong 2 loại thiếu thuê sân hoặc tài sản'
			rollback tran
			return 0
		end

		declare @mahoadon int;
		insert into HoaDon (NgayXuat, TongTienSan, TongTienDichVu, TongTienGiamGia, TongThanhToan, HinhThucThanhToan, TrangThaiThanhToan, MaNhanVien, MaPhieuDat, MaPhieuThue)
		values (getdate(), @tiensan, @tiendv, @giamgia, @tongtien, @hinhthuc, @trangthai, @manv, @maphieudat, @maphieuthue)
		set @mahoadon = SCOPE_IDENTITY()

		-- Thời gian khách hàng thực hiện trả tiền Hóa đơn
		waitfor delay '00:00:05';

		-- Đảm bảo hóa đơn đang ở trạng thái 'Chưa thanh toán'
		-- Nếu không phải => Đã có đợt sữa đổi dữ liệu ngoài ý muốn
		if exists (
			select top 1 *
			from HoaDon hd
			where hd.MaHoaDon = @mahoadon
				and hd.TrangThaiThanhToan != N'Chưa thanh toán'
		)
		begin
			print N'Trạng thái trong hóa đơn bị sai'
			rollback tran
			return 0
		end

		-- Cập nhật trạng thái qua 'Đã thanh toán'
		update HoaDon set TrangThaiThanhToan = N'Đã thanh toán' where MaHoaDon = @mahoadon
	commit tran
end
go


-- Lost update (Tranh chấp No7)
-- T2: NVLT chuyển sân qua 'Đã đặt' sau khi đặt sân xong cho KH
create or alter proc sp_LT_DatSan
	@masan char(10)
as
begin
	set transaction isolation level read committed
	begin tran
		-- Kiểm tra sân có tồn tại hay không
		if not exists (
			select top 1 *
			from San s
			where s.MaSan = @masan
		) 
		begin
			print N'Sân không tồn tại'
			rollback tran
			return 0
		end
		-- Kiểm tra sân có đang trống hay không
		if exists (
			select top 1 *
			from San s
			where s.MaSan = @masan
				and s.TinhTrang <> N'Trống'
		)
		begin
			print N'Sân không trống'
			rollback tran
			return 0
		end
		-- Update tình trạng qua Đẵ đặt
		update San set TinhTrang = N'Đã đặt' where MaSan = @masan
	commit tran
end
go


-- Dirty read (Tranh chấp No8)
--T2: NVQL xem doanh thu để lập báo cáo doanh thu hiện tại
create or alter proc sp_QL_DoanhThuNam
	@nam int,
	@output int output
as
begin
		-- Lấy thống kê
		declare @doanhthu int
		select @doanhthu = sum(hd.TongThanhToan)
		from HoaDon hd
		where year(hd.NgayXuat) = @nam
		
	set @output = isnull(@doanhthu, 0)
end
go

create or alter proc sp_QL_DoanhThuNamThang
	@nam int,
	@thang int,
	@output int output
as
begin
	declare @doanhthu int
	select @doanhthu = sum(hd.TongThanhToan)
	from HoaDon hd
	where year(hd.NgayXuat) = @nam
		and month(hd.NgayXuat) = @thang
	set @output = isnull(@doanhthu, 0)
end
go

create or alter proc sp_QL_DoanhThuNamThangNgay
	@nam int,
	@thang int,
	@ngay int,
	@output int output
as
begin
	declare @doanhthu int
	select @doanhthu = sum(hd.TongThanhToan)
	from HoaDon hd
	where year(hd.NgayXuat) = @nam
		and month(hd.NgayXuat) = @thang
		and day(hd.NgayXuat) = @ngay
	set @output = isnull(@doanhthu, 0)
end
go

--select * from HoaDon
declare @output int
exec sp_QL_DoanhThuNam 2025, @output output
print @output
--go