Usage
=====

Validating a document from the Command line
-------------------------------------------

A test document can be found within the plug-in at `PATH_TO_DITA_OT/plugins/com.here.validate.svrl/sample`

### Creating an SVRL file

To create an SVRL file use the `svrl` transform with the `--args.validate.mode=report` parameter.

-  From a terminal prompt move to the directory holding the document to validate

-  SVRL file creation (`svrl`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f svrl --args.validate.mode=report -o out -i document.ditamap
```

Once the command has run, an SVRL file is created

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<svrl:schematron-output>
	<active-pattern role="dita" name="/running-text-fixme.dita"/>
	<fired-rule context="common" role="content"/>
	<failed-assert role="warning" location="/topic/body[1]/section[2]/p[1]">
		<diagnostic-reference diagnostic="running-text-fixme">
			Line 20: p - [running-text-fixme] 
			Found 'FIXME' comments in the following text in this &lt;p&gt; element - 
			fix as requested and delete the comment. 

			FIXME This needs to be fixed
		</diagnostic-reference>
		</failed-assert>
	<fired-rule context="common" role="structure"/>
	<fired-rule context="common" role="style"/>
	<fired-rule context="topic" role="style"/>
	<fired-rule context="section" role="style"/>
	<fired-rule context="section" role="style"/>
	<active-pattern role="ditamap" name="/document.ditamap"/>
	<fired-rule context="common" role="structure"/>
</svrl:schematron-output>
```

### Echoing results to the command line

To echo results to the command line use the `svrl` transform without specifying a `report`

-  Document validation (`svrl`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f svrl -i document.ditamap
```

Once the command has run, all errors and warnings are echoed to the command line

```console
[WARN]	 [/out/temp/dita/topics/comment-fixme.dita]
 Line 15: section[id="bad"] - [comment-fixme]
Found 'FIXME' comments within the <section> element - fix as requested and delete the comment.

FIXME This comment requires action

Found 0 Errors 1 Warnings
```

Additionally, if an error occurs, the command will fail

```console
[ERROR]	[/document.ditamap]
 Line 89: topicref - [href-not-lower-case]
The value provided in href="topics/FILE-NOT-LOWER-CASE.dita" is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.

Found 1 Errors 0 Warnings
Error: [SVRL001F][FATAL] Errors detected during validation
```

Optionally, the output can be highlighed using ANSI color codes by adding the `args.validate.color` parameter

```console
PATH_TO_DITA_OT/bin/dita -f svrl-echo -i document.ditamap -Dargs.validate.color=true
```

### Fix common errors automatically 

To run the  auto-fix command from the command line use the `svrl` transform with the `--args.validate.mode=fix-dita` parameter.

```console
PATH_TO_DITA_OT/bin/dita -f svrl -i document.ditamap --args.validate.mode=fix-dita
```

Once the command has run, the DITA files are updated and fixable errors and warnings are
no longer present.


### Parameter Reference

- `args.validate.ignore.rules` - Comma separated list of rules not to be enforced
- `args.validate.blacklist` - Comma separated list of words not to be present in the running text
- `args.validate.cachefile` - Specifies the location of cache file to be used. Validation will only run across altered files if this parameter is present
- `args.validate.check.case` - Comma separated list of words which have a specified capitalization
- `args.validate.color` - When set, errors and warnings are Output highlighted using ANSI color codes
- `args.validate.mode` - Validation reporting mode. The following values are supported:
	- `strict`	 - Outputs both warnings and errors. Fails on errors and warnings.
	- `default`  - Outputs both warnings and errors. Fails on errors only
	- `lax`		 - Ignores all warnings and outputs errors only. Fails on Errors only
	- `report`	 - Creates an SVRL file
	- `fix-dita` - Updates existing DITA files and automatically fixes as many errors as possible
- `svrl.customization.dir` - Specifies the customization directory
- `svrl.ruleset.file` - Specifies severity of the rules to apply. If this parameter is not present, default severity levels will be used.
- `svrl.filter.file` - Specifies the location of the XSL file used to filter the echo output. If this parameter is not present, the default echo output format will be used.



Validating a document using ANT
-------------------------------

An ANT build file is supplied in the same directory as the sample document. The main target can be seen below:


```xml
<dirname property="dita.dir" file="PATH_TO_DITA_OT"/>
<property name="dita.exec" value="${dita.dir}/bin/dita"/>
<property name="args.input" value="PATH_TO_DITA_DOCUMENT/document.ditamap"/>

<target name="validate" description="validate a document">
	<exec executable="${dita.exec}" osfamily="unix" failonerror="true">
		<arg value="-input"/>
		<arg value="${args.input}"/>
		<arg value="-output"/>
		<arg value="${dita.dir}/out/svrl"/>
		<arg value="-format"/>
		<arg value="svrl-echo"/>
		<!-- validation transform specific parameters -->
		<arg value="-Dargs.validate.blacklist=(kilo)?metre|colour|teh|seperate"/>
		<arg value="-Dargs.validate.check.case=Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML"/>
		<arg value="-Dargs.validate.color=true"/>
	</exec>
	<!-- For Windows run from a DOS command -->
	<exec dir="${dita.dir}/bin" executable="cmd" osfamily="windows" failonerror="true">
		<arg value="/C"/>
		<arg value="dita -input ${args.input} -output ${dita.dir}/out/svrl -format svrl-echo -Dargs.validate.blacklist=&quot;(kilo)?metre|colour|teh|seperate&quot; -Dargs.validate.check.case=&quot;Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML&quot;"/>
	</exec>	
</target>
```
