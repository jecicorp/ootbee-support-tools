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

<#macro renderOptionModel optionModel>
<#if optionModel??>
{
    "required": ${optionModel.required?c}
    <#if optionModel.groupElements??>
    , "groupElements": [
        <#list optionModel.groupElements as element>
        <#if element.name??>
        {
            "name": "${element.name}",
            "required": ${element.required?c}
        }
        <#elseif element.groupElements??>
        <@renderOptionModel optionModel=element />
        </#if>
        <#if element_has_next>,</#if>
        </#list>
    ]
    </#if>
}
<#else>
null
</#if>
</#macro>

<#macro renderRegistryModel registryModel registryType>
{
    "extractableMimetypes": [
        <#list registryModel.extractableMimetypes as mt>"${mt}"<#if mt_has_next>, </#if></#list>
    ],
    "embeddableMimetypes": [
        <#list registryModel.embeddableMimetypes as mt>"${mt}"<#if mt_has_next>, </#if></#list>
    ],
    "transformSourceMimetypes": [
        <#list registryModel.transformSourceMimetypes as mt>"${mt}"<#if mt_has_next>, </#if></#list>
    ],
    "transformTargetMimetypes": [
        <#list registryModel.transformTargetMimetypes as mt>"${mt}"<#if mt_has_next>, </#if></#list>
    ],
    "transformerNames": [
        <#list registryModel.transformerNames as name>"${name}"<#if name_has_next>, </#if></#list>
    ],
    "transformCountsByTransformer": {
        <#assign tcKeys = registryModel.transformCountsByTransformer?keys>
        <#list tcKeys as tName>
        "${tName}": ${registryModel.transformCountsByTransformer[tName]?c}<#if tName_has_next>,</#if>
        </#list>
    },
    "transformsByTransformer": {
        <#assign ttKeys = registryModel.transformsByTransformer?keys>
        <#list ttKeys as tName>
        "${tName}": {
            <#assign sourceKeys = registryModel.transformsByTransformer[tName]?keys>
            <#list sourceKeys as srcMt>
            "${srcMt}": [
                <#assign transforms = registryModel.transformsByTransformer[tName][srcMt]>
                <#list transforms as t>
                {
                    "sourceMimetype": "${t.sourceMimetype}",
                    "targetMimetype": "${t.targetMimetype}",
                    "priority": ${t.priority?c},
                    "maxSourceSizeBytes": ${t.maxSourceSizeBytes?c}
                }<#if t_has_next>,</#if>
                </#list>
            ]<#if srcMt_has_next>,</#if>
            </#list>
        }<#if tName_has_next>,</#if>
        </#list>
    },
    "optionsByTransformer": {
        <#assign otKeys = registryModel.optionsByTransformer?keys>
        <#list otKeys as tName>
        "${tName}": <@renderOptionModel optionModel=registryModel.optionsByTransformer[tName] /><#if tName_has_next>,</#if>
        </#list>
    }
    <#if registryType == "local" && registryModel.remoteUrls??>
    , "remoteUrls": {
        <#assign urlKeys = registryModel.remoteUrls?keys>
        <#list urlKeys as configKey>
        "${configKey}": "${registryModel.remoteUrls[configKey]}"<#if configKey_has_next>,</#if>
        </#list>
    }
    </#if>
    <#if registryType == "remote" && registryModel.remoteUrl??>
    , "remoteUrl": "${registryModel.remoteUrl}"
    </#if>
}
</#macro>

{
    "supportsContentServiceTransformers": ${supportsContentServiceTransformers?c},
    "supportsRenditionService2": ${supportsRenditionService2?c}

    <#if supportsContentServiceTransformers>
    , "transformerNames": [
        <#list transformerNames as name>"${name}"<#if name_has_next>, </#if></#list>
    ]
    , "extensionsAndMimetypes": [
        <#list extensionsAndMimetypes as em>{
            "mimetype": "${em.mimetype}",
            "extension": "${em.extension}"
        }<#if em_has_next>,</#if>
        </#list>
    ]
    </#if>

    <#if supportsRenditionService2>
    , "mimetypes": [
        <#list mimetypes as mt>"${mt}"<#if mt_has_next>, </#if></#list>
    ]
    , "renditionDefinitions": {
        <#assign rdKeys = renditionDefinitions?keys>
        <#list rdKeys as rdName>
        "${rdName}": {
            "targetMimetype": <#if renditionDefinitions[rdName].targetMimetype??>"${renditionDefinitions[rdName].targetMimetype}"<#else>null</#if>
            <#if renditionDefinitions[rdName].transformOptions??>
            , "transformOptions": <#assign tOpts = renditionDefinitions[rdName].transformOptions><#if tOpts?is_hash || tOpts?is_enumerable>{<#assign toKeys = tOpts?keys><#list toKeys as toKey>"${toKey}": "${tOpts[toKey]}"<#if toKey_has_next>, </#if></#list>}<#else>"${tOpts}"</#if>
            </#if>
        }<#if rdName_has_next>,</#if>
        </#list>
    }
    , "hasLocalTransformClient": ${hasLocalTransformClient?c}
    , "localTransformEnabled": ${localTransformEnabled?c}
    , "hasLegacyTransformClient": ${hasLegacyTransformClient?c}
    , "legacyTransformEnabled": ${legacyTransformEnabled?c}
    , "hasSynchronousTransformClient": ${hasSynchronousTransformClient?c}
    , "hasRemoteTransformClient": ${hasRemoteTransformClient?c}
    , "remoteTransformEnabled": ${remoteTransformEnabled?c}

    <#if localTransformServiceRegistryModel??>
    , "localTransformServiceRegistryModel": <@renderRegistryModel registryModel=localTransformServiceRegistryModel registryType="local" />
    </#if>

    <#if remoteTransformServiceRegistryModel??>
    , "remoteTransformServiceRegistryModel": <@renderRegistryModel registryModel=remoteTransformServiceRegistryModel registryType="remote" />
    </#if>
    </#if>
}
</#escape>
</#compress>
