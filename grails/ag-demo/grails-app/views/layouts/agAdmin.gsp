<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><g:layoutTitle default="Admin"/></title>

    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">

    <asset:javascript src="app.js"/>
    <asset:stylesheet href="style.css"/>
    <g:layoutHead/>

    <style>
    body {
        padding-top: 40px;
    }
    </style>
</head>

<body data-context-path="${request.contextPath}"
      data-resource-name="${pageProperty(name: 'body.data-resource-name')}"
      data-resource-path="${pageProperty(name: 'body.data-resource-path')}">

<div class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${request.contextPath}">Example Admin</a>

            <div class="navbar-collapse collapse">
                <ul class="navbar-nav nav">
                    <li><a href="${createLink(controller: 'user')}">List Users</a></li>
                    <li><a href="${createLink(controller: 'org')}">List Orgs</a></li>
                    <li><a href="${createLink(controller: 'orgTabs')}">List Orgs with Tabs</a></li>
                    <li><a href="${createLink(controller: 'orgShowCase')}">List Org Show Case</a></li>
                </ul>

                <ul class="navbar-nav nav pull-right">
                    <li><a href="#"><i class="fa fa-cogs"></i> Control Panel</a></li>
                    <li class="divider-vertical"></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle " data-toggle="dropdown">
                            <i class="fa fa-user"></i> Joshua Burnett <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="#"><i class="fa fa-user"></i> Account Settings</a>
                            </li>

                            <li>
                                <a href="#"><i class="fa fa-lock"></i> Change Password</a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <a href="#"><i class="fa fa-power-off"></i> Logout</a>
                            </li>
                        </ul>
                    </li>
                    <ag-spinner></ag-spinner>
                </ul>
            </div>
        </div>
</div>

<div id="page" class="container">
    <g:unless test="${hideSidebar}">
        <aside class="sidebar col-sm-3">
            <ul class="nav list-group nav-side">
                <li>
                    %{--TODO figure out why does it breaks the link--}%
                    <a data-toggle="collapse" href="${createLink(controller: 'user')}" class="accordion-toggle">
                        Users<i class="fa fa-chevron-right"></i>
                    </a>

                    <div id="user-submenu" class="collapse accordion-body">
                        <ul class="nav nav-list submenu">
                            <li class=""><a href="${createLink(controller: 'user')}">List Users</a></li>
                            <li><a href="${createLink(controller: 'user')}">Add New User</a></li>
                        </ul>
                    </div>
                </li>
                <li><a href="${createLink(controller: 'org')}">
                    <i class="fa fa-chevron-right"></i> List Orgs</a>
                </li>
                <li><a href="${request.contextPath}">
                    <i class="fa fa-chevron-right"></i> List Orgs with Tabs</a>
                </li>
                <li><a href="${createLink(controller: 'orgShowCase')}">
                    <i class="fa fa-chevron-right"></i> List Org Show Case</a>
                </li>
            </ul>
        </aside>

        <section class="content col-sm-9">
            <g:layoutBody/>
        </section>
    </g:unless>

    <g:else>
        <g:layoutBody/>
    </g:else>
</div>

<r:layoutResources/>
</body>
</html>
