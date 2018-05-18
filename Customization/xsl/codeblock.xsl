<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="java" version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to codeblock nodes only -->
	<xsl:template match="codeblock" mode="codeblock-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">codeblock</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="codeblock-style-rules"/>
	</xsl:template>

	<!-- Apply Rules which	apply to coderef nodes only -->
	<xsl:template match="coderef" mode="coderef-pattern">
		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">coderef</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="coderef-structure-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <codeblock>elements
	-->
	<xsl:template name="codeblock-style-rules">
		<!--
			codeblock-scale-missing <codeblock> must have a scale attribute
		-->
		<xsl:if test="not(@scale)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">codeblock-scale-missing</xsl:with-param>
				<xsl:with-param name="test">not(@scale)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			codeblock-outputclass-missing <codeblock> must have a output class attribute
		-->
		<xsl:if test="not(@outputclass)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">codeblock-outputclass-missing</xsl:with-param>
				<xsl:with-param name="test">not(@outputclass)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		Special Structural Rules for <coderef> elements (e.g. missing links)
	-->
	<xsl:template name="coderef-structure-rules">
		<xsl:variable name="filePath" select="resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="isCodeRefAndFileExists" select="java:file-exists($filePath, base-uri())"/>
		<!--
			coderef-href-ref-file-not-found - <coderef>- the file linked to must exist
		-->
		<xsl:if test="not($isCodeRefAndFileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">coderef-href-ref-file-not-found</xsl:with-param>
				<xsl:with-param name="test">&quot;not($isCodeRefAndFileExists)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>