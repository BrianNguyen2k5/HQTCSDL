using Microsoft.Extensions.Configuration;

namespace DAL
{
	public class DatabaseConnection
	{
		protected readonly string _connectionString;

		public DatabaseConnection(IConfiguration configuration)
		{
			_connectionString = configuration.GetConnectionString("VietSport") 
				?? throw new InvalidOperationException("Connection string 'VietSport' not found.");
		}

		protected string GetConnectionString()
		{
			return _connectionString;
		}
	}
}
