m 2026-09-20T22:15:48Z {} {schelte has left}
m 2026-09-20T22:28:32Z ijchain {*** dahu leaves}
m 2026-09-20T22:45:28Z ijchain {*** xet7 joins}
m 2026-09-20T22:59:39Z ijchain {*** iobates leaves}
m 2026-09-20T23:42:08Z ijchain {*** darfo leaves}
m 2026-09-20T23:43:13Z ijchain {*** darfo joins}
m 2026-09-21T00:01:47Z {} {emiliano has left}
m 2026-09-21T00:17:18Z ijchain {«UptimeRobot» 🔴 **Incident started on [www.tcl-lang.org](http://www.tcl-lang.org)**}
m 2026-09-21T00:19:44Z ijchain {<oldlaptop> < HTTP/2 522}
m 2026-09-21T00:19:44Z ijchain {<oldlaptop> (That's a new one to me)}
m 2026-09-21T00:19:53Z ijchain {<oldlaptop> The mysteries of cloudflare?}
m 2026-09-21T00:23:26Z ijchain {<oldlaptop> Huh. I thought it usually served an actual error page for that. (You know, the shiny "Your computer [green check] -> Cloudflare [green check] -> Actual server [scary red X]" thing.) https://developers.cloudflare.com/support/troubleshooting/http-status-codes/cloudflare-5xx-errors/error-522/}
m 2026-09-21T00:24:53Z ijchain {<oldlaptop> still sets a 24-hour cookie with the "ray" for some reason (will browsers even honor that without an actual body?)}
m 2026-09-21T00:38:58Z ijchain {«UptimeRobot» 🟢 **Incident resolved on [www.tcl-lang.org](http://www.tcl-lang.org)**}
m 2026-09-21T01:17:20Z {} {evilotto has become available}
m 2026-09-21T02:23:30Z stevel {the 522 is not coming from cloudflare - it is coming from the monitoring service (which is located in Germany). My guess is that there is a network error between the monitor and cloudflare not between cloudflare and the server.}
m 2026-09-21T02:23:47Z stevel {the server itself seems ok}
m 2026-09-21T02:24:06Z ijchain {<oldlaptop> O_o}
m 2026-09-21T02:25:06Z ijchain {<oldlaptop> why would traffic to the website actually go through the monitor service, though?}
m 2026-09-21T02:25:30Z ijchain {<oldlaptop> (for clarity I got HTTP 522s with empty bodies from actual requests to https://www.tcl-lang.org)}
m 2026-09-21T02:25:50Z ijchain {<oldlaptop> it's working fine again now}
m 2026-09-21T02:39:55Z stevel {no idea, but I've been getting the same from some of my other linodes}
m 2026-09-21T02:40:10Z stevel {possible a different issue}
m 2026-09-21T03:24:59Z {} {dburns has become available}
m 2026-09-21T03:24:59Z {} {dburns has left}
m 2026-09-21T04:33:52Z ijchain {*** ircuser-1 leaves}
m 2026-09-21T04:41:32Z ijchain {*** MillerBOSS leaves}
m 2026-09-21T04:42:16Z ijchain {*** ischain leaves}
m 2026-09-21T04:48:15Z ijchain {*** MillerBOSS joins}
m 2026-09-21T05:32:54Z ijchain {*** mrcalvin joins}
m 2026-09-21T06:30:56Z ijchain {*** mrcalvin leaves}
m 2026-09-21T06:42:49Z ijchain {*** coldfeet joins}
m 2026-09-21T06:51:01Z ijchain {*** coldfeet leaves}
m 2026-09-21T06:51:24Z {} {daapp has become available}
m 2026-09-21T07:07:18Z {} {arjen has become available}
m 2026-09-21T07:07:29Z {} {arjen has left}
m 2026-09-21T07:08:14Z ijchain {«Arjen Markus» Good morning, everyone}
m 2026-09-21T07:18:12Z ijchain {*** mayd leaves}
m 2026-09-21T07:19:36Z ijchain {*** mayd joins}
m 2026-09-21T07:19:42Z ijchain {*** mayd leaves}
m 2026-09-21T07:20:11Z ijchain {*** mayd joins}
m 2026-09-21T07:35:03Z ijchain {*** sebres joins}
m 2026-09-21T07:41:11Z {} {torsten has become available}
m 2026-09-21T07:41:47Z torsten {/me ~~~}
m 2026-09-21T08:13:47Z ijchain {*** mayd leaves}
m 2026-09-21T08:21:42Z torsten {Does anyone know this person serhiy.storchaka who did these fixes on Tk using AI (at leat AI is documented for one commit https://core.tcl-lang.org/tk/info/f788bf2637805cf6)?}
m 2026-09-21T08:26:23Z torsten {is this the one top contributor to Python?}
m 2026-09-21T08:47:09Z ijchain {*** Kooda leaves}
m 2026-09-21T08:48:11Z torsten {This would at least explain the interest in Tk (probably via Tkinter)}
m 2026-09-21T08:52:43Z ijchain {*** Kooda joins}
m 2026-09-21T09:36:20Z ijchain {*** mrcalvin joins}
m 2026-09-21T09:57:19Z {} {evilotto has left: Disconnected: Hibernating too long}
m 2026-09-21T10:01:27Z ijchain {*** mrcalvin leaves}
m 2026-09-21T10:04:15Z {} {stevel has left}
m 2026-09-21T10:04:16Z {} {stevel has become available}
m 2026-09-21T10:40:16Z {} {schelte has become available}
m 2026-09-21T11:09:59Z {} {stevel has left}
m 2026-09-21T11:10:00Z {} {stevel has become available}
m 2026-09-21T11:43:33Z ijchain {*** iobates joins}
m 2026-09-21T11:45:58Z ijchain {*** CatchUpBot leaves}
m 2026-09-21T11:46:09Z ijchain {*** CatchUpBot joins}
m 2026-09-21T11:55:25Z {} {torsten has left}
m 2026-09-21T11:55:29Z {} {torsten has become available}
m 2026-09-21T11:55:50Z torsten {/me afk}
m 2026-09-21T11:58:39Z {} {oehhar has become available}
m 2026-09-21T11:59:05Z {} {oehhar has left}
m 2026-09-21T12:04:25Z ijchain {*** shawnw leaves}
m 2026-09-21T12:12:41Z ijchain {*** sebres leaves}
m 2026-09-21T12:52:17Z {} {oehhar has become available}
m 2026-09-21T12:52:51Z oehhar {@torsten: yes, that is also my knowledge}
m 2026-09-21T12:53:23Z oehhar {@Arjen: thanks for the proposal to send direct. but apparently, he registered to the core list and then he gets it twice...}
m 2026-09-21T12:56:44Z {} {oehhar has left}
m 2026-09-21T13:00:11Z {} {stu has become available}
m 2026-09-21T13:02:34Z stu {Morning, 10/cloudy}
m 2026-09-21T13:21:33Z ijchain {*** mrcalvin joins}
m 2026-09-21T13:35:49Z ijchain {*** mrcalvin leaves}
m 2026-09-21T13:46:13Z ijchain {«Arjen Markus» Yes, I noticed something of the kind. Well, better this way than that he/she feels ignored 🙂.}
m 2026-09-21T13:46:27Z ijchain {«Arjen Markus» Anyway, cd ~ - have a nice chat, everyone}
m 2026-09-21T13:47:31Z {} {emiliano has become available}
m 2026-09-21T14:02:53Z {} {teo has left: Disconnected: Replaced by new connection}
m 2026-09-21T14:02:53Z {} {teo has become available}
m 2026-09-21T14:05:10Z {} {stu has left}
m 2026-09-21T14:18:06Z ijchain {*** sebres joins}
m 2026-09-21T14:41:37Z {} {oehhar has become available}
m 2026-09-21T14:42:11Z oehhar {@stevel : I was blocked while editing a TCL ticket by cloudflare: Cloudflare Ray ID: a3e9d427bd4f8a82}
m 2026-09-21T14:42:52Z oehhar {I made two tried and aborted. Of cause, I can operate via fossil offline and push the ticket change up...}
m 2026-09-21T14:43:30Z oehhar {And a new tkchat without the hard coded emoji-path for MS-Win would be great...}
m 2026-09-21T14:43:36Z {} {oehhar has left}
m 2026-09-21T14:45:36Z emiliano {disable with menu "emoticons" -> "use emoticons"}
m 2026-09-21T14:49:13Z ijchain {*** shawnw joins}
m 2026-09-21T14:56:39Z ijchain {*** tbcr leaves}
m 2026-09-21T14:57:03Z ijchain {*** tbcr joins}
m 2026-09-21T15:13:24Z {} {emiliano2 has become available}
m 2026-09-21T15:13:26Z {} {emiliano2 has left}
m 2026-09-21T15:16:03Z {} {emiliano2 has become available}
m 2026-09-21T15:16:05Z {} {emiliano2 has left}
m 2026-09-21T15:20:06Z {} {emiliano2 has become available}
m 2026-09-21T15:49:26Z {} {emiliano2 has left: Disconnected: closed}
m 2026-09-21T15:57:54Z ijchain {*** ircuser-1 joins}
m 2026-09-21T15:58:28Z {} {torsten has left}
m 2026-09-21T16:52:42Z ijchain {*** mrcalvin joins}
m 2026-09-21T16:57:40Z {} {emiliano2 has become available}
m 2026-09-21T17:21:14Z ijchain {*** mrcalvin leaves}
m 2026-09-21T17:35:50Z kevin_walzer {@oehar - I am VERY busy right now. New binaries for TkChat will come after 9.1 is released.}
m 2026-09-21T17:40:32Z ijchain {*** km leaves}
m 2026-09-21T17:40:32Z ijchain {*** KashinKoji- leaves}
m 2026-09-21T17:40:33Z ijchain {*** sivoais leaves}
m 2026-09-21T17:40:33Z ijchain {*** Dereckson leaves}
m 2026-09-21T17:40:33Z ijchain {*** boubbin leaves}
m 2026-09-21T17:40:33Z ijchain {*** johnnyreb leaves}
m 2026-09-21T17:42:10Z ijchain {*** km joins}
m 2026-09-21T17:42:10Z ijchain {*** KashinKoji- joins}
m 2026-09-21T17:42:10Z ijchain {*** sivoais joins}
m 2026-09-21T17:42:10Z ijchain {*** Dereckson joins}
m 2026-09-21T17:42:10Z ijchain {*** boubbin joins}
m 2026-09-21T17:42:10Z ijchain {*** johnnyreb joins}
m 2026-09-21T17:42:22Z ijchain {*** km leaves}
m 2026-09-21T17:42:22Z ijchain {*** sivoais leaves}
m 2026-09-21T17:42:31Z ijchain {*** sivoais_ joins}
m 2026-09-21T17:42:39Z ijchain {*** km joins}
m 2026-09-21T18:14:04Z ijchain {*** raj joins}
m 2026-09-21T18:17:14Z {} {emiliano2 has left: Disconnected: closed}
m 2026-09-21T18:23:22Z {} {emiliano2 has become available}
m 2026-09-21T18:58:04Z ijchain {*** gahr leaves}
m 2026-09-21T18:59:27Z ijchain {*** gahr joins}
m 2026-09-21T19:45:03Z ijchain {*** ssh07322 joins}
m 2026-09-21T20:11:23Z emiliano .
m 2026-09-21T20:16:13Z {} {emiliano2 has left: Disconnected: closed}
m 2026-09-21T20:23:16Z ijchain {*** ssh07322 leaves}
m 2026-09-21T20:25:21Z ijchain {*** ssh07322 joins}
m 2026-09-21T20:26:48Z {} {daapp has left}
m 2026-09-21T21:50:58Z {} {emiliano2 has become available}
