<?xml version="1.0" ?>
<!--
   This file is part of the DITA Validator project.
   See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that creates an ANT build script based on the dita errors.
-->
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no"/>

	<xsl:param as="xs:string" name="SOURCE"/>
	<xsl:param name="FIXABLE_RULESET">a^</xsl:param>

	<xsl:template match="/">
		<project default="auto-correct" name="validator.auto-correct">
			<target name="auto-correct">

				<init/>
				<xsl:apply-templates mode="stuff" select="//failed-assert"/>
			</target>
		</project>
	</xsl:template>
	<!--
		Template to add each error found as a replaceregex entry.
	-->
	<xsl:template match="*" mode="stuff">
		<xsl:variable name="macro"><xsl:value-of select="./diagnostic-reference/@diagnostic"/>
		</xsl:variable>
		<xsl:if test="matches ($macro, $FIXABLE_RULESET)">
			<xsl:element name="{$macro}">
				<xsl:attribute name="file">
					<xsl:value-of select="$SOURCE"/>
					<xsl:value-of select="preceding-sibling::active-pattern[1]/@name"/>		
				</xsl:attribute>
				<xsl:attribute name="path">
					<xsl:value-of select="@location"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>