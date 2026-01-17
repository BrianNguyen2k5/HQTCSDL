-- Các hàm bổ sung tùy theo ý muốn mọi người
use VietSport
go

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
	select @huysan = count(p.MaPhieuDat)
	from PhieuDatSan p
	where p.TrangThaiPhieu = N'Đã hủy'
	insert into @statistics values (N'San_cancel', @huysan)

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


-- Dirty read (Tranh chấp No8)
--T2: NVQL xem doanh thu để lập báo cáo doanh thu hiện tại
create or alter proc sp_QL_DoanhThuNam
	@nam int,
	@output int output
as
begin
	set transaction isolation level read uncommitted
	begin tran
		-- Lấy thống kê
		declare @doanhthu int
		select @doanhthu = sum(hd.TongThanhToan)
		from HoaDon hd
		where year(hd.NgayXuat) = @nam
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
	commit tran
	set @output = isnull(@doanhthu, 0)
	set transaction isolation level read committed
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
		and hd.TrangThaiThanhToan = N'Đã thanh toán'
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
		and hd.TrangThaiThanhToan = N'Đã thanh toán'
	set @output = isnull(@doanhthu, 0)
end
go

-- Phantom (Xem chi tiết hóa đơn giai đoạn 1 và 2 của quản lý) (My)
create or alter proc sp_ChiTietThongKeDoanhThu
	@macoso char(10),
	@nam int
as
begin
	set transaction isolation level repeatable read
	begin tran
		SELECT COUNT(MaHoaDon) as SoHoaDon,  SUM (TongThanhToan) as TongDoanhThu
		FROM HoaDon hd
		JOIN NhanVien nv on nv.MaNhanVien = hd.MaNhanVien
		WHERE MaCoSo = 'CS01' 
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
			and year(hd.NgayXuat) = @nam

		WAITFOR DELAY '00:00:05'

		SELECT hd.MaHoaDon, hd.TongThanhToan, hd.HinhThucThanhToan
		FROM HoaDon hd
		JOIN NhanVien nv on nv.MaNhanVien = hd.MaNhanVien
		WHERE MaCoSo = 'CS01' 
			and hd.TrangThaiThanhToan = N'Đã thanh toán'
			and year(hd.NgayXuat) = @nam
	commit tran
	set transaction isolation level read committed
end
go

-- Thống kê phiếu hủy (Minh)
create or alter proc sp_ChiTietThongKePhieuHuy
	@nam int
as
begin
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	begin tran
		--B1: Đếm số phiếu huỷ 
		SELECT COUNT(*) AS SoLuong
		FROM PhieuDatSan
		WHERE year(NgayNhanSan) = @nam
			AND TrangThaiPhieu = N'Đã hủy'

		waitfor delay '00:00:05'

		select p.MaPhieuDat, p.NgayDat, p.NgayNhanSan, p.HinhThucDat
		from PhieuDatSan p
		where year(p.NgayNhanSan) = @nam
			and TrangThaiPhieu = N'Đã hủy'

	commit tran
	SET TRANSACTION ISOLATION LEVEL read committed
end
go

-- Khải
-- Đổi giá sân, dịch vụ
create or alter proc sp_CapNhatGiaSan
	@maloaisan char(10),
	@giamoi int
as
begin
	update LoaiSan set GiaGoc = @giamoi where MaLoaiSan = @maloaisan
end
go

create or alter proc sp_CapNhatGiaDV
	@madv char(10),
	@giamoi int
as
begin
	update DichVu set DonGia = @giamoi where MaDichVu = @madv
end
go

create or alter proc sp_LayPhieuDatSan
as
begin
	select p.MaPhieuDat, kh.HoTen as NguoiDat, p.NgayDat, p.HinhThucDat, p.TrangThaiPhieu
	from PhieuDatSan p, KhachHang kh
	where p.MaKhachHang = kh.MaKhachHang
end
go
select * from PhieuDatSan
--select * from HoaDon
--declare @output int
--exec sp_QL_DoanhThuNam 2025, @output output
--print @output
--go

-- Lấy danh sách Store Procedure và Function
--SELECT 
--    name AS [Name], 
--    type_desc AS [Type], 
--    create_date AS [Created Date],
--    modify_date AS [Last Modified]
--FROM sys.objects
--WHERE type IN ('P', 'FN', 'IF', 'TF') -- P: Procedure, FN: Scalar Function, IF/TF: Table-valued Function
--ORDER BY type, name;
