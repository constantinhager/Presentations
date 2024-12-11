﻿New-PSUEndpoint -Url "/api/v1/getuser/:Page" -Description "Returns all the users from Reqres" -Method @('GET') -Role @('Administrator') -Path "GetUser/getuser.ps1" 
New-PSUEndpoint -Url "/api/v1/getuserbyid/:Id" -Description "Get user by Id" -Method @('GET') -Path "GetUser/getuserbyid.ps1"