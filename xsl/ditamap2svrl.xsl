<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that is used to process each *.ditamap file in turn and transform it into
	Schematron Validation Report Language (SVRL) files

	see http://www.schematron.com/validators.html

	Schematron is an ISO/IEC Standard. ISO/IEC 19757-3:2006 Information technology
		Document Schema Definition Language (DSDL) - Part 3: Rule-based validation - Schematron
	The standard is available Royalty-free at the ISO website

	http://standards.iso.org/ittf/PubliclyAvailableStandards/index.html
-->
<xsl:stylesheet exclude-result-prefixes="java saxon" version="2.0" xmlns:java="http://www.java.com/" xmlns:saxon="http://saxon.sf.net/" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Import XSL template that holds a function to some basic SVRL generation functions. -->
	<xsl:import href="schematron.xsl"/>
	<!-- Import XSL template that holds a function to accertain that a file exists using the Java Library. -->
	<xsl:import href="file-exists.xsl"/>
	<!-- Start running the rules across all the base node of the *.ditamap -->
	<xsl:template match="*" mode="ditamap-pattern">
		<xsl:call-template name="active-pattern"/>
		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="href-structure-rules-rules" select="//*[@href]"/>
		<xsl:apply-templates mode="appendices-structure-rules" select="//appendices"/>
		<xsl:apply-templates mode="chapter-structure-rules" select="//chapter"/>
		<xsl:apply-templates mode="notices-structure-rules" select="//notices"/>
		<xsl:apply-templates mode="topicref-structure-rules" select="//topicref"/>
		
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="href-style-rules" select="//*[@href]"/>

	</xsl:template>



	<xsl:template match="*[@href]" mode="href-style-rules">
		<xsl:variable name="file" select="if (contains(@href, '/')) then tokenize(@href, '/')[last()] else @href"/>
		<!--
			href-not-lower-case - For all elements, @href where it exists, filename must be lower case dash and separated.
		-->
		<xsl:if test="matches($file, '[A-Z_]+')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">href-not-lower-case</xsl:with-param>
				<xsl:with-param name="test">matches(@href, '[A-Z_]+')</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@href]" mode="href-structure-rules">
		<xsl:variable name="filePath" select="resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="fileExists" select="java:file-exists($filePath, base-uri())"/>
		<!--
				href-file-not-found - @href - the file linked to must exist
		-->
		<xsl:if test="not($fileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">href-file-not-found</xsl:with-param>
				<xsl:with-param name="test">not($fileExists)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!--PROLOG-->
	<xsl:param as="xs:string" name="IGNORE_RULES"/>
	<xsl:param as="xs:string" name="OUTPUT_RULE-ID" select="true"/>
	<xsl:param as="xs:string" name="SOURCE"/>
	<xsl:param name="DEFAULTLANG">en-us</xsl:param>
	<xsl:param name="FATAL_RULESET">a^</xsl:param>
	<xsl:param name="ERROR_RULESET">a^</xsl:param>
	<xsl:param name="WARNING_RULESET">a^</xsl:param>
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>

	<xsl:include href="../Customization/xsl/topic.xsl"/>
	
	<xsl:template match="/">
		<!--SCHEMA SETUP-->
		<schematron-output schemaVersion="1.5" title="Dita Validation" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
			<xsl:apply-templates mode="ditamap-pattern"/>
		</schematron-output>
	</xsl:template>
</xsl:stylesheet>