Customizing the DITA Fixer
==========================

Adding a new fixable rule
-------------------------

An editable macrofile can be found in `cfg/rulesset/fix-macros.xml`. If a rule can be auto fixed, 
a macro should be added to the file in the following format:

```
<macrodef name="rowsep-invalid">
	<attribute name="file"/>
	<attribute name="path"/>
	<sequential>
		<delete-attribute file="@{file}" path="@{path}" attr="rowsep"/>
	</sequential>
</macrodef>
```
Where the `name` of the macro matches the rule `id`. The `file` attribute supplies name of the
file to be updated and the `path` attribute supplies the XPath to the invalid element.
The DITA file can be updated using [XMLTask](http://www.oopsconsultancy.com/software/xmltask/) 
which has been supplied as a library. The following convenience functions are also available
by default:


* `delete-attribute`
* `delete-element`
* `get-attribute-value`
* `lower-case-attribute`
* `put-attribute-value`
* `replace-with-subelement`

Amending a fixable rule
-----------------------

The default functionality applied to fix a broken rule can be amended by altering the macro.
If a rule is inactive within the ruleset it will not be fixed.  
