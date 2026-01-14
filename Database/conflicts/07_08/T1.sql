--use vietsport
--go

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

declare @masan char(10) = 'CS01LS0101'
--update San set TinhTrang = N'Trống' where MaSan = @masan
exec sp_KT_BaoTriSan @masan

-- Kết quả xuất ra "bảo trì" 
--=> Khách hàng mất thông tin đặt sân
select * from san
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

declare @tiensan int = 15000,
	@tiendv int = 0,
	@giamgia int = 5000,
	@hinhthuc nvarchar(50) = N'Tiền mặt',
	@trangthai nvarchar(50) = N'Đã thanh toán',
	@manv char(10) = 'NV003',
	@maphieudat char(10) = 'PDS01',
	@maphieuthue char(10) = null
exec sp_TN_LapHoaDon @tiensan, @tiendv, @giamgia, @hinhthuc, @trangthai, @manv, @maphieudat, @maphieuthue

select * from nhanvien join ChucVu on nhanvien.MaChucVu = chucvu.MaChucVu
select * from phieudatsan join san on PhieuDatSan.MaSan = san.masan
select * from HoaDon