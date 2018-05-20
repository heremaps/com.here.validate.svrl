Install
=======

The validator has been tested against [DITA-OT 3.0.x](http://www.dita-ot.org/download). It is recommended that you upgrade to the latest version. Running the validator plug-in against DITA-OT 1.8.5 or earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`. The validator can be run safely against DITA-OT 2.x.

Installing DITA-OT
------------------

The DITA Validator is a plug-in for the DITA Open Toolkit.

-  Install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```console
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

Installing the Plug-in
----------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl/archive/master.zip
```

The `dita` command line tool requires no additional configuration.