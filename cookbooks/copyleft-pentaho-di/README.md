# copyleft-pentaho-di

TODO: Enter the cookbook description here.
The Copyleft Pentaho-DI Cookbook deploys Pentaho Data Integration Server
on Ubuntu 14.04 into a standard Tomcat 7 install.  

This cookbook implements the manual Enterprise (EE) Linux Installation procedure
for the Pentaho data-integration-server as documented by Pentaho.
https://help.pentaho.com/Documentation/6.0/0F0/0L0

# COPYLEFT COOKBOOK DEPENDENCIES
- copyleft-base
- copyleft-java
- copyleft-tomcat
- copyleft-postgres


This cookbook requires the following artifacts cookbook/files which are available
for download via Pentaho Support Portal for Enterprise Licenses

# DEPLOYMENT ARTIFACTS
- di-license-installer.zip -> pentaho/
- di-jdbc-distribution-utility.zip -> pentaho/SERVER
- di-pentaho-data.zip -> pentaho/server/data-integration-server
- di-pentaho-solutions.zip -> pentaho/server/data-integration-server
- pentaho-di.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps
- pentaho-style.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps
- PentahoBIPlatform_OSS_Licenses.html -> pentaho/server/data-integration-server

# Pentaho License Files
- Pentaho_PDI_EE.lic
- PentahoBIPlatform_OSS_Licenses.html

# SQL ARTIFACTS
- create_jcr_postresql.sql
- create_quartz_postgresql.sql
- create_repository_postgresql.sql
- pentaho_mart_postgresql.sql

# JAR Files
postgresql-9.3-1104.jdbc4.jar
