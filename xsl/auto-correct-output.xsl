<?xml version="1.0" ?>
<!--
   This file is part of the DITA Validator project.
   See the accompanying LICENSE file for applicable licenses.
-->
<!--
	Stylesheet that creates an ANT build script based on the dita errors.
-->
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- @ignore-instrument -->
	<xsl:output indent="yes" method="xml" omit-xml-declaration="no"/>

	<xsl:param as="xs:string" name="SOURCE"/>
	<xsl:param as="xs:string" name="DITA_DIR"/>
	<xsl:param name="FIXABLE_RULESET">a^</xsl:param>
	

	<xsl:template match="/">
		<project default="auto-correct" name="validator.auto-correct">
			<xsl:element name="property">
				<xsl:attribute name="name">
					<xsl:text>dita.dir</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="$DITA_DIR"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="property">
				<xsl:attribute name="name">
					<xsl:text>com.here.validate.svrl.dir</xsl:text>	
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:text>${dita.dir}/plugins/com.here.validate.svrl</xsl:text>
				</xsl:attribute>
			</xsl:element>

			<xsl:element name="typedef">
				<xsl:attribute name="file">
					<xsl:text>${com.here.validate.svrl.dir}/resource/antlib.xml</xsl:text>
				</xsl:attribute>
			</xsl:element>

			<xsl:element name="import">
				<xsl:attribute name="file">
					<xsl:text>${com.here.validate.svrl.dir}/cfg/ruleset/fix-macros.xml</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="import">
				<xsl:attribute name="file">
					<xsl:text>${com.here.validate.svrl.dir}/cfg/ruleset/file-macros.xml</xsl:text>
				</xsl:attribute>
			</xsl:element>


	
			<target name="auto-correct">
				<init/>
				<xsl:apply-templates mode="fix-dita" select="//failed-assert"/>
				<xsl:apply-templates mode="fix-files" select="//failed-assert"/>
			</target>
		</project>
	</xsl:template>
	<!--
		Template to add each error found as a replaceregex entry.
	-->
	<xsl:template match="*" mode="fix-dita">
		<xsl:variable name="macro"><xsl:value-of select="./diagnostic-reference/@diagnostic"/>
		</xsl:variable>
		<xsl:if test="matches ($macro, $FIXABLE_RULESET)">
			<xsl:element name="echo">
				<xsl:attribute name="message">
					<xsl:text>Rule: </xsl:text><xsl:value-of select="$macro"/>	
				</xsl:attribute>
				<xsl:attribute name="level">
					<xsl:text>info</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="taskname">
					<xsl:text>FIX</xsl:text>
				</xsl:attribute>
			</xsl:element>
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

	<!--
		Check for mismatched files.
	-->
	<xsl:template match="*" mode="fix-files">
		<xsl:variable name="macro"><xsl:value-of select="./diagnostic-reference/@diagnostic"/>
		</xsl:variable>
		<xsl:if test="matches ($macro, 'file-not-lower-case')">
			<xsl:element name="echo">
				<xsl:attribute name="message">
					<xsl:text>Rule: </xsl:text><xsl:value-of select="$macro"/>	
				</xsl:attribute>
				<xsl:attribute name="level">
					<xsl:text>info</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="taskname">
					<xsl:text>FIX</xsl:text>
				</xsl:attribute>
			</xsl:element>
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