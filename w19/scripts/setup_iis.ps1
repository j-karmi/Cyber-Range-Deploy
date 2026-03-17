Install-WindowsFeature -name Web-Server -IncludeManagementTools

New-Item -ItemType Directory -Path C:\inetpub\wwwroot -Force

Copy-Item E:\index.html C:\inetpub\wwwroot\index.html -Force

Restart-Service W3SVC