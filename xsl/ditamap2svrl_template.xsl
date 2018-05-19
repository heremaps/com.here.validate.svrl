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
<xsl:stylesheet version="2.0" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Import the standard com.here.validate.svrl ruleset -->
	<xsl:import href="plugin:com.here.validate.svrl:xsl/ditamap2svrl.xsl"/>
	<!--
			To override a set of rules, uncomment one or more of the rule groups defined below
			see the com.here.validate.svrl.override plugin for an example usage.
	-->
	<!--xsl:import href="../Customization/xsl/topic.xsl"/-->
</xsl:stylesheet>