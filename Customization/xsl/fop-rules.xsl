<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which apply to a selection of nodes which can result in an invalid PDF	-->
	<xsl:template match="*" mode="fop-pattern">
		<!-- structure rules -->
		<xsl:if test="(//row[@product])|(//li[@product])|(//tgroup)">
			<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">fop</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
			<xsl:apply-templates mode="row-fop-rules" select="//row[@product]"/>
			<xsl:apply-templates mode="li-fop-rules" select="//li[@product]"/>
			<xsl:apply-templates mode="tgroup-fop-rules" select="//tgroup"/>
		</xsl:if>
	</xsl:template>
	<!--
    FOP <tgroup>Structure Rules - invalid table structures.
  -->
	<xsl:template match="tgroup" mode="tgroup-fop-rules">
		<xsl:variable name="cols" select="@cols"/>
		<xsl:variable name="cols-count" select="count(./colspec)"/>
		<xsl:variable name="conref-cols-count" select="count(./colspec[@conref])"/>
		<!--
				tgroup-cols-colspec-mismatch - <tgroup>mismatch - cols attribute does not match the actual number of colspec elements
		-->
		<xsl:if test="$cols-count &gt; 0 and not(number($cols) = $cols-count) and $conref-cols-count = 0">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">tgroup-cols-colspec-mismatch</xsl:with-param>
				<xsl:with-param name="test">not($cols = $cols-count)</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="$cols-count"/>
				<xsl:with-param name="param2" select="$cols"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			colspec-colnum-not-unique - Within each <tgroup>, <colspec colnum="x">must be unique
		-->
		<xsl:for-each select="colspec">
			<xsl:variable name="colnum" select="@colnum"/>
			<xsl:variable name="col-count" select="count(../colspec[@colnum=$colnum])"/>
			<xsl:if test="$col-count &gt; 1">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">colspec-colnum-not-unique</xsl:with-param>
					<xsl:with-param name="test">$col-count &gt; 1</xsl:with-param>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="$colnum"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<!--
			tgroup-cols-entry-mismatch - cols="x" but y <entry>elements found <row>
		-->
		<xsl:for-each select="tbody/row">
			<xsl:variable name="entries-count" select="count(entry)"/>
			<xsl:if test="number($cols) &lt; $entries-count">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">tgroup-cols-entry-mismatch</xsl:with-param>
					<xsl:with-param name="test">number($cols) &lt; $entries-count</xsl:with-param>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="$entries-count"/>
					<xsl:with-param name="param2" select="$cols"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!--
    	FOP <row>Structure Rules - empty tables
	-->
	<xsl:template match="row" mode="row-fop-rules">
		<xsl:variable name="product-id" select="@product"/>
		<xsl:variable name="table-row-count" select="count(../row)"/>
		<xsl:variable name="external-row-count" select="count(../row[not(@audience='internal')])"/>
		<xsl:variable name="product-row-count" select="count(../row[@product=$product-id])"/>
		<xsl:variable name="internal-row-count" select="count(../row[@product=$product-id and @audience='internal'])"/>
		<!--
			table-all-rows-filtered	- <table>If an element contains filtered sub elements, they must not be all of the filter type.
		-->
		<xsl:if test="(($table-row-count = $product-row-count) or (($internal-row-count = $product-row-count) and ($external-row-count = 0))) and not(ancestor::topic/@id = 'topic-apiref') ">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">table-all-rows-filtered</xsl:with-param>
				<xsl:with-param name="test">(($table-row-count = $product-row-count) or (($internal-row-count = $product-row-count) and ($external-row-count = 0))) </xsl:with-param>
				<!-- Placeholders -->
				<xsl:with-param name="param1" select="./@product"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		FOP <li>Structure Rules - empty filtered lists
	-->
	<xsl:template match="li" mode="li-fop-rules">
		<xsl:variable name="product-id" select="@product"/>
		<xsl:variable name="list-li-count" select="count(../li)"/>
		<xsl:variable name="external-li-count" select="count(../li[not(@audience='internal')])"/>
		<xsl:variable name="product-li-count" select="count(../li[@product=$product-id])"/>
		<xsl:variable name="internal-li-count" select="count(../li[@product=$product-id and @audience='internal'])"/>
		<!--
			ul-with-no-li-elements	- <ul>If an element contains filtered sub elements,	they must not be all of the filter type.
		-->
		<xsl:if test="(($list-li-count = $product-li-count) or (($internal-li-count = $product-li-count) and ($external-li-count = 0)))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">list-all-li-filtered</xsl:with-param>
				<xsl:with-param name="test">($list-li-count = $product-li-count) or (($internal-li-count = $product-li-count) and ($external-li-count = 0)))</xsl:with-param>
				<!-- Placeholders -->
				<xsl:with-param name="param1" select="./@product"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>