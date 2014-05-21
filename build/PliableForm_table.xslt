<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>
<xsl:param name="formNodeId" select="/macro/formNode" />
<xsl:param name="jQuery" select="/macro/jQuery" />
<xsl:variable name="prefix">p</xsl:variable>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="number($formNodeId) &gt; 0">
      <xsl:call-template name="renderForm">
        <xsl:with-param name="formPage" select="umbraco.library:GetXmlNodeById($formNodeId)" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="renderForm">
        <xsl:with-param name="formPage" select="$currentPage" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="renderForm">
  <xsl:param name="formPage" />
  <xsl:if test="count($formPage/* [pliableField]) &gt; 0">
    <div id="PliableForm">
      <xsl:value-of select="$formPage/formContent" disable-output-escaping="yes" />
      <table>
        <xsl:for-each select="$formPage/* [pliableField]">
          <xsl:variable name="name" select="@nodeName" />
          <tr>
            <xsl:choose>
              <xsl:when test="name() = 'PliableText'">
                <td class="label">
                  <xsl:if test="string-length(label) &gt; 0">
                    <label for="{$prefix}_{@id}">
                      <xsl:value-of select="label" disable-output-escaping="yes" />
                    </label>
                  </xsl:if>
                </td>
                <td class="input">
                  <xsl:variable name="className">
                    <xsl:text>pText</xsl:text>
                    <xsl:if test="string-length(class) &gt; 0">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="class" />
                    </xsl:if>
                    <xsl:if test="string-length(defaultValue) &gt; 0 and placeholder = '1'">
                      <xsl:text> placeholder</xsl:text>
                    </xsl:if>
                    <xsl:if test="string(required) = '1'">
                      <xsl:text> pRequiredText</xsl:text>
                    </xsl:if>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="string(multipleLine) != '1'">
                      <input type="text" id="{$prefix}_{@id}" name="{$name}" class="{$className}">
                        <xsl:if test="string-length(defaultValue) &gt; 0">
                          <xsl:attribute name="value">
                            <xsl:value-of select="defaultValue" />
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length(regexValidation) &gt; 0">
                          <xsl:attribute name="data-validation">
                            <xsl:value-of select="regexValidation" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <textarea id="{$prefix}_{@id}" name="{$name}" class="{$className}">
                        <xsl:if test="string-length(regexValidation) &gt; 0">
                          <xsl:attribute name="data-validation">
                            <xsl:value-of select="regexValidation" />
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length(defaultValue) &gt; 0">
                          <xsl:value-of select="defaultValue" />
                        </xsl:if>
                      </textarea>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="errorMessage">
                  <xsl:if test="string(required) = '1' and string-length(errorMessage) &gt; 0">
                    <xsl:text> </xsl:text>
                    <span class="pErrorMessage" id="{$prefix}_{@id}_error" style="display:none">
                      <xsl:value-of select="errorMessage" />
                    </span>
                  </xsl:if>
                </td>
              </xsl:when>
              <xsl:when test="name() = 'PliableSelect'">
                <td class="label">
                  <xsl:if test="string-length(label) &gt; 0">
                    <label for="{$prefix}_{@id}">
                      <xsl:value-of select="label" disable-output-escaping="yes" />
                    </label>
                  </xsl:if>
                </td>
                <td class="input">
                  <xsl:variable name="className">
                    <xsl:text>pSelect</xsl:text>
                    <xsl:if test="string-length(class) &gt; 0">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="class" />
                    </xsl:if>
                    <xsl:if test="string(required) = '1'">
                      <xsl:text> pRequiredSelect</xsl:text>
                    </xsl:if>
                  </xsl:variable>
                  <select id="{$prefix}_{@id}" name="{$name}" class="{$className}">
                    <xsl:if test="string(multipleSelections) = '1'">
                      <xsl:attribute name="multiple">multiple</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="textWithBrs" select="umbraco.library:Replace(umbraco.library:ReplaceLineBreaks(optionsAndValues),'&#xA;','')" />
                    <xsl:variable name="textWithLts" select="umbraco.library:Replace($textWithBrs, '&lt;br/&gt;', '&lt;')" />
                    <xsl:for-each select="umbraco.library:Split($textWithLts,'&lt;')/value">
                      <option>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="contains(.,'&gt;')">
                              <xsl:value-of select="substring-after(current(),'&gt;')" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="current()" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="contains(.,'&gt;')">
                            <xsl:value-of select="substring-before(current(),'&gt;')" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="current()" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </option>
                    </xsl:for-each>
                  </select>
                </td>
                <td class="errorMessage">
                  <xsl:if test="string(required) = '1' and string-length(errorMessage) &gt; 0">
                    <xsl:text> </xsl:text>
                    <span class="pErrorMessage" id="{$prefix}_{@id}_error" style="display:none">
                      <xsl:value-of select="errorMessage" />
                    </span>
                  </xsl:if>
                </td>
              </xsl:when>
              <xsl:when test="name() = 'PliableCheckbox'">
                <td class="label">
                  <xsl:if test="string-length(label) &gt; 0">
                    <label for="{$prefix}_{@id}">
                      <xsl:value-of select="label" disable-output-escaping="yes" />
                    </label>
                  </xsl:if>
                </td>
                <td class="input">
                  <xsl:variable name="className">
                    <xsl:text>pCheckbox</xsl:text>
                    <xsl:if test="string-length(class) &gt; 0">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="class" />
                    </xsl:if>
                    <xsl:if test="string(required) = '1'">
                      <xsl:text> pRequiredCheckbox</xsl:text>
                    </xsl:if>
                  </xsl:variable>
                  <input type="checkbox" id="{$prefix}_{@id}" name="{$name}" class="{$className}">
                    <xsl:if test="string(checked) = '1'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
                <td class="errorMessage">
                  <xsl:if test="string(required) = '1' and string-length(errorMessage) &gt; 0">
                    <xsl:text> </xsl:text>
                    <span class="pErrorMessage" id="{$prefix}_{@id}_error" style="display:none">
                      <xsl:value-of select="errorMessage" />
                    </span>
                  </xsl:if>
                </td>
              </xsl:when>
              <xsl:when test="name() = 'PliableRadioList'">
                <td class="label">
                  <xsl:if test="string-length(label) &gt; 0">
                    <xsl:value-of select="label" disable-output-escaping="yes" />
                  </xsl:if>
                </td>
                <td class="input">
                  <span id="{$prefix}_{@id}">
                    <xsl:if test="string(required) = '1'">
                      <xsl:attribute name="class">pRequiredRadioList</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="nodeId" select="@id" />
                    <xsl:variable name="textWithBrs" select="umbraco.library:Replace(umbraco.library:ReplaceLineBreaks(labelsAndValues),'&#xA;','')" />
                    <xsl:variable name="textWithLts" select="umbraco.library:Replace($textWithBrs, '&lt;br/&gt;', '&lt;')" />
                    <xsl:variable name="className" select="class" />
                    <xsl:for-each select="umbraco.library:Split($textWithLts,'&lt;')/value">
                      <span class="{$className}">
                        <input type="radio" name="{$name}" id="{$prefix}{position()}_{$nodeId}" class="pRadio {$className}">
                          <xsl:attribute name="value">
                            <xsl:choose>
                              <xsl:when test="contains(.,'&gt;')">
                                <xsl:value-of select="substring-after(current(),'&gt;')" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="current()" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                        </input>
                        <label for="{$prefix}{position()}_{$nodeId}">
                          <xsl:choose>
                            <xsl:when test="contains(.,'&gt;')">
                              <xsl:value-of select="substring-before(current(),'&gt;')" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="current()" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </label>
                      </span>
                    </xsl:for-each>
                  </span>
                </td>
                <td class="errorMessage">
                  <xsl:if test="string(required) = '1' and string-length(errorMessage) &gt; 0">
                    <xsl:text> </xsl:text>
                    <span class="pErrorMessage" id="{$prefix}_{@id}_error" style="display:none">
                      <xsl:value-of select="errorMessage" />
                    </span>
                  </xsl:if>
                </td>
              </xsl:when>
              <xsl:when test="name() = 'PliableCheckboxList'">
                <td class="label">
                  <xsl:if test="string-length(label) &gt; 0">
                    <xsl:value-of select="label" disable-output-escaping="yes" />
                  </xsl:if>
                </td>
                <td class="input">
                  <span id="{$prefix}_{@id}">
                    <xsl:variable name="nodeId" select="@id" />
                    <xsl:variable name="textWithBrs" select="umbraco.library:Replace(umbraco.library:ReplaceLineBreaks(labelsAndValues),'&#xA;','')" />
                    <xsl:variable name="textWithLts" select="umbraco.library:Replace($textWithBrs, '&lt;br/&gt;', '&lt;')" />
                    <xsl:variable name="className" select="class" />
                    <xsl:for-each select="umbraco.library:Split($textWithLts,'&lt;')/value">
                      <span class="{$className}">
                        <input type="checkbox" name="{$name}" id="{$prefix}{position()}_{$nodeId}" class="pCheckboxList {$className}">
                          <xsl:attribute name="value">
                            <xsl:choose>
                              <xsl:when test="contains(.,'&gt;')">
                                <xsl:value-of select="substring-after(current(),'&gt;')" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="current()" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                        </input>
                        <label for="{$prefix}{position()}_{$nodeId}">
                          <xsl:choose>
                            <xsl:when test="contains(.,'&gt;')">
                              <xsl:value-of select="substring-before(current(),'&gt;')" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="current()" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </label>
                      </span>
                    </xsl:for-each>
                  </span>
                </td>
                <td class="errorMessage"></td>
              </xsl:when>
            </xsl:choose>
          </tr>
        </xsl:for-each>
      </table>
      <p><input type="button" value="{$formPage/submitButtonText}" class="pSubmit" /></p>
    </div>
    
    <xsl:if test="number($formPage/loadingImage) &gt; 0">
      <xsl:variable name="img" select="umbraco.library:GetMedia($formPage/loadingImage,0)" />
      <div id="PliableForm_loading" style="display:none">
        <img src="{$img/umbracoFile}" alt="{$img/@nodeName}" />
      </div>
    </xsl:if>
    
    <div id="PliableForm_success" style="display:none">
      <xsl:value-of select="$formPage/successContent" disable-output-escaping="yes" />
    </div>
    
    <div id="PliableForm_error" style="display:none">
      <xsl:value-of select="$formPage/errorContent" disable-output-escaping="yes" />
    </div>
    
    <input id="PliableForm_id" type="hidden" value="{$formPage/@id}" />
              
    <xsl:if test="$jQuery = '1'">
      <!-- <xsl:value-of select="umbraco.library:AddJquery()"/> -->
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
    </xsl:if>
    <script type="text/javascript" src="/scripts/PliableForm.js"></script>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>