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
select *
from dbo.F_ThongKeSoLuong ()
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
select *
from dbo.F_DanhSachGiaLoaiSan()
go

select * from san
select * from Loaisan
select * from GoiDichVu