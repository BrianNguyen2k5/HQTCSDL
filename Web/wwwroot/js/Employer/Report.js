function loadRevenueByCoSo() {
	const selectedYear = document.getElementById('dp_coso_year').value;
	const selectedCoSo = document.getElementById('dp_co_so').value;

	if (!selectedYear || !selectedCoSo) {
		alert('Vui lòng chọn cơ sở và năm!');
		return;
	}

	const btnLoadRevenueByCoSo = document.getElementById('btn_load_revenue_by_co_so');
	if (btnLoadRevenueByCoSo) {
		// Tắt nút trong vòng 5s
		btnLoadRevenueByCoSo.disabled = true;
		btnLoadRevenueByCoSo.textContent = 'Đang tải...';
		setTimeout(() => {
			btnLoadRevenueByCoSo.disabled = false;
			btnLoadRevenueByCoSo.textContent = 'Xem Doanh Thu';
		}, 5000);
	}

	fetch(`/Employer/GetRevenueByCoSo?maCoSo=${selectedCoSo}&nam=${selectedYear}`)
		.then(response => response.json())
		.then(data => {
			if (data.success) {
				// Hiển thị tổng quan
				const modalBody = document.getElementById('revenue-detail-modal');
				const billTotalCount = document.getElementById('totalBillCount');
				const totalBillRevenue = document.getElementById('totalBillRevenue');
				const content = document.getElementById('revenue-detail-content');

				if (billTotalCount) billTotalCount.innerText = data.data.soHoaDon;
				if (totalBillRevenue) totalBillRevenue.innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.data.tongDoanhThu);

				// Tạo bảng danh sách hóa đơn
				if (content) {
					let html = `
						<div class="overflow-x-auto">
							<table class="min-w-full bg-white border border-gray-200">
								<thead class="bg-[var(--main-color)] text-white">
									<tr>
										<th class="py-2 px-4 border-b text-center">STT</th>
										<th class="py-2 px-4 border-b text-center">Mã HĐ</th>
										<th class="py-2 px-4 border-b text-center">Tổng Cộng</th>
										<th class="py-2 px-4 border-b text-center">Hình thức thanh toán</th>
									</tr>
								</thead>
								<tbody>
					`;

					if (data.data.danhSachHoaDon && data.data.danhSachHoaDon.length > 0) {
						let stt = 1;
						data.data.danhSachHoaDon.forEach(hd => {
							const tongTien = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(hd.tongThanhToan);

							html += `
								<tr class="hover:bg-gray-50">
									<td class="py-2 px-4 border-b text-center">${stt++}</td>
									<td class="py-2 px-4 border-b text-center">${hd.maHoaDon}</td>
									<td class="py-2 px-4 border-b text-center">${tongTien}</td>
									<td class="py-2 px-4 border-b text-center">${hd.hinhThucThanhToan}</td>
								</tr>
							`;
						});
					} else {
						html += `<tr><td colspan="4" class="py-4 text-center text-gray-500">Không có dữ liệu hóa đơn nào.</td></tr>`;
					}

					html += `</tbody></table></div>`;
					content.innerHTML = html;
				}

				if (modalBody) modalBody.classList.remove('hidden');
			} else {
				alert(data.message || 'Có lỗi xảy ra khi tải dữ liệu.');
			}
		})
		.catch(error => {
			console.error(error);
			alert('Lỗi kết nối đến máy chủ.');
		});
}

