<#compress>
<#--
Copyright (C) 2016 - 2025 Order of the Bee

This file is part of OOTBee Support Tools

OOTBee Support Tools is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

OOTBee Support Tools is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with OOTBee Support Tools. If not, see <http://www.gnu.org/licenses/>.

Linked to Alfresco
Copyright (C) 2005 - 2025 Alfresco Software Limited.

  -->
<#escape x as jsonUtils.encodeJSONString(x)>
{
    "startTime": "${startTime}",
    "upTime": "${upTime}",
    "javaArguments": [
        <#list javaArguments as javaArgument>
        "${sanitizeEnvValWithDashD(javaArgument, sensitiveKeys)}"<#if javaArgument_has_next>,</#if>
        </#list>
    ],
    "bootClassPath": [
        <#list bootClassPath as bootClassPathEntry>
        "${bootClassPathEntry}"<#if bootClassPathEntry_has_next>,</#if>
        </#list>
    ],
    "globalProperties": [
        <#if globalProperties?has_content>
        <#list globalProperties?keys?sort as key>
        { "key": "${key}", "value": "${sanitizeValue(key, globalProperties[key], sensitiveKeys)}" }<#if key_has_next>,</#if>
        </#list>
        </#if>
    ],
    "systemProperties": [
        <#if systemProperties?has_content>
        <#list systemProperties?keys?sort as key>
        { "key": "${key}", "value": "${sanitizeValue(key, systemProperties[key], sensitiveKeys)}" }<#if key_has_next>,</#if>
        </#list>
        </#if>
    ],
    "environmentProperties": [
        <#if environmentProperties?has_content>
        <#list environmentProperties?keys?sort as key>
        { "key": "${key}", "value": "${sanitizeEnv(key, environmentProperties[key], sensitiveKeys)}" }<#if key_has_next>,</#if>
        </#list>
        </#if>
    ]
}
</#escape>
</#compress>

<#function sanitizeValue key val sensitiveKeys>
    <#local res = val />
    <#local keySensitive = false />
    <#list sensitiveKeys as sensitiveKey>
        <#if !keySensitive && sensitiveKey?trim?has_content>
            <#local keySensitive = key?lower_case?ends_with(sensitiveKey?trim?lower_case)/>
        </#if>
    </#list>
    <#if keySensitive>
        <#local res = "***" />
    </#if>
    <#return res />
</#function>

<#function textUntilNextQuote text>
    <#local res = "" />
    <#local nextEscapedQuot = text?index_of('\\"') />
    <#local nextQuot = text?index_of('"') />
    <#if nextEscapedQuot &gt; 0 && (nextQuot == nextEscapedQuot + 1 || nextQuot &gt; nextEscapedQuot + 1)>
        <#local res = text?substring(0, nextEscapedQuot + 2) + textUntilNextQuote(text?substring(nextEscapedQuot + 2)) />
    <#elseif nextQuot != -1>
        <#local res = text?substring(0, nextQuot) />
    <#else>
        <#local res = text />
    </#if>
    <#return res />
</#function>

<#function textUntilNextWs text>
    <#local res = "" />
    <#local nextEscapedWs = text?index_of("\\ ") />
    <#local nextWs = text?index_of(" ") />
    <#if nextEscapedWs &gt; 0 && (nextWs == nextEscapedWs + 1 || nextWs &gt; nextEscapedWs + 1)>
        <#local res = text?substring(0, nextEscapedWs + 2) + textUntilNextWs(text?substring(nextEscapedWs + 2)) />
    <#elseif nextWs != -1>
        <#local res = text?substring(0, nextWs) />
    <#else>
        <#local res = text />
    </#if>
    <#return res />
</#function>

<#function sanitizeEnvValWithDashD text sensitiveKeys>
    <#local res = "" />
    <#if text?has_content>
        <#local nextDashD = text?index_of("-D") />
        <#local nextDashDQuot = text?index_of('"-D') />
        <#local remainder = "" />

        <#if nextDashD == 0>
            <#local dashDKeyVal = textUntilNextWs(text) />
            <#if text?length &gt; dashDKeyVal?length>
                <#local remainder = text?substring(dashDKeyVal?length + 1) />
            </#if>
            <#local valSep = dashDKeyVal?index_of("=") />
            <#if valSep != -1>
                <#local key = dashDKeyVal?substring(2, valSep) />
                <#local val = dashDKeyVal?substring(valSep + 1) />
                <#local res = "-D" + key + "=" + sanitizeValue(key, val, sensitiveKeys) + " " />
            <#else>
                <#local res = dashDKeyVal + " " />
            </#if>
        <#elseif nextDashDQuot == 0>
            <#local dashDKeyVal = textUntilNextQuote(text?substring(1)) />
            <#if text?length &gt; dashDKeyVal?length + 1>
                <#local remainder = text?substring(1 + dashDKeyVal?length + 1) />
            </#if>
            <#local valSep = dashDKeyVal?index_of("=") />
            <#if valSep != -1>
                <#local key = dashDKeyVal?substring(2, valSep) />
                <#local val = dashDKeyVal?substring(valSep + 1) />
                <#local res = '"-D' + key + "=" + sanitizeValue(key, val, sensitiveKeys) + '"' />
            <#else>
                <#local res = '"' + dashDKeyVal + '"' />
            </#if>
        <#elseif text?starts_with(" ")>
            <#if text?length &gt; 1>
                <#local remainder = text?substring(1) />
            </#if>
            <#local res = " " />
        <#elseif text?starts_with('"')>
            <#local quotText = textUntilNextQuote(text?substring(1)) />
            <#if text?length &gt; quotText?length + 1>
                <#local remainder = text?substring(1 + quotText?length + 1) />
            </#if>
            <#local res = '"' + quotText + '"' />
        <#else>
            <#local anyText = textUntilNextWs(text) />
            <#if text?length &gt; anyText?length>
                <#local remainder = text?substring(anyText?length + 1) />
            </#if>
            <#local res = anyText + " " />
        </#if>
        <#if remainder?has_content>
            <#local res = res +  sanitizeEnvValWithDashD(remainder, sensitiveKeys) />
        </#if>
    </#if>
    <#return res />
</#function>

<#function sanitizeEnv key val sensitiveKeys>
    <#local res = val />
    <#if val?index_of(" -D") == 0 || val?index_of("-D") != -1>
        <#local res = sanitizeEnvValWithDashD(val, sensitiveKeys) />
    <#else>
        <#local res = sanitizeValue(key, val, sensitiveKeys) />
    </#if>
    <#return res />
</#function>
