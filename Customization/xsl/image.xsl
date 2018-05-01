<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="java" version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to image nodes only -->
	<xsl:template match="image" mode="image-pattern">
		<active-pattern name="image-rules" role="style">
			<xsl:call-template name="image-style-rules"/>
		</active-pattern>
		<active-pattern name="image-rules" role="structure">
			<xsl:call-template name="image-structure-rules"/>
		</active-pattern>
	</xsl:template>
	<!--
		Special Style Rules for <image>elements
	-->
	<xsl:template name="image-style-rules">
		<xsl:call-template name="fired-rule"/>
		<!--
			image-file-type-not-supported - <image>- invalid file extension (only *.jpg, *.jpeg or *.png are allowed)
		-->
		<xsl:if test="not(contains('|jpg|jpeg|png|',concat('|',substring-after(substring(@href,string-length(@href)-4), '.'),'|')))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-file-type-not-supported</xsl:with-param>
				<xsl:with-param name="test">not(contains('|jpg|jpeg|png|',concat('|',substring-after(substring(@href,string-length(@href)-4), '.'),'|')))</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		Special Structural Rules for <image>elements (e.g. missing links)
	-->
	<xsl:template name="image-structure-rules">
		<xsl:call-template name="fired-rule"/>
		<xsl:variable name="filePath" select="resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="tokenize($filePath, '/')[last()]"/>
		<xsl:variable name="isImageRefAndFileExists" select="java:file-exists($filePath, base-uri())"/>
		<!--
			image-href-ref-file-not-found - <image>- the file linked to must exist
		-->
		<xsl:if test="not($isImageRefAndFileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-href-ref-file-not-found</xsl:with-param>
				<xsl:with-param name="test">&quot;not($isImageRefAndFileExist)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>