DITA Validator for DITA-OT
==========================

[![DITA-OT 3.0](https://img.shields.io/badge/DITA--OT-3.0-blue.svg)](http://www.dita-ot.org/3.0/)
[![DITA-OT 2.5](https://img.shields.io/badge/DITA--OT-2.5-green.svg)](http://www.dita-ot.org/2.5/)
[![Build Status](https://travis-ci.org/jason-fox/com.here.validate.svrl.svg?branch=master)](https://travis-ci.org/jason-fox/com.here.validate.svrl)
[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

The DITA Validator plug-in for [DITA-OT](http://www.dita-ot.org/) is a structure, style and content checker for DITA documents. The plug-in returns information about the compliance of the document against a **modifiable** series of validator rules. The plug-in also supports standard XML validation

The plug-in consists of a single transform which can do the following:
* Echo validation results to the command line
* Automatically fix common validation errors within the document.
* Return a report in *Schematron Validation Report Language* (`SVRL`) format. 
  More information about SVRL can be found at [www.schematron.com](http://www.schematron.com/validators.html)