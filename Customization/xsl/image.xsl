<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="java" version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to image nodes only -->
	<xsl:template match="image" mode="image-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">image</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="image-style-rules"/>
		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">image</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="image-structure-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <image>elements
	-->
	<xsl:template name="image-style-rules">
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
		<xsl:variable name="filePath" select="resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="isImageRefAndFileExists" select="java:file-exists($filePath, base-uri())"/>
		<!--
			image-href-ref-file-not-found - <image>- the file linked to must exist
		-->
		<xsl:if test="not($isImageRefAndFileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-href-ref-file-not-found</xsl:with-param>
				<xsl:with-param name="test">not($isImageRefAndFileExist)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<!--
			image-alt-deprecated- The alt attribute is deprecated on image elements
		-->
		<xsl:if test="@alt">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-alt-deprecated</xsl:with-param>
				<xsl:with-param name="test">@alt</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

			<!--
			image-longdescref-deprecated- The longdescref attribute is deprecated on image elements
		-->
		<xsl:if test="@longdescref">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">image-longdescref-deprecated</xsl:with-param>
				<xsl:with-param name="test">@longdescref</xsl:with-param>
			</xsl:call-template>
		</xsl:if>


		
		


	</xsl:template>
</xsl:stylesheet>