document.addEventListener('DOMContentLoaded', function () {
	const cosoYear = document.getElementById('dp_coso_year');
	const phieuhuyYear = document.getElementById('dp_cancel_year');

	if (cosoYear) {
		const currentYear = new Date().getFullYear();
		for (let i = currentYear; i >= 2010; i--) {
			let opt = document.createElement('option');
			opt.value = i;
			opt.text = i;
			cosoYear.appendChild(opt);
			phieuhuyYear.appendChild(opt.cloneNode(true));
		}
	}

	fetch(`/Employer/GetFieldBookings`)
		.then(res => res.json())
		.then(data => {
			if (data.success) {
				console.log(data.data);
				const fieldRentingList = document.getElementById("field-renting-list");
				if (fieldRentingList) {
					let html = `
						<p class="title mt-8">Danh sách lượt đặt sân</p>
						<div class="overflow-x-auto mt-2">
							<table class="min-w-full bg-white border border-gray-200">
								<thead class="bg-[var(--main-color)] text-white">
									<tr>
										<th class="py-2 px-4 border-b text-center">STT</th>
										<th class="py-2 px-4 border-b text-center">Mã Phiếu Đặt</th>
										<th class="py-2 px-4 border-b text-center">Người Đặt</th>
										<th class="py-2 px-4 border-b text-center">Ngày Đặt</th>
										<th class="py-2 px-4 border-b text-center">Hình Thức Đặt</th>
										<th class="py-2 px-4 border-b text-center">Trạng Thái Phiếu</th>
									</tr>
								</thead>
								<tbody>
					`;
					if (data.data && data.data.length > 0) {
						let stt = 1;
						data.data.forEach(phieu => {
							html += `
								<tr class="hover:bg-gray-50">
									<td class="py-2 px-4 border-b text-center">${stt++}</td>
									<td class="py-2 px-4 border-b text-center">${phieu.maPhieuDat}</td>
									<td class="py-2 px-4 border-b text-center">${phieu.nguoiDat}</td>
									<td class="py-2 px-4 border-b text-center">${phieu.ngayDat}</td>
									<td class="py-2 px-4 border-b text-center">${phieu.hinhThucDat}</td>
									<td class="py-2 px-4 border-b text-center">${phieu.trangThaiPhieu}</td>
								</tr>
							`;
						});
					} else {
						html += `<tr><td colspan="6" class="py-4 text-center text-gray-500">Không có dữ liệu lượt đặt sân nào.</td></tr>`;
					}
					html += `</tbody></table></div>`;
					fieldRentingList.innerHTML = html;
				}
			} else {
				console.error(data.message || 'Có lỗi xảy ra khi tải dữ liệu lượt đặt sân.');
			}
		})
		.catch(err => {
			console.error(err);
			alert('Lỗi kết nối đến máy chủ khi tải dữ liệu lượt đặt sân.');
		});
})

function closeRevenueDetailModal() {
	const modal = document.getElementById('revenue-detail-modal');
	if (modal) {
		modal.classList.add('hidden');
	}
}

function handleServiceCancelModal() {
	const serviceModal = document.getElementById("service-cancel-modal");

	try {
		// Fetch data
		const selectedYear = document.getElementById('dp_cancel_year').value;
		if (!selectedYear) {
			alert('Vui lòng chọn năm!');
			return;
		}
		fetch(`/Employer/GetServiceCancelReport?nam=${selectedYear}`)
			.then(res => res.json())
			.then(data => {
				if (data.success) {
					// Populate data into modal
					const totalCancellations = document.getElementById("total-cancellations");
					const cancellationList = document.getElementById("cancellation-list");

					if (totalCancellations) totalCancellations.innerText = data.data.tongSoPhieu;
					if (cancellationList) {
						let html = `
							<div class="overflow-x-auto">
								<table class="min-w-full bg-white border border-gray-200">
									<thead class="bg-[var(--main-color)] text-white">
										<tr>
											<th class="py-2 px-4 border-b text-center">STT</th>
											<th class="py-2 px-4 border-b text-center">Mã Phiếu</th>
											<th class="py-2 px-4 border-b text-center">Ngày đặt</th>
											<th class="py-2 px-4 border-b text-center">Ngày nhận</th>
											<th class="py-2 px-4 border-b text-center">Hình thức đặt</th>
										</tr>
									</thead>
									<tbody>
						`;
						if (data.data.dsPhieuHuy && data.data.dsPhieuHuy.length > 0) {
							let stt = 1;
							data.data.dsPhieuHuy.forEach(phieu => {
								html += `
									<tr class="hover:bg-gray-50">
										<td class="py-2 px-4 border-b text-center">${stt++}</td>
										<td class="py-2 px-4 border-b text-center">${phieu.maPhieuDat}</td>
										<td class="py-2 px-4 border-b text-center">${phieu.ngayDat}</td>
										<td class="py-2 px-4 border-b text-center">${phieu.ngayNhanSan}</td>
										<td class="py-2 px-4 border-b text-center">${phieu.hinhThucDat}</td>
									</tr>
								`;
							});
						} 
						else {
							html += `<tr><td colspan="5" class="py-4 text-center text-gray-500">Không có dữ liệu phiếu hủy nào.</td></tr>`;
						}

						html += `
									</tbody>
								</table>
							</div>`;
						if (serviceModal) serviceModal.classList.remove("hidden");
						else alert("Không tìm thấy biểu mẫu kết quả")
						cancellationList.innerHTML = html;
					}
				} else {
					alert(data.message || 'Có lỗi xảy ra khi tải dữ liệu.');
				}
			})
			.catch(err => {
				console.error(err);
				alert('Lỗi kết nối đến máy chủ.');
			});
	}
	catch (error) {
		console.error(error);
		alert('Đã xảy ra lỗi khi xử lý yêu cầu.');
	}
}

function closeServiceCancelModal() {
	const serviceModal = document.getElementById("service-cancel-modal")
	if (serviceModal) serviceModal.classList.add("hidden");
	else alert("Không tìm thấy biểu mẫu kết quả")
}