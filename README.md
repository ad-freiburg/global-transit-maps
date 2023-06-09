Global transit maps
===================

This is the setup of the experimental evaluation of our paper "Large-Scale Generation of Transit Maps from OpenStreetMap Data".

The Makefile provided here, together with the queries in folder `queries`, generates global transit map vector tiles from OpenStreetMap (OSM) data.

It requires an installation of [LOOM](https://github.com/ad-freiburg/loom).

The tiles can be inspected using the web application in `web`.

An example installation is available at [https://loom.cs.uni-freiburg.de/global](https://loom.cs.uni-freiburg.de/global).

All tiles are available for free at [https://loom.cs.uni-freiburg.de/tiles](https://loom.cs.uni-freiburg.de/tiles).

Currently, 4 networks are supported: `tram`, `subway-lightrail`, `rail-commuter`, and `rail`.

To render the tiles for each network, use

    make <NETWORK>

For example, to render all tram tiles, type

    make tram
