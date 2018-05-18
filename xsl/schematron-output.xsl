<?xml version="1.0" ?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that prints merged .svrl result file with validation issues onto the console
-->
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param as="xs:string" name="MODE" select="'default'"/>
	<!-- Defining that this .xsl generates plain text file -->
	<xsl:output indent="yes" method="text" omit-xml-declaration="yes"/>
	<!--
		Counts number of errors, fatals, warning and info issues found
	-->
	<xsl:variable name="nrErrors">
		<xsl:value-of select="count(//failed-assert[@role='error' or @role='fatal'])"/>
	</xsl:variable>
	<xsl:variable name="nrFatals">
		<xsl:value-of select="count(//failed-assert[@role='fatal'])"/>
	</xsl:variable>
	<xsl:variable name="nrWarnings">
		<xsl:value-of select="count(//failed-assert[@role='warn' or @role='warning'])"/>
	</xsl:variable>
	<xsl:variable name="nrInfos">
		<xsl:value-of select="count(//failed-assert[@role='information' or @role='info'])"/>
	</xsl:variable>
	<xsl:variable name="nrReport">
		<xsl:value-of select="count(//failed-assert[not(@role='information' or @role='info')])"/>
	</xsl:variable>
	<!--
		Based on number of errors, fatals, warning and info issues
		found the message displayed to user with number of issue found
		is changed. In the code below we store the message in variable $report
		so it can be displayed after displaying validation results
	-->
	<xsl:variable name="report">
		<xsl:if test="$MODE = 'report-only'">
			<xsl:text>&#xA;Found </xsl:text><xsl:value-of select="$nrReport"/><xsl:text> Warnings </xsl:text>
		</xsl:if>
		<xsl:if test="not($MODE = 'report-only')">
			<xsl:if test="$nrErrors != 0">
				<xsl:text>&#xA;Found </xsl:text><xsl:value-of select="$nrErrors"/><xsl:text> Errors </xsl:text>
			</xsl:if>
			<xsl:if test="$nrErrors = 0">
				<xsl:text>&#xA;No Errors Found </xsl:text>
			</xsl:if>
			<xsl:if test="$nrFatals!= 0">
				<xsl:text>including </xsl:text><xsl:value-of select="$nrFatals"/><xsl:text> Fatal </xsl:text>
			</xsl:if>
			<xsl:if test="($nrWarnings != 0) and not($MODE = 'lax')">
				<xsl:value-of select="$nrWarnings"/><xsl:text> Warnings </xsl:text><xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="$nrInfos != 0">
				<xsl:value-of select="$nrInfos"/><xsl:text> Info</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:text>&#xA;</xsl:text>
	</xsl:variable>
	<!--
		Execute all templates within this .xsl
		and prints variable $report holding validation results
		to the screen
	-->
	<xsl:template match="/">
		<xsl:apply-templates mode="print" select="//failed-assert"/>
		<xsl:apply-templates mode="print" select="//successful-report"/>
		<xsl:value-of select="$report"/>
	</xsl:template>
	<!-- 
		Prints the validation issue to the console in a specific format
	-->
	<xsl:template name="print-diagnostic">
		<xsl:param name="role"/>
		<xsl:value-of select="$role"/>
		<xsl:text>[</xsl:text>
		<xsl:value-of select="preceding-sibling::active-pattern[1]/@name"/>
		<xsl:text>]&#xa;  </xsl:text>
		<xsl:value-of select="./diagnostic-reference/text()"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<!--
		Template that matches each failed assertion node, <failed-assert>,
		within the results file. For each assertion node found it parses
		its contents of the node and prints in a specific format to the console
	-->
	<xsl:template match="*" mode="print">
		<!-- Convert the value of variable $r, holding type of validation issue to uppercase -->
		<xsl:variable name="r" select="translate(@role, 'WARNING FATAL INFORMATION ERROR', 'warning fatal information error')"/>
		<!-- Set variable role with validation type message depending on the type of the validation issue -->
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="$r='warning' or $r='warn'">
					<xsl:text>[WARN]  </xsl:text>
				</xsl:when>
				<xsl:when test="$r='fatal'">
					<xsl:text>[FATAL] </xsl:text>
				</xsl:when>
				<xsl:when test="$r='error'">
					<xsl:text>[ERROR] </xsl:text>
				</xsl:when>
				<xsl:when test="$r='info' or $r='information'">
					<xsl:text>[INFO]  </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($r='warning' or $r='warn')">
				<xsl:if test="not($MODE = 'lax')">
					<xsl:call-template name="print-diagnostic">
						<xsl:with-param name="role" select="$role"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($MODE = 'report-only')">
					<xsl:call-template name="print-diagnostic">
						<xsl:with-param name="role" select="$role"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$MODE = 'report-only'">
					<xsl:call-template name="print-diagnostic">
						<xsl:with-param name="role">[INFO]  </xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>