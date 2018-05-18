<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="saxon dita-ot" version="2.0" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:saxon="http://saxon.sf.net/"  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
	<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
	<!-- These come from the base plug-in -->
	<xsl:param name="DEFAULTLANG">en-us</xsl:param>
	<xsl:param as="xs:string" name="IGNORE_RULES" select="''"/>
	<xsl:param as="xs:string" name="OUTPUT_RULE-ID" select="'true'"/>
	<xsl:param as="xs:string" name="SOURCE"/>
	<xsl:param name="FATAL_RULESET">a^</xsl:param>
	<xsl:param name="ERROR_RULESET">a^</xsl:param>
	<xsl:param name="WARNING_RULESET">a^</xsl:param>
	<xsl:param name="PATTERN_ROLE">dita</xsl:param>
	<xsl:variable name="msgprefix">DOTX</xsl:variable>
	<xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
	<xsl:variable name="document-uri">
		<xsl:value-of select="replace(replace(document-uri(/), $SOURCEPATH, ''), 'file:', '')"/>
	</xsl:variable>
	<xsl:variable as="xs:boolean" name="OUTPUT.RULE-ID" select="$OUTPUT_RULE-ID='true'"/>
	<xsl:template match="*" mode="failed-assert-with-node">
		<xsl:param name="rule-id"/>
		<xsl:param name="test"/>
		<xsl:param name="param1" select="''"/>
		<xsl:param name="param2" select="''"/>
		<xsl:param name="param3" select="''"/>
		<xsl:param as="xs:string" name="human-text" select="''"/>
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">
				<xsl:value-of select="$rule-id"/>
			</xsl:with-param>
			<xsl:with-param name="test">
				<xsl:value-of select="$test"/>
			</xsl:with-param>
			<xsl:with-param name="human-text">
				<xsl:value-of select="$human-text"/>
			</xsl:with-param>
			<xsl:with-param name="param1">
				<xsl:value-of select="$param1"/>
			</xsl:with-param>
			<xsl:with-param name="param2">
				<xsl:value-of select="$param2"/>
			</xsl:with-param>
			<xsl:with-param name="param3">
				<xsl:value-of select="$param3"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
		Creates a <failed-assert>element consistent with Schematron Validation Report Language definitions
	-->
	<xsl:template name="failed-assert">
		<xsl:param as="xs:string" name="rule-id"/>
		<xsl:param as="xs:string" name="test"/>
		<xsl:param name="param1" select="''"/>
		<xsl:param name="param2" select="''"/>
		<xsl:param name="param3" select="''"/>
		<xsl:param as="xs:string" name="human-text" select="''"/>
		<xsl:param name="name" select="string(name(.))"/>
		<xsl:param name="parent" select="string(name(..))"/>
		<xsl:param name="id" select="string(@id)"/>
		<xsl:param name="href" select="string(@href)"/>
		<xsl:param name="conref" select="string(@conref)"/>
		<xsl:choose>
			<xsl:when test="matches ($rule-id, $FATAL_RULESET)">
				<failed-assert>
					<xsl:attribute name="role">fatal</xsl:attribute>
					<xsl:attribute name="location">
						<xsl:value-of select="saxon:path()"/>
					</xsl:attribute>
					<diagnostic-reference>
						<xsl:attribute name="diagnostic">
							<xsl:value-of select="$rule-id"/>
						</xsl:attribute>
						<xsl:call-template name="getVariable">
							<xsl:with-param name="id" select="'schematron-line-numbers'"/>
							<xsl:with-param name="params">
								<number>
									<xsl:value-of select="saxon:line-number()"/>
								</number>
							</xsl:with-param>
						</xsl:call-template>
							<xsl:text> </xsl:text>
						<xsl:value-of select="saxon:line-number()"/>
						<xsl:text>: </xsl:text>
						<xsl:call-template name="dita-element-context"/>
						<xsl:if test="$OUTPUT.RULE-ID">
							<xsl:text> - [</xsl:text>
							<xsl:value-of select="$rule-id"/>
							<xsl:text>] </xsl:text>
						</xsl:if>
						<xsl:variable name="error-message">
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="$rule-id"/>
							</xsl:call-template>
						</xsl:variable>
							<xsl:text>&#xA;</xsl:text>
						<xsl:choose>
							<xsl:when test="$human-text = ''">
								<xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace($error-message, '@NAME', string($name)), '@PARENT', string($parent)) , '@ID', string($id)) , '@HREF', string($href)) , '@CONREF', string($conref)) , 'PARAM1', string($param1)) , 'PARAM2', string($param2)) , 'PARAM3', string($param3))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$human-text"/>
							</xsl:otherwise>
						</xsl:choose>
					</diagnostic-reference>
				</failed-assert>
			</xsl:when>
			<xsl:when test="matches ($rule-id, $ERROR_RULESET)">
				<xsl:if test="not(contains($IGNORE_RULES, $rule-id)) and not(comment()[contains(., 'ignore-rule') and contains(., $rule-id)]) and not(ancestor::*/comment()[contains(., 'ignore-all-errors')])">
					<failed-assert>
						<xsl:attribute name="role">error</xsl:attribute>
						<xsl:attribute name="location">
							<xsl:value-of select="saxon:path()"/>
						</xsl:attribute>
						<diagnostic-reference>
							<xsl:attribute name="diagnostic"><xsl:value-of select="$rule-id"/></xsl:attribute>
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'schematron-line-numbers'"/>
								<xsl:with-param name="params">
									<number>
										<xsl:value-of select="saxon:line-number()"/>
									</number>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:value-of select="saxon:line-number()"/>
							<xsl:text>: </xsl:text>
							<xsl:call-template name="dita-element-context"/>
							<xsl:if test="$OUTPUT.RULE-ID">
								<xsl:text> - [</xsl:text>
								<xsl:value-of select="$rule-id"/>
								<xsl:text>] </xsl:text>
							</xsl:if>
							<xsl:variable name="error-message">
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="$rule-id"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:text>&#xA;</xsl:text>
							<xsl:choose>
								<xsl:when test="$human-text = ''">
									<xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace($error-message, '@NAME', string($name)), '@PARENT', string($parent)) , '@ID', string($id)) , '@HREF', string($href)) , '@CONREF', string($conref)) , 'PARAM1', string($param1)) , 'PARAM2', string($param2)) , 'PARAM3', string($param3))"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$human-text"/>
								</xsl:otherwise>
							</xsl:choose>
						</diagnostic-reference>
					</failed-assert>
				</xsl:if>
			</xsl:when>
			<xsl:when test="matches ($rule-id, $WARNING_RULESET)">
				<xsl:if test="not(contains($IGNORE_RULES, $rule-id)) and not(comment()[contains(., 'ignore-rule') and contains(., $rule-id)]) and not(ancestor::*/comment()[contains(., 'ignore-all-warnings')])">
					<failed-assert>
						<xsl:attribute name="role">warning</xsl:attribute>
						<xsl:attribute name="location">
							<xsl:value-of select="saxon:path()"/>
						</xsl:attribute>
						<diagnostic-reference>	
							<xsl:attribute name="diagnostic">
								<xsl:value-of select="$rule-id"/>
							</xsl:attribute>
							<xsl:call-template name="getVariable">
								<xsl:with-param name="id" select="'schematron-line-numbers'"/>
								<xsl:with-param name="params">
									<number>
										<xsl:value-of select="saxon:line-number()"/>
									</number>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:value-of select="saxon:line-number()"/>
							<xsl:text>: </xsl:text>
							<xsl:call-template name="dita-element-context"/>
							<xsl:if test="$OUTPUT.RULE-ID">
								<xsl:text> - [</xsl:text>
								<xsl:value-of select="$rule-id"/>
								<xsl:text>] </xsl:text>
							</xsl:if>
							<xsl:variable name="error-message">
								<xsl:call-template name="getVariable">
									<xsl:with-param name="id" select="$rule-id"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:text>&#xA;</xsl:text>
							<xsl:choose>
								<xsl:when test="$human-text = ''">
									<xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace($error-message, '@NAME', string($name)), '@PARENT', string($parent)) , '@ID', string($id)) , '@HREF', string($href)) , '@CONREF', string($conref)) , 'PARAM1', string($param1)) , 'PARAM2', string($param2)) , 'PARAM3', string($param3))"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$human-text"/>
								</xsl:otherwise>
							</xsl:choose>
						</diagnostic-reference>
					</failed-assert>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Unknown Rule 
					<xsl:value-of select="$rule-id"/></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
		Creates a <successful-report>element consistent with Schematron Validation Report Language definitions
	-->
	<xsl:template name="successful-report">
		<xsl:param name="rule-id"/>
		<xsl:param name="test"/>
		<xsl:param name="role" select="'info'"/>
		<xsl:param name="param1" select="''"/>
		<xsl:param name="param2" select="''"/>
		<xsl:param name="human-text" select="''"/>
		<xsl:if test="not(contains($IGNORE_RULES, $rule-id)) and not(comment()[contains(., 'ignore-rule') and contains(., $rule-id)])">
			<successful-report>
				<xsl:attribute name="role">
					<xsl:value-of select="$role"/>
				</xsl:attribute>
				<diagnostic-reference>
					<xsl:attribute name="diagnostic">
						<xsl:value-of select="$rule-id"/>
					</xsl:attribute>
					<xsl:variable name="success-message">
						<xsl:call-template name="getVariable">
							<xsl:with-param name="id" select="$rule-id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$human-text = ''">
							<xsl:value-of select="replace(replace($success-message, 'PARAM1', string($param1)) , 'PARAM2', string($param2))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$human-text"/>
						</xsl:otherwise>
					</xsl:choose>
				</diagnostic-reference>
			</successful-report>
		</xsl:if>
	</xsl:template>
	<!--
		Creates a <fired-rule>element consistent with Schematron Validation Report Language definitions
	-->
	<xsl:template name="fired-rule">
		<xsl:param name="context" select="''" />
		<xsl:param name="role" select="''" />
		<fired-rule>
			<xsl:attribute name="context">
				<xsl:value-of select="$context"/>
			</xsl:attribute>
			<xsl:attribute name="role">
				<xsl:value-of select="$role"/>
			</xsl:attribute>
		</fired-rule>
	</xsl:template>

	<!--
		Creates a <active-pattern> element consistent with Schematron Validation Report Language definitions
	-->
	<xsl:template name="active-pattern">
		<xsl:param name="node"/>
		<active-pattern>
			<xsl:attribute name="role">
				<xsl:value-of select="$PATTERN_ROLE"/>
			</xsl:attribute>
			<xsl:attribute name="name">
				<xsl:value-of select="$document-uri"/>
			</xsl:attribute>
		</active-pattern>
	</xsl:template>



	<!--
		Describes the DITA element under test
	-->
	<xsl:template name="dita-element-context">
		<xsl:value-of select="name()"/>
		<xsl:choose>
			<xsl:when test="@id and not(@conref)">
				<xsl:text>[id=&quot;</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>&quot;]</xsl:text>
			</xsl:when>
			<xsl:when test="not(@id) and @conref">
				<xsl:text>[conref=&quot;</xsl:text>
				<xsl:value-of select="@conref"/>
				<xsl:text>&quot;]</xsl:text>
			</xsl:when>
			<xsl:when test="@id and @conref">
				<xsl:text>[id=&quot;</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>&quot; and conref=&quot;</xsl:text>
				<xsl:value-of select="@conref"/>
				<xsl:text>&quot;]</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>