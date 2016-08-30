<?xml version="1.0" ?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->

<!--
	Stylesheet that prints the total number of errors encountered.
-->
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">


	<xsl:param name="MODE" select="'default'" as="xs:string"/>

	<!-- Defining that this .xsl generates plain text file -->
	<xsl:output omit-xml-declaration="yes" indent="yes" method="text"/>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$MODE = 'report-only'" >
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="not($MODE = 'strict')" >
						<!-- Fail on Errors and Fatals -->
						<xsl:value-of select="count(//failed-assert[@role='error' or @role='fatal'])"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Fail on Warnings, Errors and Fatals -->
						<xsl:value-of select="count(//failed-assert)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>