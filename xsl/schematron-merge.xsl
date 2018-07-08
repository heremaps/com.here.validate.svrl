<?xml version="1.0" ?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that merges .svrl results file outputted from validate.xsl into
	a single .svrl so it can be easily printed to the screen using
	iso-schematron-svrl-to-message
-->
<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://saxon.sf.net/" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Defining that this .xsl generates an indented, UTF8-encoded XML file -->
	<xsl:output encoding="utf-8" indent="yes" method="xml" omit-xml-declaration="no" standalone="yes"/>
	<xsl:param name="in">.</xsl:param>
	<xsl:param name="extension">svrl</xsl:param>
	<xsl:param name="out">results.svrl</xsl:param>
	<!--
		XSLT engine only accept file path that start with 'file:/'

		In the code below we ensure that $in parameter that hold input path to
		where the *.svrl files file which have to be merge into single .svrl file
		is in a format
	-->
	<xsl:variable name="path">
		<xsl:choose>
			<xsl:when test="not(starts-with($in,'file:')) and not(starts-with($in,'/')) ">
				<xsl:value-of select="translate(concat('file:/', $in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:when>
			<xsl:when test="starts-with($in,'/')">
				<xsl:value-of select="translate(concat('file:', $in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(concat($in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Copies defined xmlns above for this xsl into a variable -->
	<xsl:variable name="namespaces" select="document('')/*/namespace::*"/>
	<!-- Template to once execute generate-svrl template -->
	<xsl:template match="/">
		<xsl:call-template name="generate-svrl"/>
	</xsl:template>
	<!--
		Template that generates the single .svrl file by copying contents
		of all .svrl files found in directory specified by $path
	-->
	<xsl:template name="generate-svrl">
		<xsl:element name="svrl:schematron-output">
			<!-- xsl:copy-of copies all namespaces -->
			<xsl:copy-of select="$namespaces"/>
			<!-- xsl:copy-of select="@*" is the standard way of copying all attributes. -->
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="collection($path)">
				<!-- xsl:copy-of copies nodes and all their descendants -->
				<xsl:apply-templates select="document(document-uri(.))/schematron-output/node()" mode="schematron-output"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="node()|@*" mode="schematron-output">
		 <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="schematron-output"/>
        </xsl:copy>
	</xsl:template>
</xsl:stylesheet>