

Customizing the Validator
=========================

Adding New Validator Rules
--------------------------

This DITA-OT plug-in contains a common ruleset of general validator rules. The ruleset has been designed to be applicable to all documents created by all users. To add new custom rules (which only apply to your specific use case) you should create a separate custom validator plug-in which extends the base validator. See the sample [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) as an example of how to do this.

Altering the severity of a validator rule
-----------------------------------------

The severity of a validator rule can be altered by amending entries in the `cfg/rulesset/default.xml`  file The plug-in supports four severity levels:

* **FATAL** - Fatal rules will fail validation and cannot be overridden.
* **ERROR** - Error rules will fail validation. Errors can be overridden as described above.
* **WARNING** - Warning rules will display a warning on validation, but do not fail the validation. Warnings can also be individually overridden.
* **INACTIVE** - Inactive rules are not applied.


A custom ruleset file can be passed into the plug-in using the `svrl.ruleset.file` parameter


```console
PATH_TO_DITA_OT/bin/dita -f svrl-echo -i document.ditamap -Dsvrl.ruleset.file=PATH_TO_CUSTOM/ruleset.xml
```


Ignoring Validator Rules
------------------------

### Removing validator rules globally

Rules can be made inactive by altering the severity (see above).  Alternatively a rule can be commented out in the XSL.

To completely remove rules which do not apply to your document set, you can create a customized DITA-OT plug-in which extends the base validator. See the [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) as an example of how to do this.


### Ignoring a validator rule throughout a document

Individual rules can be ignored by adding the `args.validate.ignore.rules` parameter to the command line. The value of the parameter should be a comma-delimited list of each `rule-id` to ignore.

For example to ignore the `table-id-missing` validation rule within a document you would run:

```console
PATH_TO_DITA_OT/dita -f svrl-echo -i document.ditamap -Dargs.validate.ignore.rules=table-id-missing
```


### Ignoring a specific instance of a validator rule

Specific instances of a rule can be ignored by adding a comment within the `*.dita` file. The comment should start with `ignore-rule`, and needs to be added at the location where the error is flagged.

```xml
...
<table platform="pdfonly" frame="none" >
	<!-- ignore-rule:table-id-missing -->
	<tgroup cols="1">
		<colspec colname="c1" colnum="1" colwidth="336pt"/>
		<tbody>
			<row>
				<entry>&#xA0;</entry>
			</row>
		</tbody>
	</tgroup>
</table>
```

Some rules such as **FIXME** and **TODO** in the running text need to be double escaped as shown below:

 - Add a comment line with the text `ignore-rule:running-text-*` to ignore the issue flagged in the text below (no FIXMEs allowed in the running text)
 - Add the `comment-*` to the list of ignored rules	to ignore the fact that the comment itself fails an additional rule (no FIXMEs allowed in the comments)

```xml
<!--
	We want to display the text below which would usually
	result in a warning
-->
<p>
	<!-- ignore-rule:running-text-fixme,comment-fixme -->
	FIXME is usually banned in the running text.
</p>
```

### Ignoring all warnings within a block

A block of DITA can be excluded from firing all rules at **WARNING** level by adding the comment `ignore-all-warnings` to the block. This is especially useful to avoid false positive TODO warnings for text which is in Spanish.

```xml
<!--
	We want to display the Spanish text below which would usually
	result in a series of warnings for the word TODOS
-->
<section xml:lang="es-es" id="legal-es">
	<!-- ignore-all-warnings -->
	<title>Avisos legales</title>
	<p>
		© 2017 <keyword keyref="brand-name"/> Global B.V. Todos los derechos reservados.
	</p>
	<p>
		Este material, incluidos la documentación y los programas informáticos relacionados, está protegido por derechos de autor controlados
		por <keyword keyref="brand-name"/>. Todos los derechos están reservados. La copia, incluidos la reproducción, almacenamiento,
		adaptación o traducción de una parte o de todo este material requiere el consentimiento por escrito de <keyword keyref="brand-name"/>.
		Este material también contiene información confidencial, que no se puede revelar a otras personas sin el consentimiento previo y
		por escrito de <keyword keyref="brand-name"/>.
	</p>
<section>
```

### Ignoring all errors within a block

A block of DITA can be excluded from firing all rules at **ERROR** level by adding the comment `ignore-all-errors` to the block. This is useful to avoid issues with generated DITA files which are parsable DITA, but which may not satisfy in-house validation style rules.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- THIS TOPIC IS GENERATED -->
<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">
<topic id="generated-topic" other-props="generated">
	<!-- ignore-all-warnings, ignore-all-errors -->
	<title>Topic title</title>
	<body>
		Generated Content goes here...
	</body>
</topic>
```

Rules set at **FATAL** level cannot be ignored.