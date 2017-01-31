# docker_registry_query
Query your own Docker registry

````
$ ./registry_query.pl  -help

HELP docker registry query

Usage:
  registry_query.pl -help                        This help text.
  registry_query.pl -verbose                     Display detail logging.
  registry_query.pl -details                     Display detail info.
  registry_query.pl -url <docker registry url>   An alternative docker registry URL.
  registry_query.pl -repo <(part of) repo name>  Filter on repository name.
  registry_query.pl -tag <(part of) tag name>    Filter on tag.
````

For example:
````
$ ./registry_query.pl -url registry.docker.<yourdomain>
tedsluis/alpine
tedsluis/busybox
tedsluis/cassandra
tedsluis/grafana
tedsluis/haproxy
tedsluis/httpd
tedsluis/javarunner
tedsluis/jenkins-java
tedsluis/kibana
tedsluis/logcollector
tedsluis/maven
tedsluis/mysql
tedsluis/nginx
tedsluis/node
tedsluis/openjdk
tedsluis/php
tedsluis/phusion/baseimage
tedsluis/ubuntu
REPOCOUNT=18, TAGCOUNT=86
````

````
$./registry  -url registry.docker.<yourdomain> -details
tedsluis/alpine
digest-->sha256:f4028dbb59a3329d8b517e9e451de9fd3d459e6d1f9d513677e8c307fffb5248, size-->12955
  +-digest----->sha256:6c953ac5d795ea26fd59dc5bdf4d335625c69f8bcfbdd8307d6009c2e61779c9, size---->65699277
  +-digest----->sha256:3eed5ff20a90a40b0cb7909e79128740f1320d29bec2ae9e025a1d375555db15, size---->71477
  +-digest----->sha256:f8419ea7c1b5d667cf26c2c5ec0bfb3502872e5afc6aa85caf2b8c7650bdc8d9, size---->360
  +-digest----->sha256:51900bc9e720db035e12f6c425dd9c06928a9d1eb565c86572b3aab93d24cfca, size---->681
  +-digest----->sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4, size---->32
  +-digest----->sha256:5278da6185578f852ea68c7d983afb91f6e90e88a742304164afc394ddf550b8, size---->28672572
  +-digest----->sha256:1210e80449372846aa56f76f0e3d2c68aa0b7cbb4f3440b40716b79c3d9f52df, size---->132193801
  +-digest----->sha256:1e7d364d050ce7f5afe2a1ab29d7f43e6e5f5892b5d0d3ab9b5c5665a4eb636e, size---->137101019
  +-digest----->sha256:f2c78af601e5d9a992805fae928ee8b0e662436788457da30fb1d254968b72de, size---->1323
  +-digest----->sha256:d8983ace4d177d682a66e2fbd39a32723a58ae5dc9c2b444a8ff74bd2e4fac46, size---->1345
  +-digest----->sha256:f447402282cf55dd8e483785347a97adcfffaedac9e64980f3ab044949e494ab, size---->1370
  +-digest----->sha256:c77c87047a0c9c00b919a0d8df08b7e84645e42d6f0d066e2c4a82dbc0d3e0c5, size---->1402
  +-digest----->sha256:3483d1303c9b59a71e604901ab275ae9f24600f4c75771b6abbf89173d9440ff, size---->151
  +-digest----->sha256:5ded20e3c022c9cba942974aea54e614f3c4284208855d5fe1c104247526bc32, size---->838291
  +-digest----->sha256:739dd1ab55ed43495c806177b12895a6a7788a3c7fd9e20460fd59a0ec0b9534, size---->1239
  +-digest----->sha256:3570b0fa3dc01d105038f70e8967866f929dd7a09e21b5d4330538c0ae704b47, size---->165332
  +-digest----->sha256:82faa5a424951c62378f3648582057edd2e8ab87c762dd4a09a92b217db08635, size---->949
  +-digest----->sha256:c21b01286dd213d406192f5ed4674430d7159fcecc34705147ba399ec8751b27, size---->184
  +-digest----->sha256:8491d0caf21e77a62b6630745062a268e22faf08526b9704a2a0f28654670e22, size---->147
  +-digest----->sha256:53a827255609acab082c0ab9afc381d2be4e9f84c70a997a19365ce4308782e6, size---->148
  +-digest----->sha256:b87283f1b467baf57385f52227ecc64f1fabe9ccf39b4076af8ce845f6ee09d1, size---->8598921
  +-digest----->sha256:e82f1e2060f2e159e8b08d3a032f48646cdb9f32a9009ca2723e18b68ebaf51c, size---->1443
  +-digest----->sha256:f9c66dbe2bac5649a6f2187f8113ea0ba53b4533ae7b49b48ca242b938575d4b, size---->708
  +-digest----->sha256:cb0982769b84fc7d6e70843fbcf07c73984f175bb8a0442c77b3ad88a2f77396, size---->719
  +-digest----->sha256:907c2f1e7050da9d5f0351f8438785bee87eb202c202ef2129548b3584a21ae9, size---->499074880
  +-digest----->sha256:caf6fa02a163f7339df4e33ebf1d2843807d5c0e9a6b3c7fcf97e64f0fd85996, size---->3441
  +-digest----->sha256:4291c4b1093a597aea1a6c934c8181dcdf92fabcdc6e4718a3e7b2b7e6d9501e, size---->632
  +-digest----->sha256:260ee14152943d11ccc387cb8beba1cd67c9ef99bc85850e5cbafdd409f39194, size---->769
  +-digest----->sha256:14e997de83b1013b14c3923b7eb451fa171fe5818df87b2a16179377aeeb47a4, size---->198
  +-digest----->sha256:d618087695bb81c6304a9a626db60e1fe5b7407a21a3fad44b10ffe7a3627407, size---->19038236
  +-digest----->sha256:72bc7620beb76d6217871dfe818c87e3b1ca719c7fa4da122e29da5aedb59300, size---->19038236
  2   latest               sha256:59a49f6231bb626e3635081e89063f3eb157e9754c72bfe3a0175ac2e5fe704b   2017-01-05 14:49:29.28
