Scalable and fast storage for JBoss Fuse using JBoss Data Grid
=====================================

This demos show how to use the camel-jbossdatagrid component as a fast storage to an integration case.


Setup
---------------
To setup the infrastructure for the demo download the follwoing files to the `installs` directory:

* jboss-fuse-full-6.1.1.redhat-412.zip

After that run the `init.sh` script

		$ sh init.sh

Demo storty
-----------

A stock market broker needs to provide it's brokers with immediate data about value of stocks. The stock-market offers A-MQ as an interface for listening to stock tick (events with current value of a stock based on the last trades). The broker decides to use JBoss Fuse to consume the stock tick events and implements a integration flow to receive and transform the events from JSON to Java POJO. The brokers however wants to correlate the latest event with the previous 100 to be able to spot trends.

The problem
-----------
The volume of stock tick events is very high and to be able to consume the events without overflowing the integration the sizing team has calculated that the integration flow needs to be able to process an event in under 10 ms. To be able to meet the requirement of storing the last 100 events they it department has identified that their standard database storage, that has an SLA of 500 ms for a write operation, is will not be able to meet this requirement.

The solution
------------
JBoss Data Grid recently (since 6.4) introduced a camel component capable of storing high volume of data in-memory. It also provides eviction strategy where the data grid automatically can evict events based on different algorithms like FIFO, LIRS etc. JBoss Data Grid also supports different architectures and can either run embedded or remote, where embedded gives he best performance but are then sharing resources (memory, cpu etc) with the JBoss Fuse, while remote adds a network call but gives added scalability options for the data layer.

The broker decides to implement a solution based on JBoss Fuse and JBoss Data Grid running in remote mode.

![Network diagram][network-diagram]

To run the demo
-----------------

1. Open a terminal

1. Clone this git repo TODO: add url

	    git clone <URL>

1. Change current directory to the cloned directory

1. Download the software and place it in the `installs` directory

1. Run the `init.sh` script to install JBoss Fuse and deploy the application

	   sh init.sh

1. Start a stock plotter client

	   sh support/start-client.sh

1. Watch as stock ticks are plotted in the client.

1. Open the Fuse console and verify that the processing of event is under 10 ms.

1. Pause the stock-producer to verify that the plotter stops.

1. Done!
 





[network-diagram]: https://github.com/rhnordics/jboss-fuse-jdg-scalable-integration/blob/master/images/network-diagram.svg "Network diagram of stock ticker demo"
