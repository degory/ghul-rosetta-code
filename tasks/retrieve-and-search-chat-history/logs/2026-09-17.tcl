m 2026-09-16T22:05:57Z ijchain {*** dahu joins}
m 2026-09-16T22:09:00Z ijchain {*** sebres leaves}
m 2026-09-16T22:10:43Z ijchain {*** dahu leaves}
m 2026-09-16T22:13:27Z ijchain {*** dahu joins}
m 2026-09-16T22:29:21Z ijchain {*** xet7 joins}
m 2026-09-16T22:35:21Z {} {schelte has left}
m 2026-09-16T23:23:34Z {} {stevel has left}
m 2026-09-16T23:23:35Z {} {stevel has become available}
m 2026-09-16T23:45:05Z ijchain {*** KashinKoji- joins}
m 2026-09-16T23:45:43Z ijchain {*** KashinKoji leaves}
m 2026-09-17T00:19:04Z ijchain {«UptimeRobot» 🔴 **Incident started on [www.tcl-lang.org](http://www.tcl-lang.org)**}
m 2026-09-17T00:29:46Z ijchain {«UptimeRobot» 🟢 **Incident resolved on [www.tcl-lang.org](http://www.tcl-lang.org)**}
m 2026-09-17T01:13:10Z ijchain {*** dahu leaves}
m 2026-09-17T01:25:55Z {} {emiliano has left}
m 2026-09-17T02:15:48Z ijchain {*** dahu joins}
m 2026-09-17T02:27:14Z ijchain {*** greycat leaves}
m 2026-09-17T02:58:32Z ijchain {*** ftajhii joins}
m 2026-09-17T05:21:20Z ijchain {*** mrcalvin joins}
m 2026-09-17T05:25:21Z ijchain {*** dahu leaves}
m 2026-09-17T06:03:20Z ijchain {*** mayd joins}
m 2026-09-17T06:27:06Z {} {arjen has become available}
m 2026-09-17T06:27:53Z ijchain {«Arjen Markus» Good morning, everyone}
m 2026-09-17T06:38:16Z ijchain {*** Guest400000000 joins}
m 2026-09-17T06:44:03Z {} {arjen has left}
m 2026-09-17T07:06:42Z ijchain {«aku» morning. sun and clouds. 16C.}
m 2026-09-17T07:10:35Z ijchain {*** ewig joins}
m 2026-09-17T07:14:07Z cgm {Morning all, 14C, grey and wet.}
m 2026-09-17T07:16:32Z {} {daapp has become available}
m 2026-09-17T07:48:17Z {} {schelte has become available}
m 2026-09-17T08:26:05Z {} {oehhar has become available}
m 2026-09-17T08:27:44Z {} {oehhar has left}
m 2026-09-17T09:08:28Z {} {torsten has become available}
m 2026-09-17T09:09:12Z torsten {/me ~~~}
m 2026-09-17T09:17:58Z ijchain {*** sebres joins}
m 2026-09-17T09:45:39Z ijchain {*** mayd leaves}
m 2026-09-17T09:47:52Z ijchain {*** Guest400000000 leaves}
m 2026-09-17T11:32:27Z ijchain {*** mnja1 joins}
m 2026-09-17T11:32:31Z ijchain {*** mnja leaves}
m 2026-09-17T11:32:32Z ijchain {*** mnja1 is now known as mnja}
m 2026-09-17T11:45:36Z ijchain {*** CatchUpBot leaves}
m 2026-09-17T11:46:01Z ijchain {*** CatchUpBot joins}
m 2026-09-17T11:48:18Z ijchain {*** coldfeet joins}
m 2026-09-17T11:54:43Z {} {stu has become available}
m 2026-09-17T11:57:48Z stu {Morning, 14/cloudy}
m 2026-09-17T12:30:24Z ijchain {*** mrcalvin leaves}
m 2026-09-17T12:31:10Z ijchain {*** mrcalvin joins}
m 2026-09-17T12:58:33Z ijchain {*** mayd joins}
m 2026-09-17T13:13:04Z ijchain {*** mrcalvin leaves}
m 2026-09-17T13:14:24Z ijchain {*** dbohdan leaves}
m 2026-09-17T13:17:09Z ijchain {*** coldfeet leaves}
m 2026-09-17T13:17:10Z ijchain {*** dbohdan joins}
m 2026-09-17T13:23:42Z {} {de has become available}
m 2026-09-17T13:35:13Z ijchain {*** dbohdan leaves}
m 2026-09-17T13:36:06Z ijchain {*** dbohdan joins}
m 2026-09-17T13:36:42Z {} {emiliano has become available}
m 2026-09-17T13:40:32Z ijchain {<ijchain> mookie has created a new paste at http://paste.tclers.tk/6275 "nTUI in C"}
m 2026-09-17T13:54:13Z {} {emiliano has left}
m 2026-09-17T13:55:30Z {} {emiliano has become available}
m 2026-09-17T13:58:36Z ijchain {«Alan» Morning. 21C/ cloudy}
m 2026-09-17T14:14:00Z ijchain {*** coldfeet joins}
m 2026-09-17T14:22:42Z ijchain {«Alan» Hi folks, today I have two announcements!}
m 2026-09-17T14:22:43Z ijchain {«Alan» • FieldPack v1.0.0 (new) — a new C++/Tcl library I developed for compact buffer layouts of runtime-defined objects. Fieldpack defines compact buffer layouts for objects built from runtime-defined class schemas. Each schema describes field types, sizes, alignment, and memory positions. Each object uses one contiguous buffer for its schema ID and field data, while schema metadata}
m 2026-09-17T14:22:44Z ijchain {«ischain» handles field access and lifecycle without generated C++ classes. Access time was nearly identical to lists and up to 2.16x faster than dictionaries. Peak memory use was up to 3.10x lower than lists and 11.68x lower than dictionaries. [github.com/aaraujo-main/fieldpack](https://github.com/aaraujo-main/fieldpack)}
m 2026-09-17T14:22:45Z ijchain {«Alan» • VOO v1.1.0 — now it supports the new fieldpack layout in addition to the traditional default list layout and a new class_t field type, inheriting all the fieldpack compact memory advantages with a small tradeoff in field access and object contructors. Despite tradeoffs, bencharmaks shows new fieldpack keeps better time performance than TclOO, showing itself as more than 3x faster in}
m 2026-09-17T14:22:45Z ijchain {«ischain» parametrized constructor, 2x faster in getter, and 10x faster default object creation. In terms of memory, it improves VOO to be 1.27-1.39x lighter when compared to original list layout (which was already around 4x-10x ligther than TclOO) in nested fields scenarios, or scenarios where class has many fields. Finally, it keeps VOO's architectural advantages, including automatic memory}
m 2026-09-17T14:22:45Z ijchain {«ischain» dellocation and copy-on-write semantics. As an introspection addition to the API, now it is possible to retrieve the type for each field, including the class_t field information. [github.com/aaraujo-main/voo](https://github.com/aaraujo-main/voo)}
m 2026-09-17T14:25:31Z ijchain {«Alan» Feedbacks are very welcomed. Let me know if there is a feature you would like to see, or a case of use you would like to discuss}
m 2026-09-17T14:26:40Z ijchain {«Alan» @stu with the introspection information about the types, it is now possible to build generic functions to generate JSON or other formats from the object}
m 2026-09-17T14:27:41Z ijchain {*** sebres leaves}
m 2026-09-17T14:29:36Z ijchain {«Arjen Markus» cd ~ - have a nice chat, everyone}
m 2026-09-17T14:30:04Z ijchain {*** sebres joins}
m 2026-09-17T15:03:18Z stu {Alan, cool.}
m 2026-09-17T15:31:08Z {} {stu has left}
m 2026-09-17T15:35:11Z ijchain {*** bjorkintosh leaves}
m 2026-09-17T15:36:03Z ijchain {*** bjorkintosh joins}
m 2026-09-17T15:41:59Z ijchain {*** smlckz leaves}
m 2026-09-17T15:43:20Z ijchain {*** smlckz joins}
m 2026-09-17T15:53:22Z {} {emiliano has left}
m 2026-09-17T15:53:37Z {} {emiliano has become available}
m 2026-09-17T16:00:01Z ijchain {*** sebres_ joins}
m 2026-09-17T16:00:24Z ijchain {*** sebres leaves}
m 2026-09-17T16:09:32Z ijchain {*** dlowe_ is now known as dlowe}
m 2026-09-17T16:09:41Z ijchain {*** dlowe leaves}
m 2026-09-17T16:09:41Z ijchain {*** dlowe joins}
m 2026-09-17T16:18:54Z {} {emiliano has left}
m 2026-09-17T16:20:55Z ijchain {*** ewig leaves}
m 2026-09-17T16:22:24Z ijchain {*** ewig joins}
m 2026-09-17T17:27:57Z ijchain {*** Guest400000000 joins}
m 2026-09-17T17:29:49Z ijchain {*** coldfeet leaves}
m 2026-09-17T17:43:56Z {} {emiliano has become available}
m 2026-09-17T18:39:37Z ijchain {*** mayd leaves}
m 2026-09-17T18:40:08Z ijchain {*** mayd joins}
m 2026-09-17T18:43:34Z ijchain {*** ewig leaves}
m 2026-09-17T18:54:00Z ijchain {*** absc joins}
m 2026-09-17T18:55:13Z ijchain {*** Bradipo joins}
m 2026-09-17T19:49:47Z ijchain {*** Guest400000000 leaves}
m 2026-09-17T20:05:13Z {} {daapp has left}
m 2026-09-17T20:28:31Z ijchain {*** mrcalvin joins}
m 2026-09-17T21:18:53Z ijchain {<sebres_> gahr, here is an alternative variant with lazy loading of network.tcl (where the facilities placed) - https://core.tcl-lang.org/tcl/info/4d359e4dcf222bb3}
m 2026-09-17T21:19:00Z ijchain {*** sebres_ is now known as sebres}
m 2026-09-17T21:33:02Z ijchain {<gahr> sebres: fine either way.. I don't feel like we should over do it}
m 2026-09-17T21:33:39Z ijchain {<gahr> are you really assigning copyright to SUN, 95-96}
m 2026-09-17T21:33:50Z ijchain {<sebres> copy&paste}
m 2026-09-17T21:33:54Z ijchain {<gahr> :)}
m 2026-09-17T21:34:53Z ijchain {<gahr> I think tcltests is good enough.. I don't think auto-load will give us much, and it makes for yet another way to add support code in the tests}
m 2026-09-17T21:35:35Z ijchain {<sebres> regarding overdoing, I'm always against loading things preventively (tests without -singleproc would load stuff in every test per interp multiple times), even if user doesn't test this test at all}
m 2026-09-17T21:36:18Z ijchain {<sebres> try to start test-sute with -match 'no-match-here' and see how long it needs right now... I hate this in tcl}
m 2026-09-17T21:36:43Z ijchain {<sebres> in my fork this gets ready in few ms}
m 2026-09-17T21:41:16Z ijchain {<gahr> I value consistency more, I guess.. having a bit here and a bit there makes things harder to maintain}
m 2026-09-17T21:41:27Z ijchain {<gahr> it took me a while to figure tcltests.tcl was a thing}
m 2026-09-17T21:42:21Z ijchain {<gahr> but as I said, it's fine either way.. at the end of the day, I need the functionality}
m 2026-09-17T21:49:55Z ijchain {*** absc leaves}
