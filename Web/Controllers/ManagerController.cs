using Microsoft.AspNetCore.Mvc;

namespace HQTCSDL.Controllers
{
	public class ManagerController : Controller
	{
		public IActionResult Index()
		{
			return View();
		}
	}
}