using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class CoursesController : ControllerBase
{
    [HttpGet]
    public IActionResult GetCourses()
    {
        var courseDto = new CourseDto
        {
            Courses = new List<string>
            {
                "Angular i Java Spring Od zera do Fullstack developera (Udemy)",
                "Praktyczny kurs ASP.NET Core REST Web API (C#) (Udemy)",
                "ASP.NET Core MVC - praktyczny kurs od podstaw (C# .NET 7) (Udemy)",
                "Kompletny kurs C# dla developerów .NET (Udemy)",
                "Microsoft Azure - praktyczny kurs dla developerów .NET (Udemy)",
                "Kurs Tworzenia Stron WWW w HTML i CSS od Podstaw do Eksperta (Udemy)",
                "CCNAv7: Enterprise Networking, Security, and Automation (WWSI)"
            }
        };

        return Ok(courseDto);
    }
}