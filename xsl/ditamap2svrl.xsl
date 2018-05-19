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
		<xsl:apply-templates mode="collection-type-structure-rules" select="//*[@collection-type]"/>
		<xsl:apply-templates mode="chunk-structure-rules" select="//*[@chunk]"/>
		<xsl:apply-templates mode="href-structure-rules" select="//*[@href]"/>
		<xsl:apply-templates mode="navtitle-structure-rules" select="//*[@navtitle]"/>
		<xsl:apply-templates mode="print-structure-rules" select="//*[@print]"/>
		<xsl:apply-templates mode="query-structure-rules" select="//*[@query]"/>

		<xsl:apply-templates mode="keyref-structure-rules" select="//navref[@keyref]"/>
		<xsl:apply-templates mode="locktitle-structure-rules" select="//topichead[@locktitle]"/>
		<xsl:apply-templates mode="locktitle-structure-rules" select="//topicgroup[@locktitle]"/>


		<xsl:apply-templates mode="appendices-structure-rules" select="//appendices"/>
		<xsl:apply-templates mode="chapter-structure-rules" select="//chapter"/>
		<xsl:apply-templates mode="map-structure-rules" select="//map"/>
		<xsl:apply-templates mode="notices-structure-rules" select="//notices"/>
		<xsl:apply-templates mode="topicref-structure-rules" select="//topicref"/>
		
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="href-style-rules" select="//*[@href]"/>

	</xsl:template>

	<xsl:template match="*[@chunk]" mode="chunk-structure-rules">
		<xsl:if test="@chunk = 'to-navigation'">
		<!--
			chunk-to-navigation-deprecated - The value to-navigation
			 is deprecated on chunk attributes
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">chunk-to-navigation-deprecated</xsl:with-param>
			<xsl:with-param name="test">@chunk = 'to-navigation'</xsl:with-param>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@collection-type]" mode="collection-type-structure-rules">
		<xsl:if test="name() = 'reltable'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">reltable-collection-type-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'reltable'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="name() = 'relcolspec'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">relcolspec-collection-type-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'relcolspec'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="name() = 'linkpool' and @collection-type='tree'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">linkpool-collection-type-tree-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'linkpool'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="name() = 'linklist' and @collection-type='tree'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">linklist-collection-type-tree-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'linklist'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="map[@title]" mode="map-structure-rules">
		<!--
			map-title-deprecated - The title attribute is deprecated on map elements
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">map-title-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='map' and @title</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="navref[@keyref]" mode="keyref-structure-rules">
		<!--
			navref-keyref-deprecated - The keyref element is deprecated on navref elements
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">navref-keyref-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='navref' and @keyref</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="topichead[@locktitle]" mode="locktitle-structure-rules">
		<!--
			topichead-locktitle-deprecated - The locktitle element is deprecated on topichead elements
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">topichead-locktitle-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='topichead' and @locktitle</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="topicgroup[@locktitle]" mode="locktitle-structure-rules">
		<!--
			topicgroup-locktitle-deprecated - The locktitle element is deprecated on topicgroup elements
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">topicgroup-locktitle-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='topicgroup' and @locktitle</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[@navtitle]" mode="navtitle-structure-rules">
		<!--
			navtitle-deprecated - The navtitle attribute is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">navtitle-deprecated</xsl:with-param>
			<xsl:with-param name="test">@navtitle</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[@print]" mode="print-structure-rules">
		<!--
			print-deprecated - The print attribute is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">print-deprecated</xsl:with-param>
			<xsl:with-param name="test">@print</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[@query]" mode="query-structure-rules">
		<!--
			query-deprecated - The query attribute is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">query-deprecated</xsl:with-param>
			<xsl:with-param name="test">@query</xsl:with-param>
		</xsl:call-template>
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
		<xsl:variable name="isWWWRef" select="starts-with(@href, 'http://') or starts-with(@href, 'https://')"/>

		<xsl:if test="not($isWWWRef)">
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