# StuffDB

This module should be used to stuff an empty database with some schemas, tables, and test data.

This is the long term goal currently it only helps with the creation of schemas

Really just provides a convenient wrapper to do this so that you don't have to role your own setup scripts for tests etc.

You probably shouldn't run this on a database you care about, but one you might throw away after wards.

## INSTALLATION

To install this module, run the following commands:

```
perl Makefile.PL
make
make test
make install
```

## To use

Should use this through the command line stuffdb command.

For command line options: `stuffdb --help`

Stuffdb will try to look for a stuffdb.json or stuffdb.yaml file if config is not specified in through the command line.

### From Docker

This utility has been pushed to the eas docker registry and can be used as a docker command.

```
docker run -v /stuffdb.json:/stuffdb/stuffdb.json toolbox.acsu.buffalo.edu:5000/stuffdb --help
```

### Configuration

the stuffdb conf file can take the following configration parameters

- schemas : a list of schemas to create in the db
- commands : a list of commands to run to aid in setting up the tables and adding data.
- database_type : type of database (Currently only supports oracle)
- connection : a field that holds the necessary connection info for the database_type. See example

#### Config example (json)

```
{
    "schemas": ["Schema", "Names", "Here"],
    "commands": [["perl", "some-script.pl"], ["node","some-script.js"]],
    "database_type": "Oracle",
    "connection": {
        "host": "foo.bar.com",
        "port": 1524,
        "sid": "xe"
    }
}
```

Note that DBConnection username and password will be reas from environment variable `STUFFDB_USER` and `STUFFDB_PASSWORD` respectively if needed.

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the perldoc command.

`perldoc StuffDB`

You can also look for information at:

RT, CPAN's request tracker (report bugs here):

<http://rt.cpan.org/NoAuth/Bugs.html?Dist=StuffDB>

AnnoCPAN, Annotated CPAN documentation:

<http://annocpan.org/dist/StuffDB>

CPAN Ratings:

<http://cpanratings.perl.org/d/StuffDB>

Search CPAN:

<http://search.cpan.org/dist/StuffDB/>

## LICENSE AND COPYRIGHT

Copyright (C) 2016 William Frank Wheeler II

This program is free software; you can redistribute it and/or modify it under the terms of the the Artistic License (2.0). You may obtain a copy of the full license at:

<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified Versions is governed by this Artistic License. By using, modifying or distributing the Package, you accept this license. Do not use, modify, or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made by someone other than you, you are nevertheless required to ensure that your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license to make, have made, use, offer to sell, sell, import and otherwise transfer the Package with respect to any patent claims licensable by the Copyright Holder that are necessarily infringed by the Package. If you institute patent litigation (including a cross-claim or counterclaim) against any party alleging that the Package constitutes direct or contributory patent infringement, then this Artistic License to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
