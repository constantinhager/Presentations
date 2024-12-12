function Get-CHUserManagementPage {
    <#
        .SYNOPSIS
            Retrieves a page of user accounts from the Reqres API.

        .DESCRIPTION
            Retrieves a page of user accounts from the Reqres API.

        .PARAMETER Page
            The page number to retrieve.

        .EXAMPLE
            Get-CHUserManagementPage
            Returns the first page of users from the Reqres API.

        .EXAMPLE
            Get-CHUserManagementPage -Page 2
            Returns the second page of users from the Reqres API.
        .NOTES
            Author: Constantin Hager
            Date: 2024-12-11
    #>

    param(
        [Parameter()]
        [int]
        $Page = 1
    )

    $url = "http://localhost:5000/api/v1/getuser/$Page"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response
}

function Get-CHUserById {
    <#
        .SYNOPSIS
            Retrieves a user account from the Reqres API by ID.

        .DESCRIPTION
            Retrieves a user account from the Reqres API by ID.

        .PARAMETER Id
            The ID of the user to retrieve.

        .EXAMPLE
            Get-CHUserById -Id 1
            Returns the user with ID 1 from the Reqres API.

        .NOTES
            Author: Constantin Hager
            Date: 2024-12-11
    #>

    param(
        [Parameter(Mandatory)]
        [int]
        $Id
    )

    $url = "http://reqres.in/api/users/$Id"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response
}

function New-CHUserManagementPage {
    <#
        .SYNOPSIS
            Function for displaying the UserManagement page.

        .DESCRIPTION
            Function for displaying the UserManagement page.

        .EXAMPLE
            New-CHUserManagementPage

        .NOTES
            Author: Constantin Hager
            Date: 2024-12-11
    #>

    New-UDTypography -Text 'User Management' -Variant h3
    $Cache:UserManagement = Get-CHUserManagementPage
    $Cache:CurrentPage = $Cache:UserManagement.page

    New-UDButton -Text 'Previous Page' -OnClick {
        $PrevPage = $Cache:CurrentPage - 1
        $Cache:CurrentPage = $PrevPage

        if ($PrevPage -eq 0) {
            Show-UDModal -Content {
                New-UDTypography -Text 'No more pages available' -Variant h6
            }
            $Cache:CurrentPage = 1
        } else {
            $Cache:UserManagement = Get-CHUserManagementPage -Page $PrevPage
            Sync-UDElement -Id 'UserManagement'
        }
    }

    New-UDButton -Text 'Next Page' -OnClick {
        $NextPage = $Cache:CurrentPage + 1
        $Cache:CurrentPage = $NextPage
        if ($NextPage -le $Cache:UserManagement.total_pages) {
            $Cache:UserManagement = Get-CHUserManagementPage -Page $NextPage
            Sync-UDElement -Id 'UserManagement'
        } else {
            $Cache:CurrentPage = $Cache:UserManagement.total_pages
            Show-UDModal -Content {
                New-UDTypography -Text 'No more pages available' -Variant h6
            }
        }
    }

    $Columns = @(
        New-UDTableColumn -Property 'id' -Title 'Action' -Align center -IncludeInSearch -OnRender {
            New-UDButton -Text 'View UserInfo' -OnClick {
                Show-UDModal -Content {
                    $CurrentUserId = $EventData.id
                    $Result = Get-CHUserById -Id $CurrentUserId
                    New-UDTypography -Text 'User Info' -Variant h5
                    New-UDAvatar -Alt $Result.data.first_name -Image $Result.data.avatar

                    New-UDGrid -Container -Spacing 3 -Children {
                        New-UDGrid -Item -Children {
                            New-UDTypography -Text 'ID:' -Variant body1
                            New-UDTypography -Text 'Email:' -Variant body1
                            New-UDTypography -Text 'First Name:' -Variant body1
                            New-UDTypography -Text 'Last Name:' -Variant body1
                        }
                        New-UDGrid -Item -Children {
                            New-UDTypography -Text "$($Result.data.id)" -Variant body1
                            New-UDTypography -Text "$($Result.data.email)" -Variant body1
                            New-UDTypography -Text "$($Result.data.first_name)" -Variant body1
                            New-UDTypography -Text "$($Result.data.last_name)" -Variant body1
                        }
                    }
                }
            }
        }
        New-UDTableColumn -Property 'email' -Title 'Email' -IncludeInSearch
        New-UDTableColumn -Property 'first_name' -Title 'First Name' -IncludeInSearch
        New-UDTableColumn -Property 'last_name' -Title 'Last Name' -IncludeInSearch
        New-UDTableColumn -Property 'avatar' -Title 'Avatar' -OnRender {
            New-UDAvatar -Alt $EventData.avatar -Image $EventData.avatar -Variant rounded
        }
    )

    New-UDDynamic -Id 'UserManagement' -Content {
        New-UDTypography -Text "Page $($Cache:CurrentPage) of $($Cache:UserManagement.total_pages)" -Variant h6
        New-UDTable -Data ($Cache:UserManagement.Data) -Columns $Columns -ShowSearch -Dense
    }
}
