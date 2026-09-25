m 2026-09-19T22:12:37Z ijchain {*** ssh07322 leaves}
m 2026-09-19T22:13:48Z ijchain {*** ssh07322 joins}
m 2026-09-19T22:54:09Z {} {schelte has left}
m 2026-09-19T23:46:34Z ijchain {*** ssh07322 leaves}
m 2026-09-20T00:01:42Z ijchain {*** ewig leaves}
m 2026-09-20T00:05:36Z ijchain {*** ewig joins}
m 2026-09-20T00:31:07Z {} {emiliano has left}
m 2026-09-20T03:40:35Z ijchain {*** dahu joins}
m 2026-09-20T05:13:37Z {} {dburns has become available}
m 2026-09-20T05:51:51Z {} {dburns has left}
m 2026-09-20T06:35:14Z ijchain {*** dahu leaves}
m 2026-09-20T07:38:27Z ijchain {*** mayd joins}
m 2026-09-20T07:53:55Z ijchain {*** coldfeet joins}
m 2026-09-20T08:13:45Z ijchain {*** ssh07322 joins}
m 2026-09-20T08:22:50Z {} {schelte has become available}
m 2026-09-20T08:35:17Z {} {evilotto has become available}
m 2026-09-20T09:06:31Z ijchain {*** mtoy leaves}
m 2026-09-20T09:07:35Z ijchain {*** ssh07322 leaves}
m 2026-09-20T09:08:45Z ijchain {*** ssh07322 joins}
m 2026-09-20T09:14:44Z ijchain {*** mtoy joins}
m 2026-09-20T09:16:39Z ijchain {*** ssh07322 leaves}
m 2026-09-20T09:17:46Z ijchain {*** ssh07322 joins}
m 2026-09-20T09:57:25Z ijchain {*** Everything joins}
m 2026-09-20T10:08:32Z ijchain {*** ssh07322 leaves}
m 2026-09-20T10:09:45Z ijchain {*** ssh07322 joins}
m 2026-09-20T11:06:08Z ijchain {*** coldfeet leaves}
m 2026-09-20T11:19:07Z ijchain {*** sebres joins}
m 2026-09-20T11:43:40Z {} {evilotto has left: Disconnected: Hibernating too long}
m 2026-09-20T11:45:52Z ijchain {*** CatchUpBot leaves}
m 2026-09-20T11:46:04Z ijchain {*** CatchUpBot joins}
m 2026-09-20T12:18:25Z ijchain {*** coldfeet joins}
m 2026-09-20T12:32:39Z ijchain {*** coldfeet leaves}
m 2026-09-20T12:34:31Z {} {fvogel has become available}
m 2026-09-20T12:34:55Z {} {fvogel has left}
m 2026-09-20T12:34:58Z {} {fvogel has become available}
m 2026-09-20T12:36:55Z {} {fvogel has left}
m 2026-09-20T12:55:12Z ijchain {*** coldfeet joins}
m 2026-09-20T13:06:53Z ijchain {*** mayd leaves}
m 2026-09-20T13:07:10Z ijchain {*** mayd joins}
m 2026-09-20T13:08:06Z {} {dburns has become available}
m 2026-09-20T13:08:24Z {} {dburns has left}
m 2026-09-20T13:08:31Z {} {dburns has become available}
m 2026-09-20T13:47:22Z ijchain {*** sebres leaves}
m 2026-09-20T14:25:41Z ijchain {*** Everything leaves}
m 2026-09-20T14:28:11Z ijchain {*** km leaves}
m 2026-09-20T14:47:51Z ijchain {<ijchain> iobates has created a new paste at http://paste.tclers.tk/6276 "nested dir add to calibre"}
m 2026-09-20T14:48:23Z ijchain {<iobates> This is probably due to me not being all that good at tcl, but I do not understand why this behaves like this}
m 2026-09-20T14:49:00Z ijchain {<iobates> puts $books actually lists a decent amount of books in a list, but returning returns an empty list, which has me scratching my head}
m 2026-09-20T14:49:14Z {} {stu has become available}
m 2026-09-20T14:50:36Z stu {You're throwing away the return values of the nested calls}
m 2026-09-20T14:51:41Z schelte {Line 5}
m 2026-09-20T14:53:21Z {} {stu has left}
m 2026-09-20T14:57:13Z ijchain {<iobates> yeah that is correct, thanks}
m 2026-09-20T15:00:25Z ijchain {*** mrcalvin joins}
m 2026-09-20T15:02:52Z ijchain {<iobates> though I don't see what would best to set the return to...}
m 2026-09-20T15:03:18Z {} {dburns has left}
m 2026-09-20T15:06:14Z cgm {change line 5 to:
    lappend books {*}[list-files-recur $fil]}
m 2026-09-20T15:07:53Z ijchain {<iobates> why is it I keep forgetting {*} in cases where it is this useful, obviously this is a nice way to express what I want...}
m 2026-09-20T15:09:18Z ijchain {<iobates> but thanks all the same cgm :)}
m 2026-09-20T15:09:35Z cgm :-)
m 2026-09-20T15:09:38Z ijchain {<iobates> now it works wonderfully }
m 2026-09-20T15:12:23Z ijchain {<iobates> pretty soon I have sanded down all the rough edges of this little utility}
m 2026-09-20T15:14:23Z ijchain {*** coldfeet leaves}
m 2026-09-20T15:40:28Z ijchain {*** km joins}
m 2026-09-20T15:48:09Z {} {daapp has become available}
m 2026-09-20T16:44:36Z {} {dburns has become available}
m 2026-09-20T16:47:36Z ijchain {*** xet7 leaves}
m 2026-09-20T16:59:57Z ijchain {*** mrcalvin leaves}
m 2026-09-20T17:07:38Z ijchain {*** mrcalvin joins}
m 2026-09-20T17:07:38Z ijchain {*** mrcalvin leaves}
m 2026-09-20T17:15:27Z ijchain {*** dlowe leaves}
m 2026-09-20T17:33:04Z ijchain {*** xet7 joins}
m 2026-09-20T17:33:04Z ijchain {*** coldfeet_ joins}
m 2026-09-20T17:42:31Z ijchain {*** xet7 leaves}
m 2026-09-20T17:54:34Z ijchain {*** xet7 joins}
m 2026-09-20T17:59:27Z ijchain {*** xet7 leaves}
m 2026-09-20T18:10:01Z {} {dburns has left}
m 2026-09-20T18:11:04Z ijchain {*** xet7 joins}
m 2026-09-20T18:17:27Z ijchain {*** xet7 leaves}
m 2026-09-20T18:21:08Z {} {emiliano has become available}
m 2026-09-20T18:24:51Z ijchain {*** ssh07322 leaves}
m 2026-09-20T19:06:44Z ijchain {*** mrcalvin joins}
m 2026-09-20T19:07:01Z ijchain {*** mrcalvin leaves}
m 2026-09-20T19:10:35Z ijchain {*** mrcalvin joins}
m 2026-09-20T19:22:51Z {} {emiliano has left}
m 2026-09-20T19:23:13Z {} {emiliano has become available}
m 2026-09-20T19:23:27Z ijchain {*** mrcalvin leaves}
m 2026-09-20T19:24:55Z ijchain {*** mrcalvin joins}
m 2026-09-20T19:30:07Z ijchain {*** coldfeet_ leaves}
m 2026-09-20T19:30:23Z ijchain {*** bjorkintosh leaves}
m 2026-09-20T19:33:28Z ijchain {*** ewig leaves}
m 2026-09-20T19:37:27Z ijchain {*** mrcalvin leaves}
m 2026-09-20T19:41:22Z ijchain {*** jjakob leaves}
m 2026-09-20T19:49:24Z ijchain {*** mrcalvin joins}
m 2026-09-20T20:02:18Z ijchain {*** xet7 joins}
m 2026-09-20T20:12:03Z ijchain {*** bjorkintosh joins}
m 2026-09-20T20:56:09Z ijchain {*** xet7 leaves}
m 2026-09-20T21:50:49Z ijchain {*** dlowe joins}
m 2026-09-20T21:51:55Z {} {daapp has left}
m 2026-09-20T21:56:09Z ijchain {*** dahu joins}
m 2026-09-20T21:56:38Z ijchain {*** mrcalvin leaves}
