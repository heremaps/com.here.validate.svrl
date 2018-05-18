<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="java" version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to xref nodes only -->
	<xsl:template match="xref" mode="xref-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">xref</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="xref-style-rules"/>
		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">xref</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="xref-structure-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <xref>elements
	-->
	<xsl:template name="xref-style-rules">
		<!--
			xref-no-format - <xref> Any xref referencing a URL should have a format property
							 <xref> Any file reference should have a format property
							 <xref> Any other element using a href should have a format property
		-->
		<xsl:if test="not(@format) and not(@keyref)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-no-format</xsl:with-param>
				<xsl:with-param name="test">not(@format)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		Special Structural Rules for <xref> elements (e.g. missing links)
	-->
	<xsl:template name="xref-structure-rules">
		<xsl:variable name="isIdRef" select="starts-with(@href, '#') and not(contains(@href, '/'))"/>
		<xsl:variable name="isIdIdRef" select="starts-with(@href, '#') and contains(@href, '/')"/>
		<xsl:variable name="isWWWRef" select="starts-with(@href, 'http://') or starts-with(@href, 'https://')"/>
		<xsl:variable name="isFileRef" select="not($isWWWRef) and not(starts-with(@href, '#')) and not(contains(@href, 'file:/')) and not(contains(@href, 'mailto'))"/>
		<xsl:variable name="idRefPart" select="if (contains(@href, '#')) then substring-after(@href, '#') else false()"/>
		<xsl:variable name="idRef" select="if (boolean($idRefPart)) then (if (contains($idRefPart, '/')) then substring-before($idRefPart, '/') else $idRefPart) else false()"/>
		<xsl:variable name="idIdRef" select="if ($idRefPart) then substring-after($idRefPart, '/') else false()"/>
		<xsl:variable name="filePath" select="if (contains(@href, '#'))  then resolve-uri(substring-before(@href, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
		<xsl:variable name="isFileRefAndFileExists" select="if ($isFileRef and $file) then java:file-exists($filePath, base-uri()) else false()"/>
		<!--
			xref-internal-id-not-found - <xref>For an href within a single file, the ID linked to must exist
		-->
		<xsl:if test="$isIdRef and not(//*/@id = $idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-internal-id-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			xref-internal-path-not-found - <xref>For an href within a single file, the path linked to must exist
		-->
		<xsl:if test="$isIdIdRef and not(//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-internal-path-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			xref-external-file-not-found - <xref>For an href to an another file within the document, the file linked to must exist
		-->
		<xsl:if test="$isFileRef and not($isFileRefAndFileExists) and not(@keyref)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-external-file-not-found</xsl:with-param>
				<xsl:with-param name="test">not($isFileRefAndFileExists)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			Checks for cross-references to external files only.
		-->
		<xsl:if test="$isFileRefAndFileExists and $idRef">
			<xsl:choose>
				<!--
					xref-external-id-not-found - <xref>For an href to an another file within the document, the ID linked to must exist
				-->
				<xsl:when test="not($idIdRef) and not(document($filePath)//*/@id = $idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">xref-external-id-not-found</xsl:with-param>
						<xsl:with-param name="test">not($idIdRef) and not(document($filePath)//*/@id = $idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!--
					xref-external-path-not-found - <xref>For an href to an another file within the document, the path linked to must exist
				-->
				<xsl:when test="$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">xref-external-path-not-found</xsl:with-param>
						<xsl:with-param name="test">$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<!--
			xref-www-format-invalid <xref>A link to an external URL outside of the document cannot have format="dita"
		-->
		<xsl:if test="contains(@href, ':') and @format = 'dita'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-www-format-invalid</xsl:with-param>
				<xsl:with-param name="test">contains(@href, ':') and @format = 'dita'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			xref-www-scope-invalid  <xref>A link to an external URL outside of the document requires scope="external"
		-->
		<xsl:if test="contains(@href, ':') and not(@scope = 'external')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">xref-www-scope-invalid</xsl:with-param>
				<xsl:with-param name="test">&quot;contains(@href, ':') and not(@scope = 'external')</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>