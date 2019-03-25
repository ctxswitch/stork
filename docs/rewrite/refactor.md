# V1 Complete Refactor

### Global

[ ] Define universal structure
[ ] Server application is split into seperate repo


### Client

Stork will be a command line utility that will read in configuration files in a ruby dsl format, convert them to a universal format and ship them off to the stork server that will store them into a database, create the kickstart files, manage host state, and respond to PXE and TFTP requests.

[ ] Document kickstart and preseed features that we want to support and how they will crossover.  Start with the basic subset of things that will be needed for 90% of the cases.
[ ] Strip all server functions.

### Server


