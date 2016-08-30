<?xml version="1.0" encoding="utf-8"?>
<!--
	This file is part of the DITA Validator project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

 <xsl:param name="LEVEL">error</xsl:param>

	<xsl:output omit-xml-declaration="yes" indent="no" method="text"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//ruleset/level[@id=$LEVEL]/rule">
				<xsl:text>^(</xsl:text>
				<xsl:value-of select="//ruleset/level[@id=$LEVEL]/rule" separator="|" />
				<xsl:text>)$</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>a^</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


</xsl:stylesheet>

