🛠 Deployment Log – PortfolioApi Web Application

Date: 20.02.2025 
Environment: Production
Staging Author: Piotr Markiewicz

✅ Server-side Changes:

    AppBuild: Compiled the latest version of the application using the build pipeline

    Git Operations:

        Committed recent changes to the local repository

        Pushed updates to the remote Git repository

    File Deployment:

        Copied compiled frontend assets to the wwwroot directory for static file serving

📁 Affected Components:

    ClientApp/

    wwwroot/

    .git/

🔍 Notes:

    Ensure that the wwwroot directory is correctly configured in the web server (e.g., IIS, Nginx) to serve static files

    Verify that the pushed changes are reflected in the remote repository and CI/CD pipeline (if applicable)