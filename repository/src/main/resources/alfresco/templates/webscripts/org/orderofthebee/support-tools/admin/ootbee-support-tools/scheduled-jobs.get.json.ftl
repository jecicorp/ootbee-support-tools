<#compress>
<#escape x as jsonUtils.encodeJSONString(x)>
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

{
    "jobTriggers": [
        <#if jobTriggers??><#list jobTriggers as trigger>{
            "triggerName": "${trigger.triggerName}",
            "triggerGroup": "${trigger.triggerGroup}",
            "triggerState": ${trigger.triggerState?c},
            "jobName": "${trigger.jobName}",
            "jobDisplayName": <#if trigger.jobDisplayName??>"${trigger.jobDisplayName}"<#else>null</#if>,
            "jobGroup": "${trigger.jobGroup}",
            "cronExpression": <#if trigger.cronExpression??>"${trigger.cronExpression}"<#else>null</#if>,
            "cronExpressionDescription": <#if trigger.cronExpressionDescription??>"${trigger.cronExpressionDescription}"<#else>null</#if>,
            "startTime": <#if trigger.startTime??>"${xmldate(trigger.startTime)}"<#else>null</#if>,
            "previousFireTime": <#if trigger.previousFireTime??>"${xmldate(trigger.previousFireTime)}"<#else>null</#if>,
            "nextFireTime": <#if trigger.nextFireTime??>"${xmldate(trigger.nextFireTime)}"<#else>null</#if>,
            "timeZone": <#if trigger.timeZone??>"${trigger.timeZone}"<#else>null</#if>,
            "running": ${trigger.running?c}
        }<#if trigger_has_next>,</#if>
        </#list></#if>
    ]
}
</#escape>
</#compress>
