<#macro mainLayout>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title!appName}</title>
    <link rel="stylesheet" href="/css/main.css">
    <#if styles??>
    <#list styles as style>
    <link rel="stylesheet" href="${style}">
</#list>
</#if>
</head>
<body>
<#if flashMessage??>
<div class="flash-message ${flashType!'info'}">${flashMessage}</div>
</#if>

<#nested>

<script src="/js/main.js"></script>
<#if scripts??>
<#list scripts as script>
<script src="${script}"></script>
</#list>
</#if>
</body>
</html>
</#macro>