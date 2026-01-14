--use VietSport
--go

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
declare @masan char(10) = 'CS01LS0101'
exec sp_LT_DatSan @masan
go



-- Dirty read (Tranh chấp No8)
--T2: NVQL xem doanh thu để lập báo cáo doanh thu hiện tại
create or alter proc sp_QL_DoanhThuNam
	@output int output
as
begin
	set transaction isolation level read uncommitted
	declare @nam int = year(getdate())
	begin tran
		-- Lấy thống kê
		declare @doanhthu int
		select @doanhthu = sum(hd.TongThanhToan)
		from HoaDon hd
		where year(hd.NgayXuat) = @nam

		print N'Doanh thu hiện tại trong năm: '
		print @doanhthu
		
	commit tran
	set @output = @doanhthu
end
go
declare @doanhthu int
exec sp_QL_DoanhThuNam @doanhthu
go