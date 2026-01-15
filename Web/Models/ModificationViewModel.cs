using DTO;

namespace HQTCSDL.Models
{
    public class ModificationViewModel
    {
        public IEnumerable<LoaiSan> LoaiSanList { get; set; } = new List<LoaiSan>();
        public IEnumerable<DichVu> DichVuList { get; set; } = new List<DichVu>();
    }
}
