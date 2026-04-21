<script lang="ts">
  import * as CheerpX from "@leaningtech/cheerpx";
  import { onMount } from "svelte";
  import { Terminal } from '@xterm/xterm';
  import '@xterm/xterm/css/xterm.css';

  onMount(async () => {
    const term = new Terminal({ cols: 120, rows: 40, convertEol: true});
    term.open(document.getElementById('terminal'));

    const cloudDevice: CheerpX.HttpBytesDevice = await CheerpX.HttpBytesDevice.create(
      "/pvzImage.ext2"
    );
    const idbDevice: CheerpX.IDBDevice =
      await CheerpX.IDBDevice.create("block1");
    await idbDevice.reset()
    const overlayDevice: CheerpX.OverlayDevice =
      await CheerpX.OverlayDevice.create(cloudDevice, idbDevice);
    const cx: CheerpX.Linux = await CheerpX.Linux.create({
      mounts: [
        { type: "ext2", path: "/", dev: overlayDevice },
        { type:"devs", path:"/dev"},
        { type:"proc", path:"/proc"},
        { type:"sys", path:"/sys"}
      ],
    });
    // @ts-expect-error
    cx.setKmsCanvas(document.getElementById("canvas"), 1600, 900)
    
    const send = cx.setCustomConsole(
      (buf) => {
        term.write(new Uint8Array(buf));
      },
      term.cols,
      term.rows
    );

    term.onData((str) => {
      for (let i = 0; i < str.length; i++) {
        send(str.charCodeAt(i));
      }
    });

    await cx.run("/bin/bash", ["--login"], {
      env: [
        "HOME=/root",
        "USER=root",
        "SHELL=/bin/bash",
        "EDITOR=vim",
        "LANG=en_US.UTF-8",
        "LC_ALL=C",
      ],
      cwd: "/app",
      uid: 0,
      gid: 0,
    });
  })

</script>

<div id="terminal"></div>
<canvas id="canvas"></canvas>

<style>
  :global(html) {
    height: 100%;
  }
  :global(body) {
    height: 100%;
    margin: 0;
  }
  #canvas, #console {
    height: 100%;
    margin: 0;
  }
</style>
