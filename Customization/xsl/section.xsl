<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to section nodes only -->
	<xsl:template match="section" mode="section-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">section</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="section-style-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <section>elements
	-->
	<xsl:template name="section-style-rules">
		<!-- For all non-conref'd sections -->
		<xsl:if test="not(@conref)">
			<!--
				section-title-missing - section must have a title
			-->
			<xsl:if test="not(title)">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">section-title-missing</xsl:with-param>
					<xsl:with-param name="test">not(title)</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>