tedsluis/busybox
digest-->sha256:33d4e9febf5fc657001d853313c565c8b37dcd234e8a282e186c23ea321b40ef, size-->12767
  +-digest----->sha256:6c953ac5d795ea26fd59dc5bdf4d335625c69f8bcfbdd8307d6009c2e61779c9, size---->65699277
  +-digest----->sha256:3eed5ff20a90a40b0cb7909e79128740f1320d29bec2ae9e025a1d375555db15, size---->71477
  +-digest----->sha256:f8419ea7c1b5d667cf26c2c5ec0bfb3502872e5afc6aa85caf2b8c7650bdc8d9, size---->360
  +-digest----->sha256:51900bc9e720db035e12f6c425dd9c06928a9d1eb565c86572b3aab93d24cfca, size---->681
  +-digest----->sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4, size---->32
  +-digest----->sha256:5278da6185578f852ea68c7d983afb91f6e90e88a742304164afc394ddf550b8, size---->28672572
  +-digest----->sha256:1210e80449372846aa56f76f0e3d2c68aa0b7cbb4f3440b40716b79c3d9f52df, size---->132193801
  +-digest----->sha256:1e7d364d050ce7f5afe2a1ab29d7f43e6e5f5892b5d0d3ab9b5c5665a4eb636e, size---->137101019
  +-digest----->sha256:f2c78af601e5d9a992805fae928ee8b0e662436788457da30fb1d254968b72de, size---->1323
  +-digest----->sha256:d8983ace4d177d682a66e2fbd39a32723a58ae5dc9c2b444a8ff74bd2e4fac46, size---->1345
  +-digest----->sha256:f447402282cf55dd8e483785347a97adcfffaedac9e64980f3ab044949e494ab, size---->1370
  +-digest----->sha256:c77c87047a0c9c00b919a0d8df08b7e84645e42d6f0d066e2c4a82dbc0d3e0c5, size---->1402
etc.......
````
