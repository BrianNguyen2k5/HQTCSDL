using Microsoft.Extensions.Configuration;

namespace DAL
{
	public class DatabaseConnection
	{
		protected readonly string _connectionString;

		public DatabaseConnection(IConfiguration configuration)
		{
			_connectionString = configuration.GetConnectionString("DefaultConnection") 
				?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
		}

		protected string GetConnectionString()
		{
			return _connectionString;
		}
	}
}
