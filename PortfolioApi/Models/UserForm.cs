using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace PortfolioApi.Models
{
    public class UserForm
    {
        public class LoginRequest
        {
            public string Username { get; set; }
            public string Password { get; set; }
        }

        [ApiController]
        [Route("api/[controller]")]
        public class AuthController : ControllerBase
        {
            [HttpPost("login")]
            public IActionResult Login([FromBody] LoginRequest request)
            {
                if (request.Username == "user" && request.Password == "pass")
                {
                    var token = GetToken(request);
                    return Ok(new { token });
                }
                return Unauthorized();
            }

            private static object GetToken(LoginRequest request)
            {
                return GenerateJwtToken(request.Username);
            }

            private static object GenerateJwtToken(string username)
            {
                if (string.IsNullOrEmpty(username))
                {
                    throw new ArgumentNullException(nameof(username));
                }

                // Example token generation logic (replace with actual implementation)
                return new { Token = "example.jwt.token", Username = username };
            }
        }
    }
}
