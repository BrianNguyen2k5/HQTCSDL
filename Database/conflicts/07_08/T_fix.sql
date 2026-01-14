-- Lost update (Tranh chấp No7)
-- T1: NVKT thay đổi tình trạng của sân A qua “Bảo trì”
create or alter proc sp_KT_BaoTriSan
	@masan char(10)
as
begin
	set transaction isolation level repeatable read -- Chuyển qua repeatable read
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
	--Trả lại mức mặc định (Read Committed) trước khi thoát
	set transaction isolation level read committed
end
go



-- Dirty read (Tranh chấp No8)
--T2: NVQL xem doanh thu để lập báo cáo doanh thu hiện tại
create or alter proc sp_QL_DoanhThuNam
	@output int output
as
begin
	set transaction isolation level read committed --Chuyển qua read committed
	declare @nam int = year(getdate())
	begin tran
	
		-- Lấy thống kê
		declare @doanhthu int
		select @doanhthu = sum(hd.TongThanhToan)
		from HoaDon hd
		where year(hd.NgayXuat) = @nam

	commit tran
	set @output = @doanhthu
end
go
declare @doanhthu int
exec sp_QL_DoanhThuNam @doanhthu
go